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


def test_orbit_equations_match_source_guiding_center_rhs_at_an_independent_point():
    values = _load_companion().results()
    r, th, vp = sp.symbols("r th vp")
    c = sp.cos(th)
    h0ph = sp.sqrt(1 - sp.Float("0.99") ** 2)
    hth = sp.Float("0.99") * r
    hph = (r * c + 1) * h0ph
    ath = h0ph * (r**2 / 2 - r**3 * c / 3)
    aph = -sp.Float("0.99") * r
    u = sp.Float("0.1") * (r * c - sp.Float("0.3") * sp.cos(sp.Float("1.5")))
    sqrtg = r * (r * c + 1)
    bstarpar = hth * (-sp.diff(aph, r) - vp * sp.diff(hph, r)) / sqrtg
    bstarpar += hph * (sp.diff(ath, r) + vp * sp.diff(hth, r)) / sqrtg
    expected = {
        "eq1a": (2 * u * sp.diff(hph, th) + hph * sp.diff(u, th)) / (bstarpar * sqrtg),
        "eq2a": (vp * (-sp.diff(aph, r)) - 2 * u * sp.diff(hph, r) - hph * sp.diff(u, r)) / (bstarpar * sqrtg),
        "eq3a": (vp * sp.diff(ath, r) + 2 * u * sp.diff(hth, r) + hth * sp.diff(u, r)) / (bstarpar * sqrtg),
        "eq4a": (sp.diff(u, r) * vp * sp.diff(hph, th) - sp.diff(u, th) * (sp.diff(aph, r) + vp * sp.diff(hph, r))) / (bstarpar * sqrtg),
    }
    sample = {r: sp.Rational(2, 5), th: sp.Rational(4, 5), vp: sp.Rational(17, 100)}
    t = sp.Symbol("t")
    functions = {sp.Function(name)(t): symbol for name, symbol in (("r", r), ("th", th), ("vp", vp))}
    for name, rhs in expected.items():
        actual = values[name].rhs.xreplace(functions).xreplace(sample)
        assert abs(float(sp.N(actual - rhs.subs(sample)))) < 1e-12, name
