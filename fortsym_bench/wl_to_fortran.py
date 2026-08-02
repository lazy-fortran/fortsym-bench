"""Small adapter for the bounded native Wolfram-to-Fortran translator.

Wolfram notebooks commonly use ``Null`` as a top-level compound-expression
separator.  The native scalar translator accepts the surrounding assignments,
but deliberately does not treat that side-effect value as an assignment.  We
remove only standalone top-level ``Null`` fragments before invoking it.
"""

from __future__ import annotations

from pathlib import Path
import subprocess
import tempfile
from typing import Sequence


class WolframFortranTranslationError(RuntimeError):
    """Raised when the native bounded translator cannot emit Fortran."""


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
