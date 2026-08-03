"""Small adapter for the bounded native Wolfram-to-Fortran translator.

Wolfram notebooks commonly use ``Null`` as a top-level compound-expression
separator.  The native scalar translator accepts the surrounding assignments,
but deliberately does not treat that side-effect value as an assignment.  We
remove only standalone top-level ``Null`` fragments before invoking it.
"""

from __future__ import annotations

from pathlib import Path
import re
import subprocess
import sys
import tempfile
from typing import Sequence


class WolframFortranTranslationError(RuntimeError):
    """Raised when the native bounded translator cannot emit Fortran."""


_BOUNDED_FOR = re.compile(
    r"""^For\[\s*
        (?P<iterator>[A-Za-z][A-Za-z0-9_]*)\s*=\s*(?P<start>[+-]?\d+)\s*,\s*
        (?P=iterator)\s*<=\s*(?P<stop>[+-]?\d+)\s*,\s*
        (?P=iterator)\+\+\s*,\s*
        (?P<target>[A-Za-z][A-Za-z0-9_]*)\s*=\s*(?P<expression>.+?)\s*
    \]$""",
    re.DOTALL | re.VERBOSE,
)
MAX_BOUNDED_FOR_ITERATIONS = 128
_BOUNDED_DO = re.compile(
    r"""^Do\[\s*
        (?P<target>[A-Za-z][A-Za-z0-9_]*)\s*=\s*(?P<expression>.+?)\s*,\s*
        \{\s*(?P<iterator>[A-Za-z][A-Za-z0-9_]*)\s*,\s*
        (?P<start>[+-]?\d+)\s*,\s*(?P<stop>[+-]?\d+)\s*\}\s*
    \]$""",
    re.DOTALL | re.VERBOSE,
)
MAX_BOUNDED_DO_ITERATIONS = 128
MAX_ADAPTER_SOURCE_BYTES = 1_048_576


def normalize_assignment_stream(source: str) -> str:
    """Remove standalone top-level ``Null`` expressions from *source*.

    Separators inside strings, comments, or bracketed Wolfram expressions are
    left alone.  All other top-level commas and semicolons become newlines,
    which is an equivalent statement separator for the bounded translator.
    """

    fragments: list[str] = []
    start = 0
    depth = 0
    comment_depth = 0
    in_string = False
    escaped = False
    index = 0

    while index < len(source):
        char = source[index]
        if comment_depth:
            if source.startswith("(*", index):
                comment_depth += 1
                index += 2
                continue
            if source.startswith("*)", index):
                comment_depth -= 1
                index += 2
                continue
            index += 1
            continue
        if in_string:
            if escaped:
                escaped = False
            elif char == "\\":
                escaped = True
            elif char == '"':
                in_string = False
            index += 1
            continue
        if source.startswith("(*", index):
            comment_depth = 1
            index += 2
            continue
        if char == '"':
            in_string = True
            index += 1
            continue
        if char in "[{(":
            depth += 1
        elif char in "]})":
            depth = max(0, depth - 1)
        elif depth == 0 and char in ",;\n":
            fragment = source[start:index].strip()
            if fragment and fragment != "Null":
                fragments.append(fragment)
            start = index + 1
        index += 1

    fragment = source[start:].strip()
    if fragment and fragment != "Null":
        fragments.append(fragment)
    return "\n".join(fragments) + ("\n" if fragments else "")


def translate_wolfram_to_fortran(
    source: str,
    translator: Sequence[str] = ("fortsym_wl_to_f90",),
) -> str:
    """Translate a bounded scalar Wolfram assignment stream to Fortran."""

    with tempfile.TemporaryDirectory(prefix="fortsym-wl-to-f90-") as work:
        directory = Path(work)
        input_path = directory / "input.wl"
        output_path = directory / "output.f90"
        input_path.write_text(normalize_assignment_stream(source))
        try:
            result = subprocess.run(
                [*translator, str(input_path), str(output_path)],
                capture_output=True,
                text=True,
                check=False,
            )
        except FileNotFoundError as error:
            raise WolframFortranTranslationError(
                f"translator executable not found: {translator[0]}"
            ) from error
        if result.returncode != 0:
            diagnostic = (result.stderr or result.stdout).strip()
            raise WolframFortranTranslationError(diagnostic)
        if not output_path.exists() or not output_path.stat().st_size:
            raise WolframFortranTranslationError(
                "translator succeeded without emitting Fortran"
            )
        return output_path.read_text()


