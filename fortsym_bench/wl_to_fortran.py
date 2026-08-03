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
