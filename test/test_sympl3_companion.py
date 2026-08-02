"""Independent semantic checks for the sympl3 notebook companion."""

import importlib.util
from pathlib import Path
import sys

import sympy as sp


def _load_companion():
    sys.path.insert(0, str(Path(__file__).parents[1]))
    path = (
        Path(__file__).parents[1]
        / "corpus/gh-itpplasma-paper_sympl/sympl3_.py"
    )
    spec = importlib.util.spec_from_file_location("sympl3_companion", path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def test_sympl3_unit_constants_are_applied_to_derived_bindings():
    values = _load_companion().results()
    th = sp.Symbol("th")

    # The notebook assigns B0=R0=m=eoc=1 before these derived quantities are
    # used.  These are independent formulas, not serialized expected output.
    assert sp.simplify(values["dHdr"] + sp.Rational(1, 10) * sp.cos(th)) == 0
    assert sp.simplify(
        values["w"] - sp.Rational(1, 10) * (1 - sp.Rational(3, 10) * sp.cos(sp.Float(1.5)))
    ) == 0
    assert not values["Lgc"].has(sp.Symbol("B0"), sp.Symbol("R0"), sp.Symbol("m"))
