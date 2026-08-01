"""Run one corpus .py file under SymPy or under fortsym's SymPy subset.

Executed as a subprocess by ``backends.run``. Prints one JSON object on stdout.

The corpus file is never edited and never inspected for backend awareness. The
whole substitution is the ``sys.modules`` assignment below, before the script is
imported — which is exactly the claim fortsym is making: a SymPy file runs 1:1.
"""

from __future__ import annotations

import importlib.util
import json
import sys
import time
from pathlib import Path


def install_backend(name: str) -> None:
    if name == "sympy":
        return
    if name == "fortsym-sympy":
        try:
            import fortsym.sympy
        except ImportError as exc:
            # Not built yet is not a wrong answer. Keep it out of the scored
            # classes entirely.
            print(f"UNAVAILABLE: {exc}", file=sys.stderr)
            raise SystemExit(1) from None

        # Everything the corpus file imports as "sympy" resolves here. This
        # must happen before the file is loaded, and it must be the only
        # difference between the two runs.
        sys.modules["sympy"] = fortsym.sympy
        return
    raise SystemExit(f"unknown python backend: {name}")


def load(script: Path):
    spec = importlib.util.spec_from_file_location("corpus_script", script)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def main() -> int:
    script, backend = Path(sys.argv[1]), sys.argv[2]
    install_backend(backend)

    try:
        module = load(script)
    except NotImplementedError as exc:
        # fortsym's declared way of refusing. Refusal is a correct outcome;
        # it must not reach the comparator looking like a wrong answer.
        print(f"UNSUPPORTED: {exc}", file=sys.stderr)
        return 1

    start = time.perf_counter()
    try:
        values = module.results()
    except NotImplementedError as exc:
        print(f"UNSUPPORTED: {exc}", file=sys.stderr)
        return 1
    seconds = time.perf_counter() - start

    compare = getattr(module, "COMPARE", {})
    srepr = _srepr_for(backend)
    payload = {
        "results": {name: srepr(value) for name, value in values.items()},
        "compare": compare,
        "seconds": seconds,
    }
    json.dump(payload, sys.stdout)
    return 0


def _srepr_for(backend: str):
    """The dumper for this backend's expression objects.

    Both must emit SymPy's ``srepr`` grammar, because the comparator parses one
    syntax per side and not one per backend. Emitting it is part of what the
    drop-in claim means.
    """
    import sympy

    return sympy.srepr


if __name__ == "__main__":
    raise SystemExit(main())
