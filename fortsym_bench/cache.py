"""Persistent cache for deterministic backend results.

The reference answers and native candidate results are deterministic for a
fixed source file and backend configuration. Keep successful answers and named
failures on disk so a later scoring pass reruns only entries whose source or
executable changed. Timing is deliberately not cached: a cached row is not a
fresh performance measurement.
"""

from __future__ import annotations

import hashlib
import json
import os
import shutil
import tempfile
from dataclasses import dataclass
from pathlib import Path
from threading import RLock

from .backends import Backend, RunFailure

CACHE_VERSION = 1
COMPARISON_CACHE_VERSION = 1


@dataclass(frozen=True)
class CachedReference:
    """One cached backend result or failure.

    The name is retained for compatibility with callers that used the cache
    while it held reference results only.
    """

    results: dict | None = None
    failure: RunFailure | None = None


class ReferenceCache:
    """Read and atomically update cached reference-backend outcomes."""

    def __init__(self, path: Path, *, autosave: bool = True):
        self.path = Path(path)
        self.autosave = autosave
        self._lock = RLock()
        self._entries: dict[str, dict] = {}
        self._backend_fingerprints: dict[str, str] = {}
        self._load()

    def get(
        self, backend: Backend, source: Path, timeout: float
    ) -> CachedReference | None:
        with self._lock:
            return self._get(backend, source, timeout)

    def _get(
        self, backend: Backend, source: Path, timeout: float
    ) -> CachedReference | None:
        entry = self._entries.get(self._key(backend, source))
        if entry is None:
            # Cache files written by version 1 included the timeout in their
            # key. Read those entries during the transition so a long seed
            # run is not discarded merely because the next pass uses its
            # normal timeout.
            entry = self._entries.get(self._legacy_key(backend, source, timeout))
        if entry is None:
            # A successful version-1 entry is valid at every later timeout.
            # Look it up by its stored identity when the requested timeout is
            # different; timeout failures remain restricted to their original
            # limit below.
            display = self._display_source(source)
            digest = _sha256(source.read_bytes())
            for candidate in reversed(tuple(self._entries.values())):
                if (
                    candidate.get("backend") == backend.name
                    and candidate.get("source") == display
                    and candidate.get("source_sha256") == digest
                ):
                    if not self._execution_compatible(backend, candidate):
                        continue
                    if (
                        candidate.get("outcome") == "ok"
                        or candidate.get("timeout") == timeout
                    ):
                        if self._cache_version_compatible(backend, candidate):
                            entry = candidate
                            break
        if entry is not None and not self._cache_version_compatible(backend, entry):
            entry = None
        if entry is None:
            return None
        if entry.get("outcome") == "ok":
            results = entry.get("results")
            if isinstance(results, dict):
                return CachedReference(results=results)
            return None
        if entry.get("outcome") == "failure":
            failure = entry.get("failure")
            if isinstance(failure, dict):
                kind = failure.get("kind")
                detail = failure.get("detail")
                if isinstance(kind, str) and isinstance(detail, str):
                    if kind == "timeout" and entry.get("timeout") != timeout:
                        return None
                    return CachedReference(failure=RunFailure(kind, detail))
        return None

    def put_result(
        self,
        backend: Backend,
        source: Path,
        timeout: float,
        results: dict,
    ) -> None:
        with self._lock:
            self._entries[self._key(backend, source)] = {
                "backend": backend.name,
                "cache_version": backend.cache_version,
                "source": self._display_source(source),
                "source_sha256": _sha256(source.read_bytes()),
                "execution_fingerprint": self._execution_fingerprint(backend),
                "timeout": timeout,
                "outcome": "ok",
                "results": results,
            }
            if self.autosave:
                self._save()

    def put_failure(
        self,
        backend: Backend,
        source: Path,
        timeout: float,
        failure: RunFailure,
    ) -> None:
        with self._lock:
            self._entries[self._key(backend, source)] = {
                "backend": backend.name,
                "cache_version": backend.cache_version,
                "source": self._display_source(source),
                "source_sha256": _sha256(source.read_bytes()),
                "execution_fingerprint": self._execution_fingerprint(backend),
                "timeout": timeout,
                "outcome": "failure",
                "failure": {"kind": failure.kind, "detail": str(failure)},
            }
            if self.autosave:
                self._save()

    def flush(self) -> None:
        """Persist deferred updates as one atomic cache replacement."""
        with self._lock:
            self._save()

    def _load(self) -> None:
        if not self.path.exists():
            return
        try:
            payload = json.loads(self.path.read_text())
            if payload.get("version") != CACHE_VERSION:
                return
            entries = payload.get("entries")
            if isinstance(entries, dict):
                self._entries = entries
        except (OSError, json.JSONDecodeError, AttributeError):
            # A truncated cache must never make a benchmark unusable. The next
            # completed reference run replaces it with a valid document.
            self._entries = {}

    def _save(self) -> None:
        self.path.parent.mkdir(parents=True, exist_ok=True)
        fd, temporary = tempfile.mkstemp(
            prefix=f".{self.path.name}.",
            suffix=".tmp",
            dir=self.path.parent,
        )
        try:
            with os.fdopen(fd, "w") as stream:
                json.dump(
                    {"version": CACHE_VERSION, "entries": self._entries},
                    stream,
                    indent=1,
                    sort_keys=True,
                )
                stream.write("\n")
            os.replace(temporary, self.path)
        finally:
            if os.path.exists(temporary):
                os.unlink(temporary)

    def _key(self, backend: Backend, source: Path) -> str:
        identity = {
            "backend": backend.name,
            "source_kind": backend.source,
            "syntax": backend.syntax,
            "command": backend.command,
            "cache_version": backend.cache_version,
            "execution_fingerprint": self._execution_fingerprint(backend),
            "source": self._display_source(source),
            "source_sha256": _sha256(source.read_bytes()),
        }
        encoded = json.dumps(identity, sort_keys=True).encode()
        return hashlib.sha256(encoded).hexdigest()

    def _legacy_key(
        self, backend: Backend, source: Path, timeout: float
    ) -> str:
        identity = {
            "backend": backend.name,
            "source_kind": backend.source,
            "syntax": backend.syntax,
            "command": backend.command,
            "source": self._display_source(source),
            "source_sha256": _sha256(source.read_bytes()),
            "timeout": timeout,
        }
        encoded = json.dumps(identity, sort_keys=True).encode()
        return hashlib.sha256(encoded).hexdigest()

    @staticmethod
    def _cache_version_compatible(backend: Backend, entry: dict) -> bool:
        """Accept Mathics answers across the protocol-only cache bump.

        Version 3 changed only the parser's treatment of a valid ``T`` line
        with no ``R`` lines. Successful older Mathics answers and named old
        failures remain valid; the old ``no results parsed`` failures are the
        one class that must be rerun because they may actually be empty result
        sets under the new protocol.
        """
        version = entry.get("cache_version", 1)
        if version == backend.cache_version:
            return True
        if backend.name != "mathics" or version > backend.cache_version:
            return False
        if entry.get("outcome") != "failure":
            return True
        detail = entry.get("failure", {}).get("detail", "")
        return not detail.startswith("no results parsed")

    def _execution_fingerprint(self, backend: Backend) -> str:
        """Identify the executable that can change a subprocess result.

        Reference entries written before executable fingerprints are accepted
        by the compatibility path above. New native entries include the
        binary digest, so rebuilding fortsym invalidates its result cache
        without forcing a fresh Mathics/SymPy run.
        """
        cached = self._backend_fingerprints.get(backend.name)
        if cached is not None:
            return cached

        if backend.command:
            executable = shutil.which(backend.command[0])
            if executable is None:
                fingerprint = f"missing:{backend.command[0]}"
            else:
                path = Path(executable).resolve()
                try:
                    fingerprint = f"{path}:{_sha256(path.read_bytes())}"
                except OSError:
                    fingerprint = f"{path}:unreadable"
        else:
            # The Python runner is part of this repository and the oracle
            # cache version covers changes to its protocol. Include the
            # interpreter so switching virtual environments cannot silently
            # reuse a result produced by a different runtime.
            interpreter = Path(os.path.realpath(os.sys.executable))
            try:
                digest = _sha256(interpreter.read_bytes())
            except OSError:
                digest = "unreadable"
            fingerprint = f"{interpreter}:{digest}"

        self._backend_fingerprints[backend.name] = fingerprint
        return fingerprint

    def _execution_compatible(self, backend: Backend, entry: dict) -> bool:
        """Check a new executable fingerprint, preserving old cache files."""
        stored = entry.get("execution_fingerprint")
        return stored is None or stored == self._execution_fingerprint(backend)

    @staticmethod
    def _display_source(source: Path) -> str:
        try:
            return source.resolve().relative_to(Path.cwd().resolve()).as_posix()
        except ValueError:
            return str(source.resolve())


