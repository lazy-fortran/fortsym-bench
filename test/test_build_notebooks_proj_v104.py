"""Independent check for the recovered project NTV response coefficient."""

import importlib.util
from pathlib import Path

import sympy as sp


def _module():
    path = Path(__file__).parents[1] / "corpus/proj-andreas-ntv/build_notebooks.py"
    spec = importlib.util.spec_from_file_location("build_notebooks_proj_v104", path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_a_coef_matches_independent_damped_response_formula():
    value = _module().results()["aCoef"]
    j = sp.Symbol("j")
    m = sp.Symbol("m")
    omega = sp.Symbol("omega")
    nu = sp.Symbol("nu")
    capital_omega = sp.Function("capitalOmega")
    h = sp.Function("h")
    derivative = sp.Function("Derivative1")(
        sp.Symbol("f0"), sp.Integer(1), j
    )
    sample = {
        m: 2,
        h(j): 3,
        derivative: 5,
        capital_omega(j): 7,
        omega: 1,
        nu: 4,
    }

    # Recompute the real response coefficient from the source definition,
    # independently of the translated delta binding and intermediate value.
    detuning = m * capital_omega(j) - omega
    expected = m * h(j) * derivative * detuning / (detuning**2 + nu**2)
    assert value.subs(sample) == expected.subs(sample)
