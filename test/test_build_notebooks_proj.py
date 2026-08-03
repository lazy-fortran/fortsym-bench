"""Independent checks for the project Andreas NTV notebook builder."""

import importlib.util
from pathlib import Path

import sympy as sp


def _module():
    path = Path(__file__).parents[1] / "corpus/proj-andreas-ntv/build_notebooks.py"
    spec = importlib.util.spec_from_file_location("build_notebooks_proj", path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_expected_gradient_is_the_independent_maxwellian_log_derivative():
    values = _module().results()
    r = sp.Symbol("r")
    n_fun = sp.Function("nFun")
    temp = sp.Function("temp")
    phi0 = sp.Function("phi0")
    energy, charge, mass = sp.symbols("energy charge mass")
    maxwellian = (
        n_fun(r)
        / (2 * sp.pi * mass * temp(r)) ** sp.Rational(3, 2)
        * sp.exp(-(energy - charge * phi0(r)) / temp(r))
    )

    expected = sp.diff(maxwellian, r) / maxwellian
    # The benchmark's Wolfram text protocol spells an unevaluated derivative
    # as Derivative1[function, order, argument].  Convert only the
    # independently derived result to that wire representation.
    derivative1 = sp.Function("Derivative1")
    expected = expected.xreplace(
        {
            sp.Derivative(n_fun(r), r): derivative1(sp.Symbol("nFun"), 1, r),
            sp.Derivative(temp(r), r): derivative1(sp.Symbol("temp"), 1, r),
            sp.Derivative(phi0(r), r): derivative1(sp.Symbol("phi0"), 1, r),
        }
    )
    assert sp.simplify(values["expectedGradient"] - expected) == 0
