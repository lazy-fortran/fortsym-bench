"""Independent checks for source-order normalization in sympl3_."""

import importlib.util
from pathlib import Path
import sys

import sympy as sp


def _load_companion():
    root = Path(__file__).parents[1]
    sys.path.insert(0, str(root))
    path = root / "corpus/gh-itpplasma-paper_sympl/sympl3_.py"
    spec = importlib.util.spec_from_file_location("sympl3_v108_residual", path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_derived_orbit_bindings_use_constants_already_assigned_in_source():
    values = _load_companion().results()
    constants = (sp.Symbol("B0"), sp.Symbol("R0"), sp.Symbol("m"), sp.Symbol("eoc"))

    for name in ("thdot", "phdot", "eq1a", "eq2a", "eq3a", "eq4a"):
        assert not values[name].has(*constants), name


def test_vpdot_keeps_the_source_guiding_center_formula_after_normalization():
    values = _load_companion().results()
    r, th, h0ph, h0th, vp = sp.symbols("r th h0ph h0th vp")
    expected = -sp.Rational(1, 10) * h0th * r * sp.sin(th) / (
        -h0ph**2 * r**3 * sp.cos(th) ** 2
        + h0ph**2 * r
        + h0ph * h0th * vp
        + h0th**2 * r
    )
    actual = values["vpdot"].xreplace({
        sp.Function("r")(sp.Symbol("t")): r,
        sp.Function("th")(sp.Symbol("t")): th,
        sp.Function("vp")(sp.Symbol("t")): vp,
    })
    assert sp.simplify(actual - expected) == 0
