import sympy as sp
from importlib.util import module_from_spec, spec_from_file_location
from pathlib import Path


def _load(name):
    path = Path(__file__).parents[1] / "corpus" / "code-KiLCA" / f"{name}.py"
    spec = spec_from_file_location(name, path)
    module = module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def _expected_jlimt():
    alpha, beta, omega, omega0, kp, vt = sp.symbols(
        "alpha beta omega omega0 kp Vt"
    )
    abs_head = sp.Function("Abs")
    erfi = sp.Function("Erfi")
    return (
        sp.sqrt(2 * sp.pi)
        * vt
        * (
            sp.exp(
                (omega - omega0)
                * (-omega + omega0 + 2 * (alpha + beta) * kp * vt**2)
                / (2 * kp**2 * vt**2)
            )
            * sp.sqrt(sp.pi / 2)
            * (
                1
                - sp.I
                * erfi(
                    (-omega + omega0 + (alpha + beta) * kp * vt**2)
                    * abs_head(kp)
                    / (sp.sqrt(2) * kp**2 * vt)
                )
            )
            / (vt * abs_head(kp))
        )
    )


def test_both_companions_preserve_explicit_jlimt_replacement():
    expected = _expected_jlimt()
    point = {
        sp.Symbol("alpha"): sp.Rational(1, 7),
        sp.Symbol("beta"): sp.Rational(2, 11),
        sp.Symbol("omega"): sp.Rational(3, 5),
        sp.Symbol("omega0"): sp.Rational(7, 4),
        sp.Symbol("kp"): sp.Rational(5, 3),
        sp.Symbol("Vt"): sp.Rational(9, 2),
    }
    for module in (_load("coll"), _load("coll_new")):
        actual = module.results()["JLimT"]
        assert sp.simplify((actual - expected).subs(point)) == 0
