#!/usr/bin/env python3
"""Inventory the bounded Wolfram-to-Fortran translator over a corpus.

This is a source-to-source acceptance inventory, not a Fortran parity claim:
``translated`` means that the translator accepted the source and emitted a
non-empty ``.f90`` file.  The temporary output is discarded after each file;
the corpus and any checked-in caches are never written.
"""

from __future__ import annotations

import argparse
from dataclasses import asdict, dataclass
import json
from pathlib import Path
import shutil
import subprocess
import tempfile
import time


STATUSES = ("translated", "refused", "timeout", "unavailable", "error")


@dataclass(frozen=True)
class TranslationResult:
    source: str
    status: str
    seconds: float
    detail: str = ""
    output_bytes: int = 0


def discover_sources(corpus: Path) -> list[Path]:
    """Return every regular ``.wl`` source below *corpus*, deterministically."""

    return sorted(
        (path for path in corpus.rglob("*.wl") if path.is_file()),
        key=lambda path: path.as_posix(),
    )


def _detail(stderr: str, stdout: str) -> str:
    lines = [line.strip() for line in (stderr + "\n" + stdout).splitlines()]
    lines = [line for line in lines if line]
    refused = next(
        (line for line in lines if "translation refused:" in line), None
    )
    if refused is not None:
        return refused.split("translation refused:", 1)[1].strip()
    return next(
        (
            line
            for line in lines
            if line not in {"ERROR STOP 1", "Error termination:"}
            and not line.startswith("#")
        ),
        "translator exited without a diagnostic",
    )[:500]


def translate_one(
    source: Path,
    command: tuple[str, ...],
    timeout: float,
    corpus: Path,
    cwd: Path,
) -> TranslationResult:
    """Run one translation with output isolated outside the corpus."""

    started = time.monotonic()
    with tempfile.TemporaryDirectory(prefix="fortsym-f90-inventory-") as work:
        output = Path(work) / "translated.f90"
        try:
            completed = subprocess.run(
                [*command, str(source), str(output)],
                capture_output=True,
                text=True,
                timeout=timeout,
                cwd=cwd,
                check=False,
            )
        except subprocess.TimeoutExpired:
            return TranslationResult(
                source=source.relative_to(corpus).as_posix(),
                status="timeout",
                seconds=timeout,
                detail=f"exceeded {timeout:g}s",
            )
        except FileNotFoundError:
            return TranslationResult(
                source=source.relative_to(corpus).as_posix(),
                status="unavailable",
                seconds=time.monotonic() - started,
                detail=f"{command[0]} not found",
            )

        seconds = time.monotonic() - started
        if completed.returncode == 0:
            size = output.stat().st_size if output.exists() else 0
            if size > 0:
                return TranslationResult(
                    source=source.relative_to(corpus).as_posix(),
                    status="translated",
                    seconds=seconds,
                    output_bytes=size,
                )
            return TranslationResult(
                source=source.relative_to(corpus).as_posix(),
                status="error",
                seconds=seconds,
                detail="translator succeeded but emitted no Fortran source",
            )

        status = "refused" if "translation refused:" in completed.stderr else "error"
        return TranslationResult(
            source=source.relative_to(corpus).as_posix(),
            status=status,
            seconds=seconds,
            detail=_detail(completed.stderr, completed.stdout),
        )


def inventory(
    corpus: Path,
    command: tuple[str, ...] = ("fortsym_wl_to_f90",),
    timeout: float = 30.0,
) -> dict:
    """Translate every source serially and return a JSON-serializable report."""

    corpus = corpus.resolve()
    sources = discover_sources(corpus)
    results: list[TranslationResult]
    executable = shutil.which(command[0])
    if executable is None and not Path(command[0]).exists():
        results = [
            TranslationResult(
                source=source.relative_to(corpus).as_posix(),
                status="unavailable",
                seconds=0.0,
                detail=f"{command[0]} not found",
            )
            for source in sources
        ]
    else:
        results = [
            translate_one(source, command, timeout, corpus, corpus.parent)
            for source in sources
        ]

    counts = {status: 0 for status in STATUSES}
    for result in results:
        counts[result.status] += 1
    return {
        "schema": "fortsym-bench/wl-to-f90-inventory-v1",
        "corpus": str(corpus),
        "source_count": len(sources),
        "translator": list(command),
        "timeout_seconds": timeout,
        "acceptance_boundary": (
            "translated means the command exited zero and emitted non-empty "
            "Fortran source; compilation, execution, and semantic parity are "
            "not assessed"
        ),
        "counts": counts,
        "sources": [asdict(result) for result in results],
    }


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(
        description="Inventory bounded .wl-to-.f90 acceptance without writing corpus files"
    )
    parser.add_argument("--corpus", type=Path, default=Path("corpus"))
    parser.add_argument("--report", type=Path, required=True)
    parser.add_argument(
        "--translator",
        nargs="+",
        default=["fortsym_wl_to_f90"],
        help="translator command followed by fixed arguments",
    )
    parser.add_argument("--timeout", type=float, default=30.0)
    parser.add_argument(
        "--require-all-translated",
        action="store_true",
        help="return 1 if any source is refused, unavailable, timed out, or errors",
    )
    args = parser.parse_args(argv)
    if args.timeout <= 0:
        parser.error("--timeout must be positive")

    report = inventory(args.corpus, tuple(args.translator), args.timeout)
    args.report.parent.mkdir(parents=True, exist_ok=True)
    args.report.write_text(json.dumps(report, indent=2, sort_keys=True) + "\n")
    print(json.dumps(report["counts"], sort_keys=True))
    if args.require_all_translated:
        return int(report["counts"]["translated"] != report["source_count"])
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
