#!/usr/bin/env python3
"""Inventory the bounded Wolfram-to-Fortran translator over a corpus.

This is a source-to-source acceptance inventory, not a Fortran parity claim:
``translated`` means that the translator accepted the source, emitted a
non-empty ``.f90`` file, and ``gfortran`` compiled it successfully.
``compile-error`` separates emitted Fortran that the compiler rejected.  The
temporary source, object, and module files are discarded after each file; the
corpus and any checked-in caches are never written.  This remains a source
acceptance inventory, not a semantic-parity check.
"""

from __future__ import annotations

import argparse
from dataclasses import asdict, dataclass
import json
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import time


STATUSES = (
    "translated",
    "compile-error",
    "refused",
    "timeout",
    "unavailable",
    "error",
)
TRANSLATION_MODES = ("native", "assignment-adapter")
# Keep the standalone tools/inventory_wl_to_f90.py entry point usable without
# relying on the repository root being on Python's import path.  The adapter
# CLI has the same default.
MAX_ADAPTER_SOURCE_BYTES = 1_048_576


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


def _command_available(command: tuple[str, ...]) -> bool:
    return shutil.which(command[0]) is not None or Path(command[0]).exists()


def translate_one(
    source: Path,
    command: tuple[str, ...],
    timeout: float,
    corpus: Path,
    cwd: Path,
    compiler: tuple[str, ...] = ("gfortran",),
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
                if not _command_available(compiler):
                    return TranslationResult(
                        source=source.relative_to(corpus).as_posix(),
                        status="unavailable",
                        seconds=seconds,
                        detail=f"{compiler[0]} not found",
                        output_bytes=size,
                    )

                object_file = Path(work) / "translated.o"
                try:
                    compiled = subprocess.run(
                        [
                            *compiler,
                            "-c",
                            str(output),
                            "-o",
                            str(object_file),
                        ],
                        capture_output=True,
                        text=True,
                        timeout=timeout,
                        cwd=work,
                        check=False,
                    )
                except subprocess.TimeoutExpired:
                    return TranslationResult(
                        source=source.relative_to(corpus).as_posix(),
                        status="timeout",
                        seconds=time.monotonic() - started,
                        detail=f"{compiler[0]} exceeded {timeout:g}s",
                        output_bytes=size,
                    )
                except FileNotFoundError:
                    return TranslationResult(
                        source=source.relative_to(corpus).as_posix(),
                        status="unavailable",
                        seconds=time.monotonic() - started,
                        detail=f"{compiler[0]} not found",
                        output_bytes=size,
                    )

                if compiled.returncode != 0:
                    return TranslationResult(
                        source=source.relative_to(corpus).as_posix(),
                        status="compile-error",
                        seconds=time.monotonic() - started,
                        detail=_detail(compiled.stderr, compiled.stdout),
                        output_bytes=size,
                    )
                return TranslationResult(
                    source=source.relative_to(corpus).as_posix(),
                    status="translated",
                    seconds=time.monotonic() - started,
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
    compiler: tuple[str, ...] = ("gfortran",),
    *,
    mode: str = "native",
    adapter_max_source_bytes: int = MAX_ADAPTER_SOURCE_BYTES,
) -> dict:
    """Translate every source serially and return a JSON-serializable report."""

    if mode not in TRANSLATION_MODES:
        raise ValueError(f"unsupported translation mode: {mode}")
    if adapter_max_source_bytes <= 0:
        raise ValueError("adapter_max_source_bytes must be positive")
    corpus = corpus.resolve()
    sources = discover_sources(corpus)
    effective_command = command
    command_cwd = corpus.parent
    if mode == "assignment-adapter":
        effective_command = (
            sys.executable,
            "-m",
            "fortsym_bench.wl_to_fortran",
            "--mode",
            "assignment-adapter",
            "--max-source-bytes",
            str(adapter_max_source_bytes),
        )
        command_cwd = Path(__file__).resolve().parents[1]
    results: list[TranslationResult]
    executable = shutil.which(effective_command[0])
    if executable is None and not Path(effective_command[0]).exists():
        results = [
            TranslationResult(
                source=source.relative_to(corpus).as_posix(),
                status="unavailable",
                seconds=0.0,
                detail=f"{effective_command[0]} not found",
            )
            for source in sources
        ]
    else:
        results = [
            translate_one(
                source,
                effective_command,
                timeout,
                corpus,
                command_cwd,
                compiler,
            )
            for source in sources
        ]

    counts = {status: 0 for status in STATUSES}
    for result in results:
        counts[result.status] += 1
    return {
        "schema": "fortsym-bench/wl-to-f90-inventory-v2",
        "corpus": str(corpus),
        "source_count": len(sources),
        "translation_mode": mode,
        "translator": list(effective_command),
        "fortran_compiler": list(compiler),
        "timeout_seconds": timeout,
        "acceptance_boundary": (
            "translated means the translator exited zero, emitted non-empty "
            "Fortran source, and gfortran compiled it successfully; "
            "compile-error means emitted source was rejected by gfortran; "
            "execution and semantic parity are not assessed"
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
    parser.add_argument(
        "--mode",
        choices=TRANSLATION_MODES,
        default="native",
        help=(
            "native invokes the command directly; assignment-adapter invokes "
            "the safe file adapter on each real .wl source"
        ),
    )
    parser.add_argument(
        "--adapter-max-source-bytes",
        type=int,
        default=MAX_ADAPTER_SOURCE_BYTES,
        help="maximum source size read by assignment-adapter mode",
    )
    parser.add_argument("--timeout", type=float, default=30.0)
    parser.add_argument(
        "--fortran-compiler",
        nargs="+",
        default=["gfortran"],
        help="Fortran compiler command followed by fixed arguments",
    )
    parser.add_argument(
        "--require-all-translated",
        action="store_true",
        help="return 1 if any source is refused, unavailable, timed out, or errors",
    )
    args = parser.parse_args(argv)
    if args.timeout <= 0:
        parser.error("--timeout must be positive")
    if args.adapter_max_source_bytes <= 0:
        parser.error("--adapter-max-source-bytes must be positive")

    report = inventory(
        args.corpus,
        tuple(args.translator),
        args.timeout,
        tuple(args.fortran_compiler),
        mode=args.mode,
        adapter_max_source_bytes=args.adapter_max_source_bytes,
    )
    args.report.parent.mkdir(parents=True, exist_ok=True)
    args.report.write_text(json.dumps(report, indent=2, sort_keys=True) + "\n")
    print(json.dumps(report["counts"], sort_keys=True))
    if args.require_all_translated:
        return int(report["counts"]["translated"] != report["source_count"])
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