def translate_wolfram_file_to_fortran(
    input_path: Path,
    output_path: Path,
    translator: Sequence[str] = ("fortsym_wl_to_f90",),
    max_source_bytes: int = MAX_ADAPTER_SOURCE_BYTES,
) -> None:
    """Translate one real source file through the bounded assignment adapter.

    The inventory calls this explicit file-level adapter instead of passing a
    corpus path directly to the native executable.  The size check happens
    before reading the source, so an accidentally huge notebook cannot cause
    an unbounded allocation in the inventory worker.
    """

    if max_source_bytes <= 0:
        raise ValueError("max_source_bytes must be positive")
    try:
        source_bytes = input_path.stat().st_size
    except OSError as error:
        raise WolframFortranTranslationError(
            f"cannot inspect input source: {error}"
        ) from error
    if source_bytes > max_source_bytes:
        raise WolframFortranTranslationError(
            f"source exceeds the {max_source_bytes}-byte adapter limit"
        )
    try:
        source = input_path.read_text()
    except (OSError, UnicodeError) as error:
        raise WolframFortranTranslationError(
            f"cannot read input source: {error}"
        ) from error
    generated = translate_wolfram_to_fortran(source, translator)
    try:
        output_path.write_text(generated)
    except OSError as error:
        raise WolframFortranTranslationError(
            f"cannot write output source: {error}"
        ) from error


def translate_bounded_for(
    source: str,
    translator: Sequence[str] = ("fortsym_wl_to_f90",),
    max_iterations: int = MAX_BOUNDED_FOR_ITERATIONS,
) -> str:
    """Translate one safe scalar ``For`` assignment using native semantics.

    This intentionally accepts only an integer, ascending inclusive range and
    a scalar assignment body.  The native translator performs the actual
    lowering; this wrapper only prevents an accidentally unbounded source from
    entering the benchmark path.
    """

    if max_iterations <= 0:
        raise ValueError("max_iterations must be positive")
    normalized = normalize_assignment_stream(source).strip()
    match = _BOUNDED_FOR.fullmatch(normalized)
    if match is None:
        raise WolframFortranTranslationError(
            "expected one bounded For with an integer inclusive range and "
            "scalar assignment body"
        )
    start = int(match.group("start"))
    stop = int(match.group("stop"))
    iterations = stop - start + 1
    if iterations <= 0:
        raise WolframFortranTranslationError("bounded For range is empty")
    if iterations > max_iterations:
        raise WolframFortranTranslationError(
            f"bounded For exceeds the {max_iterations}-iteration limit"
        )
    return translate_wolfram_to_fortran(normalized, translator)


def translate_bounded_do(
    source: str,
    translator: Sequence[str] = ("fortsym_wl_to_f90",),
    max_iterations: int = MAX_BOUNDED_DO_ITERATIONS,
) -> str:
    """Translate one safe scalar ``Do`` assignment using native semantics.

    The accepted form is the explicit integer range
    ``Do[target = expression, {iterator, start, stop}]``.  The native
    translator lowers this stateless loop to the final assignment, so the
    wrapper only admits a nonempty range within a fixed resource bound before
    handing the source to it.  Recursive assignments, symbolic bounds, and
    stepped or shorthand ranges remain outside this deliberately small slice.
    """

    if max_iterations <= 0:
        raise ValueError("max_iterations must be positive")
    normalized = normalize_assignment_stream(source).strip()
    match = _BOUNDED_DO.fullmatch(normalized)
    if match is None:
        raise WolframFortranTranslationError(
            "expected one bounded Do with an integer three-item range and "
            "scalar assignment body"
        )
    start = int(match.group("start"))
    stop = int(match.group("stop"))
    iterations = stop - start + 1
    if iterations <= 0:
        raise WolframFortranTranslationError("bounded Do range is empty")
    if iterations > max_iterations:
        raise WolframFortranTranslationError(
            f"bounded Do exceeds the {max_iterations}-iteration limit"
        )
    return translate_wolfram_to_fortran(normalized, translator)


def main(argv: list[str] | None = None) -> int:
    """CLI for the explicit assignment-stream adapter used by inventory."""

    import argparse

    parser = argparse.ArgumentParser(
        description="Normalize a bounded Wolfram assignment stream and emit Fortran"
    )
    parser.add_argument(
        "--mode",
        choices=("assignment-adapter",),
        default="assignment-adapter",
        help="explicit safe adapter mode (native command mode is separate)",
    )
    parser.add_argument(
        "--max-source-bytes",
        type=int,
        default=MAX_ADAPTER_SOURCE_BYTES,
    )
    parser.add_argument("input", type=Path)
    parser.add_argument("output", type=Path)
    args = parser.parse_args(argv)
    if args.max_source_bytes <= 0:
        parser.error("--max-source-bytes must be positive")

    try:
        translate_wolfram_file_to_fortran(
            args.input,
            args.output,
            max_source_bytes=args.max_source_bytes,
        )
    except (ValueError, WolframFortranTranslationError) as error:
        print(f"translation refused: {error}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
