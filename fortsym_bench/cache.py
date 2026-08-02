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
# Bump when comparison parsing/equivalence semantics change; raw backend rows
# remain reusable while verdicts are recomputed from their cached operands.
COMPARISON_CACHE_VERSION = 15


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
        self._dirty = False
        # Keep write order so a refresh can discard superseded source rows
        # without guessing which hash-keyed entry is newest.
        self._touched_keys: list[str] = []
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
            key = self._key(backend, source)
            self._entries[key] = {
                "backend": backend.name,
                "cache_version": backend.cache_version,
                "source": self._display_source(source),
                "source_sha256": _sha256(source.read_bytes()),
                "execution_fingerprint": self._execution_fingerprint(backend),
                "timeout": timeout,
                "outcome": "ok",
                "results": results,
            }
            self._remember_touched(key)
            self._dirty = True
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
            key = self._key(backend, source)
            self._entries[key] = {
                "backend": backend.name,
                "cache_version": backend.cache_version,
                "source": self._display_source(source),
                "source_sha256": _sha256(source.read_bytes()),
                "execution_fingerprint": self._execution_fingerprint(backend),
                "timeout": timeout,
                "outcome": "failure",
                "failure": {"kind": failure.kind, "detail": str(failure)},
            }
            self._remember_touched(key)
            self._dirty = True
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
        if not self._dirty:
            return
        if self.autosave:
            self._prune_superseded_rows()
        else:
            # The CLI batches writes specifically so a full audit does not
            # rewrite a multi-hundred-megabyte JSON file once per row. Its
            # single flush is also the safe point to compact untouched
            # historical rows left by earlier cache versions.
            self._compact_compatible_rows()
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
            self._dirty = False
        finally:
            if os.path.exists(temporary):
                os.unlink(temporary)

    def _remember_touched(self, key: str) -> None:
        if key not in self._touched_keys:
            self._touched_keys.append(key)

    def _prune_superseded_rows(self) -> None:
        """Drop old versions after a source/backend has been refreshed.

        The cache key deliberately includes source and executable identity, so
        a rebuilt native binary or translated Python companion creates a new
        row. Keeping every historical row made the JSON cache grow without
        bound and slowed every warm audit. Only identities touched in this
        cache instance are pruned; untouched compatible rows remain available
        for a later run with a different timeout.
        """
        if not self._touched_keys:
            return

        keep: dict[tuple[object, object], str] = {}
        for key in self._touched_keys:
            entry = self._entries.get(key)
            if entry is None:
                continue
            identity = (entry.get("backend"), entry.get("source"))
            keep[identity] = key

        for key, entry in tuple(self._entries.items()):
            identity = (entry.get("backend"), entry.get("source"))
            if identity in keep and key != keep[identity]:
                del self._entries[key]
        self._touched_keys.clear()

    def _compact_compatible_rows(self) -> None:
        """Keep one reusable row per backend/source pair.

        The current cache key is preferred when the source is still present.
        Otherwise retain the highest compatible version, which preserves old
        successful Mathics rows across the protocol-only compatibility bump.
        Unknown backends are compacted by newest cache order as a fallback.
        """
        from .backends import BACKENDS

        groups: dict[tuple[object, object], list[tuple[str, dict]]] = {}
        for key, entry in self._entries.items():
            identity = (entry.get("backend"), entry.get("source"))
            groups.setdefault(identity, []).append((key, entry))

        compacted: dict[str, dict] = {}
        for (backend_name, displayed_source), candidates in groups.items():
            chosen: tuple[str, dict] | None = None
            backend = BACKENDS.get(backend_name)
            source = Path(displayed_source) if isinstance(displayed_source, str) else None
            if backend is not None and source is not None and source.exists():
                current_key = self._key(backend, source)
                chosen = next(
                    (candidate for candidate in candidates if candidate[0] == current_key),
                    None,
                )

            if chosen is None and backend is not None:
                compatible = [
                    candidate
                    for candidate in candidates
                    if self._cache_version_compatible(backend, candidate[1])
                    and self._execution_compatible(backend, candidate[1])
                ]
                if compatible:
                    chosen = max(
                        enumerate(compatible),
                        key=lambda item: (
                            item[1][1].get("cache_version", 1),
                            item[1][1].get("outcome") == "ok",
                            item[0],
                        ),
                    )[1]

            if chosen is None:
                chosen = candidates[-1]
            compacted[chosen[0]] = chosen[1]

        self._entries = compacted
        self._touched_keys.clear()

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
        """Accept cache rows whose semantic change does not affect the source.

        Version 3 changed only the parser's treatment of a valid ``T`` line
        with no ``R`` lines. Version 4 isolates the wrapper's protocol marker
        and harness symbols. Successful older Mathics answers and named old
        failures remain valid; the old ``no results parsed`` failures are the
        one class that must be rerun because they may actually be empty result
        sets under the new protocol.

        SymPy version 10 added protection for literal Unicode ``λ`` inside
        function calls. Version 11 adds the Coefficient and CoefficientList
        lowering, versions 12/13 normalize single-variable Solve results to
        Wolfram rule lists and serialize those rules as opaque Rule heads, and
        version 14 adds the bounded FoldList form, version 15 aligns protected
        string literals with the native comparison protocol, version 16 lowers
        the bounded diagonal SingularValueList and numeric extrema forms, and
        version 17 adds bounded polynomial heads, version 18 lets serialized
        Solve rules feed ReplaceAll, version 19 lowers bounded Thread, and
        version 20 lowers bounded positive Map levels, version 21 lowers
        numeric Boole conditions, version 22 lowers numeric Which branches,
        version 23 lowers bounded TrigReduce forms, and version 24 aligns
        multiple Integrate ranges with Wolfram's outer-to-inner order.
        Version 25 reserves the user symbol ``CC`` before SymPy's parser
        sees an expression.  Only sources containing that symbol need a
        fresh oracle result; retaining unaffected version-24 rows avoids a
        corpus-wide SymPy refresh.
        Version 26 adds bounded ``With`` and ``Do`` lowering.  Sources
        containing ``CC``, ``With``, or ``Do`` need a fresh result; unaffected
        version-24/25 rows remain reusable.
        Mathics version 5 adds a fallback for invalid ``Curl`` calls that
        otherwise crash through the removed top-level SymPy ``curl`` API.
        Existing successful rows and unrelated failures remain reusable; only
        that specific failure is rerun.
        Older rows remain exact for
        sources unaffected by the
        corresponding change, which prevents a translator fix from forcing a
        multi-gigabyte full oracle refresh.
        """
        version = entry.get("cache_version", 1)
        if version == backend.cache_version:
            return True
        if (
            backend.name == "sympy"
            and backend.cache_version == 26
            and version in (24, 25)
        ):
            source = entry.get("source")
            if not isinstance(source, str):
                return False
            try:
                text = Path(source).read_text()
                return not any(token in text for token in ("CC", "With", "Do"))
            except (OSError, UnicodeError):
                return False
        if (
            backend.name == "mathics"
            and backend.cache_version == 5
            and version == 4
        ):
            if entry.get("outcome") != "failure":
                return True
            detail = entry.get("failure", {}).get("detail", "").lower()
            return not ("sympy" in detail and "curl" in detail)
        if (
            backend.name == "sympy"
            and backend.cache_version == 25
            and version == 24
        ):
            source = entry.get("source")
            if not isinstance(source, str):
                return False
            try:
                return "CC" not in Path(source).read_text()
            except (OSError, UnicodeError):
                return False
        if (
            backend.name == "sympy"
            and backend.cache_version == 10
            and version == 9
        ):
            source = entry.get("source")
            if not isinstance(source, str):
                return False
            try:
                return "λ" not in Path(source).read_text()
            except (OSError, UnicodeError):
                return False
        if (
            backend.name == "sympy"
            and backend.cache_version == 11
            and version in (9, 10)
        ):
            source = entry.get("source")
            if not isinstance(source, str):
                return False
            try:
                text = Path(source).read_text()
                if "Coefficient" in text:
                    return False
                return version != 9 or "λ" not in text
            except (OSError, UnicodeError):
                return False
        if (
            backend.name == "sympy"
            and backend.cache_version == 12
            and version == 11
        ):
            source = entry.get("source")
            if not isinstance(source, str):
                return False
            try:
                return "Solve" not in Path(source).read_text()
            except (OSError, UnicodeError):
                return False
        if (
            backend.name == "sympy"
            and backend.cache_version == 13
            and version in (9, 10, 11, 12)
        ):
            source = entry.get("source")
            if not isinstance(source, str):
                return False
            try:
                text = Path(source).read_text()
                if version == 9 and "λ" in text:
                    return False
                if version <= 10 and "Coefficient" in text:
                    return False
                return "Solve" not in text
            except (OSError, UnicodeError):
                return False
        if (
            backend.name == "sympy"
            and backend.cache_version == 14
            and version in (9, 10, 11, 12, 13)
        ):
            source = entry.get("source")
            if not isinstance(source, str):
                return False
            try:
                text = Path(source).read_text()
                if version == 9 and "λ" in text:
                    return False
                if version <= 10 and "Coefficient" in text:
                    return False
                if version < 13 and "Solve" in text:
                    return False
                return "FoldList" not in text
            except (OSError, UnicodeError):
                return False
        if (
            backend.name == "sympy"
            and backend.cache_version == 16
            and version == 15
        ):
            source = entry.get("source")
            if not isinstance(source, str):
                return False
            try:
                text = Path(source).read_text()
                return "SingularValueList" not in text and "Max[" not in text and "Min[" not in text
            except (OSError, UnicodeError):
                return False
        if (
            backend.name == "sympy"
            and backend.cache_version == 16
            and version in (9, 10, 11, 12, 13, 14)
        ):
            source = entry.get("source")
            if not isinstance(source, str):
                return False
            try:
                text = Path(source).read_text()
                if version == 9 and "λ" in text:
                    return False
                if version <= 10 and "Coefficient" in text:
                    return False
                if version < 13 and "Solve" in text:
                    return False
                if version < 14 and "FoldList" in text:
                    return False
                assignments = text.split("_ASSIGNMENTS = [", 1)
                if len(assignments) == 2:
                    body = assignments[1].split("]\n\ndef results", 1)[0]
                    return '"' not in body
                return '"' not in text
            except (OSError, UnicodeError):
                return False
        if (
            backend.name == "sympy"
            and backend.cache_version == 24
            and version in range(9, 24)
        ):
            source = entry.get("source")
            if not isinstance(source, str):
                return False
            try:
                text = Path(source).read_text()
                return not ("Integrate[" in text and "}, {" in text)
            except (OSError, UnicodeError):
                return False
        if (
            backend.name == "sympy"
            and backend.cache_version in (21, 22, 23)
            and version in (9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22)
        ):
            source = entry.get("source")
            if not isinstance(source, str):
                return False
            try:
                text = Path(source).read_text()
                if backend.cache_version == 23 and "TrigReduce[" in text:
                    return False
                if backend.cache_version == 22 and "Which[" in text:
                    return False
                if "Boole[" in text:
                    return False
                if version >= 18:
                    if version <= 19 and "Map[" in text and any(
                        f"{{{level}}}" in text for level in (2, 3, 4)
                    ):
                        return False
                    return version > 18 or "Thread[" not in text
                if "Thread[" in text:
                    return False
                if "Map[" in text and any(
                    f"{{{level}}}" in text for level in (2, 3, 4)
                ):
                    return False
                if "First[Solve[" in text and "/." in text:
                    return False
                if any(
                    head in text
                    for head in (
                        "Exponent[",
                        "PolynomialGCD[",
                        "PolynomialQuotient[",
                        "PolynomialRemainder[",
                        "Numerator[",
                        "Denominator[",
                    )
                ):
                    return False
                if version < 16 and any(
                    head in text for head in ("SingularValueList[", "Max[", "Min[")
                ):
                    return False
                if version <= 14:
                    if version == 9 and "λ" in text:
                        return False
                    if version <= 10 and "Coefficient" in text:
                        return False
                    if version < 13 and "Solve" in text:
                        return False
                    if version < 14 and "FoldList" in text:
                        return False
                    assignments = text.split("_ASSIGNMENTS = [", 1)
                    if len(assignments) == 2:
                        body = assignments[1].split("]\n\ndef results", 1)[0]
                        return '"' not in body
                    return '"' not in text
                return True
            except (OSError, UnicodeError):
                return False
        if (
            backend.name == "sympy"
            and backend.cache_version == 17
            and version in (9, 10, 11, 12, 13, 14, 15, 16)
        ):
            source = entry.get("source")
            if not isinstance(source, str):
                return False
            try:
                text = Path(source).read_text()
                polynomial_heads = (
                    "Exponent[",
                    "PolynomialGCD[",
                    "PolynomialQuotient[",
                    "PolynomialRemainder[",
                    "Numerator[",
                    "Denominator[",
                )
                if any(head in text for head in polynomial_heads):
                    return False
                if version < 16 and any(
                    head in text for head in ("SingularValueList[", "Max[", "Min[")
                ):
                    return False
                if version <= 14:
                    if version == 9 and "λ" in text:
                        return False
                    if version <= 10 and "Coefficient" in text:
                        return False
                    if version < 13 and "Solve" in text:
                        return False
                    if version < 14 and "FoldList" in text:
                        return False
                    assignments = text.split("_ASSIGNMENTS = [", 1)
                    if len(assignments) == 2:
                        body = assignments[1].split("]\n\ndef results", 1)[0]
                        return '"' not in body
                    return '"' not in text
                return True
            except (OSError, UnicodeError):
                return False
        if (
            backend.name == "sympy"
            and backend.cache_version == 20
            and version in (9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19)
        ):
            source = entry.get("source")
            if not isinstance(source, str):
                return False
            try:
                text = Path(source).read_text()
                return not (
                    "Map[" in text
                    and any(f"{{{level}}}" in text for level in (2, 3, 4))
                )
            except (OSError, UnicodeError):
                return False
        if (
            backend.name == "sympy"
            and backend.cache_version in (19, 20)
            and version in (9, 10, 11, 12, 13, 14, 15, 16, 17, 18)
        ):
            source = entry.get("source")
            if not isinstance(source, str):
                return False
            try:
                return "Thread[" not in Path(source).read_text()
            except (OSError, UnicodeError):
                return False
        if (
            backend.name == "sympy"
            and backend.cache_version in (18, 19, 20)
            and version in (9, 10, 11, 12, 13, 14, 15, 16, 17)
        ):
            source = entry.get("source")
            if not isinstance(source, str):
                return False
            try:
                text = Path(source).read_text()
                if "First[Solve[" in text and "/." in text:
                    return False
                if version < 18 and any(
                    head in text
                    for head in (
                        "Exponent[",
                        "PolynomialGCD[",
                        "PolynomialQuotient[",
                        "PolynomialRemainder[",
                        "Numerator[",
                        "Denominator[",
                    )
                ):
                    return False
                if version < 16 and any(
                    head in text for head in ("SingularValueList[", "Max[", "Min[")
                ):
                    return False
                if version <= 14:
                    if version == 9 and "λ" in text:
                        return False
                    if version <= 10 and "Coefficient" in text:
                        return False
                    if version < 13 and "Solve" in text:
                        return False
                    if version < 14 and "FoldList" in text:
                        return False
                    assignments = text.split("_ASSIGNMENTS = [", 1)
                    if len(assignments) == 2:
                        body = assignments[1].split("]\n\ndef results", 1)[0]
                        return '"' not in body
                    return '"' not in text
                return True
            except (OSError, UnicodeError):
                return False
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
        if stored is None:
            return True
        current = self._execution_fingerprint(backend)
        if stored == current:
            return True
        # An optional oracle disappearing from PATH is an environment change,
        # not a semantic change. Keep its last successful/failure result rather
        # than replacing a valid cached row with "not on PATH" on every audit.
        # An explicit refresh can still force a new attempt when the backend is
        # available again.
        if backend.command and current == f"missing:{backend.command[0]}":
            return True
        return False

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
        self._dirty = False
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
            self._dirty = True
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
        if not self._dirty:
            return
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
            self._dirty = False
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
