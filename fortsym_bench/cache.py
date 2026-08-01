"""Persistent cache for the independent reference backends.

The reference answers are deterministic for a fixed source file and backend
configuration, but Mathics is deliberately run in a subprocess and is much
more expensive than the local candidate. Keep successful answers and named
failures on disk so a later scoring pass does not rerun either oracle.
"""

from __future__ import annotations

import hashlib
import json
import os
import tempfile
from dataclasses import dataclass
from pathlib import Path

from .backends import Backend, RunFailure

CACHE_VERSION = 1


@dataclass(frozen=True)
class CachedReference:
    """One cached oracle result or failure."""

    results: dict | None = None
    failure: RunFailure | None = None


class ReferenceCache:
    """Read and atomically update cached reference-backend outcomes."""

    def __init__(self, path: Path):
        self.path = Path(path)
        self._entries: dict[str, dict] = {}
        self._load()

    def get(
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
                    if (
                        candidate.get("outcome") == "ok"
                        or candidate.get("timeout") == timeout
                    ):
                        if candidate.get("cache_version", 1) == backend.cache_version:
                            entry = candidate
                            break
        if entry is not None and entry.get("cache_version", 1) != backend.cache_version:
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
        self._entries[self._key(backend, source)] = {
            "backend": backend.name,
            "cache_version": backend.cache_version,
            "source": self._display_source(source),
            "source_sha256": _sha256(source.read_bytes()),
            "timeout": timeout,
            "outcome": "ok",
            "results": results,
        }
        self._save()

    def put_failure(
        self,
        backend: Backend,
        source: Path,
        timeout: float,
        failure: RunFailure,
    ) -> None:
        self._entries[self._key(backend, source)] = {
            "backend": backend.name,
            "cache_version": backend.cache_version,
            "source": self._display_source(source),
            "source_sha256": _sha256(source.read_bytes()),
            "timeout": timeout,
            "outcome": "failure",
            "failure": {"kind": failure.kind, "detail": str(failure)},
        }
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
    def _display_source(source: Path) -> str:
        try:
            return source.resolve().relative_to(Path.cwd().resolve()).as_posix()
        except ValueError:
            return str(source.resolve())


def _sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()
