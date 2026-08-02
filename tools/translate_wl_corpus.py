#!/usr/bin/env python3
"""Generate a SymPy companion for every Wolfram corpus script.

The generated module keeps the sequential assignment RHSs as Python string
data and evaluates them through ``fortsym_bench.wl_to_sympy``. Existing hand
translations are preserved; all other corpus entries receive a companion and
an explicit count of statements that still need a hand translation.
"""

from __future__ import annotations

import argparse
import json
from pathlib import Path
import re

from fortsym_bench.wl_to_sympy import extract_assignments


MANUAL_TRANSLATIONS = {
    # The Wolfram fixture stores several named answers inside an Association;
    # keep the small, readable hand translation used by the original corpus
    # example instead of making the shared expression runtime parse a result
    # container it intentionally does not claim to support.
    "corpus/code-fortsym-bench/00_example.wl",
}


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--corpus", type=Path, default=Path("corpus"))
    parser.add_argument(
        "--manifest", type=Path, default=Path("translation-manifest.json")
    )
    parser.add_argument(
        "--force",
        action="store_true",
        help="replace existing Python companions, including hand translations",
    )
    parser.add_argument(
        "--refresh-generated",
        action="store_true",
        help="rewrite generated companions while preserving hand translations",
    )
    args = parser.parse_args()

    manifest = {}
    for source in sorted(args.corpus.rglob("*.wl")):
        target = source.with_suffix(".py")
        relative = source.as_posix()
        refresh_generated = (
            args.refresh_generated
            and target.exists()
            and "Generated SymPy translation" in target.read_text(errors="replace")
        )
        if target.exists() and not args.force and not refresh_generated:
            if relative in MANUAL_TRANSLATIONS:
                manifest[relative] = {"status": "manual", "assignments": None}
            elif "Generated SymPy translation" in target.read_text(errors="replace"):
                assignments, skipped = extract_assignments(
                    source.read_text(errors="replace")
                )
                manifest[relative] = {
                    "status": "generated",
                    "assignments": len(assignments),
                    "skipped_statements": len(skipped),
                }
            else:
                manifest[relative] = {"status": "existing", "assignments": None}
            continue

        assignments, skipped = extract_assignments(source.read_text(errors="replace"))
        target.write_text(render_module(relative, assignments, len(skipped)))
        manifest[relative] = {
            "status": "generated",
            "assignments": len(assignments),
            "skipped_statements": len(skipped),
        }

    args.manifest.write_text(json.dumps(manifest, indent=1, sort_keys=True) + "\n")
    generated = sum(item["status"] == "generated" for item in manifest.values())
    existing = sum(item["status"] == "existing" for item in manifest.values())
    manual = sum(item["status"] == "manual" for item in manifest.values())
    print(
        f"translated {generated} scripts; preserved {existing} existing and "
        f"{manual} manual companions"
    )
    return 0


def render_module(source: str, assignments, skipped: int) -> str:
    policies = {
        assignment.name: "numeric"
        for assignment in assignments
        if re.search(
            r"(?<![A-Za-z0-9$])(?:N|SetPrecision)\s*\[",
            assignment.rhs,
        )
    }
    lines = [
        '"""Generated SymPy translation of ``' + source + '``.',
        "",
        "The assignment text is lowered by the shared deterministic translator.",
        "Unsupported control-flow or side-effect statements are not guessed;",
        "their count is recorded in translation-manifest.json.",
        '"""',
        "",
        "from fortsym_bench.wl_to_sympy import evaluate_assignments",
        "",
        f"# NOT TRANSLATED: {skipped} non-assignment statement(s) remain.",
    ]
    if policies:
        lines.extend([
            "COMPARE = {",
            *[
                f"    {name!r}: {policy!r},"
                for name, policy in sorted(policies.items())
            ],
            "}",
        ])
    lines.extend([
        "_ASSIGNMENTS = [",
    ])
    for assignment in assignments:
        delayed = (
            f", {assignment.delayed!r}"
            if assignment.parameters and not assignment.delayed
            else ""
        )
        lines.append(
            f"    ({assignment.name!r}, {assignment.rhs!r}, "
            f"{assignment.parameters!r}{delayed}),"
        )
    lines.extend(
        [
            "]",
            "",
            "def results():",
            f"    return evaluate_assignments(_ASSIGNMENTS, {source!r})",
            "",
        ]
    )
    return "\n".join(lines)


if __name__ == "__main__":
    raise SystemExit(main())
