import importlib.util
from pathlib import Path

import sympy as sp


_SOURCE = Path(__file__).parents[1] / "corpus/proj-flux_pumping/02_linear_deltaf.py"
_SPEC = importlib.util.spec_from_file_location("linear_deltaf", _SOURCE)
_MODULE = importlib.util.module_from_spec(_SPEC)
assert _SPEC.loader is not None
_SPEC.loader.exec_module(_MODULE)


def test_linear_deltaf_thermodynamic_forces_are_source_derived():
    values = _MODULE.results()
    r = sp.Symbol("r")
    n, temperature, potential = (
        sp.Function(name) for name in ("n", "T", "Phi0")
    )
    derivative1 = sp.Function("Derivative1")

    expected_a1 = (
        derivative1(sp.Symbol("n"), 1, r) / n(r)
        + sp.Symbol("ee") * derivative1(sp.Symbol("Phi0"), 1, r) / temperature(r)
        - sp.Rational(3, 2)
        * derivative1(sp.Symbol("T"), 1, r)
        / temperature(r)
    )
    expected_a2 = derivative1(sp.Symbol("T"), 1, r) / temperature(r)

    assert values["A1"] == expected_a1
    assert values["A2"] == expected_a2


def test_linear_deltaf_drive_uses_recovered_forces():
    values = _MODULE.results()
    r, v = sp.symbols("r v")
    me, ee = sp.symbols("me ee")
    n = sp.Function("n")
    temperature, potential = sp.Function("T"), sp.Function("Phi0")
    derivative1 = sp.Function("Derivative1")
    a1 = values["A1"]
    a2 = values["A2"]
    expected = (
        n(r)
        * sp.exp(-me * v**2 / (2 * temperature(r)))
        * (me / (2 * sp.pi * temperature(r))) ** sp.Rational(3, 2)
        * (a1 + me * v**2 * a2 / (2 * temperature(r)))
    )
    assert sp.simplify(values["rhsForces"] - expected) == 0
