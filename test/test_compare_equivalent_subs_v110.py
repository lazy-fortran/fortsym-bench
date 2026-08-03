"""Independent regression for explicit derivative-substitution equivalence."""

import sympy as sp

from fortsym_bench.compare import AGREE, DIFFER, compare


def test_substituted_opaque_derivative_is_equivalent_only_when_opted_in():
    t = sp.Symbol("t")
    derivative = sp.Function("Derivative1")
    fixture = sp.Function("fixtureSegment")
    native = sp.Tuple(
        fixture(0, 1),
        derivative(sp.Symbol("fixtureSegment"), 1, 0, 1),
    )
    sympy_form = sp.Tuple(
        fixture(0, 1),
        sp.Subs(
            derivative(sp.Symbol("fixtureSegment"), 1, t, 1),
            (t,),
            (0,),
        ),
    )

    assert compare(native, sympy_form, "structural").outcome == DIFFER
    assert compare(native, sympy_form, "equivalent").outcome == AGREE