def _sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


class ComparisonCache:
    """Persist parsed comparison verdicts independently of raw backend rows."""

    def __init__(self, path: Path, *, autosave: bool = True):
        self.path = Path(path)
        self.autosave = autosave
        self._lock = RLock()
        self._entries: dict[str, dict[str, str]] = {}
        self._load()

    def get(
        self,
        candidate_text: str,
        candidate_syntax: str,
        reference_text: str,
        reference_syntax: str,
        strictness: str,
    ) -> tuple[str, str] | None:
        with self._lock:
            entry = self._entries.get(
                self._key(
                    candidate_text,
                    candidate_syntax,
                    reference_text,
                    reference_syntax,
                    strictness,
                )
            )
            if entry is None:
                return None
            outcome, detail = entry.get("outcome"), entry.get("detail")
            if not isinstance(outcome, str) or not isinstance(detail, str):
                return None
            return outcome, detail

    def put(
        self,
        candidate_text: str,
        candidate_syntax: str,
        reference_text: str,
        reference_syntax: str,
        strictness: str,
        outcome: str,
        detail: str,
    ) -> None:
        with self._lock:
            self._entries[
                self._key(
                    candidate_text,
                    candidate_syntax,
                    reference_text,
                    reference_syntax,
                    strictness,
                )
            ] = {"outcome": outcome, "detail": detail}
            if self.autosave:
                self._save()

    def flush(self) -> None:
        with self._lock:
            self._save()

    def _load(self) -> None:
        if not self.path.exists():
            return
        try:
            payload = json.loads(self.path.read_text())
            if payload.get("version") != COMPARISON_CACHE_VERSION:
                return
            entries = payload.get("entries")
            if isinstance(entries, dict):
                self._entries = entries
        except (OSError, json.JSONDecodeError, AttributeError):
            self._entries = {}

    def _save(self) -> None:
        self.path.parent.mkdir(parents=True, exist_ok=True)
        fd, temporary = tempfile.mkstemp(
            prefix=f".{self.path.name}.",
            suffix=".tmp",
            dir=self.path.parent,
        )
        try:
            with os.fdopen(fd, "w") as stream:
                json.dump(
                    {"version": COMPARISON_CACHE_VERSION, "entries": self._entries},
                    stream,
                    indent=1,
                    sort_keys=True,
                )
                stream.write("\n")
            os.replace(temporary, self.path)
        finally:
            if os.path.exists(temporary):
                os.unlink(temporary)

    @staticmethod
    def _key(
        candidate_text: str,
        candidate_syntax: str,
        reference_text: str,
        reference_syntax: str,
        strictness: str,
    ) -> str:
        identity = {
            "version": COMPARISON_CACHE_VERSION,
            "candidate_sha256": _sha256(candidate_text.encode()),
            "candidate_syntax": candidate_syntax,
            "reference_sha256": _sha256(reference_text.encode()),
            "reference_syntax": reference_syntax,
            "strictness": strictness,
        }
        return hashlib.sha256(json.dumps(identity, sort_keys=True).encode()).hexdigest()
