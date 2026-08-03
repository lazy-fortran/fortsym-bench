from __future__ import annotations

from pathlib import Path

import sympy as sp


_SOURCE = Path(__file__).parents[1] / 'corpus/proj-flux_pumping/54_access_conditions.py'


def _values():
    namespace = {}
    exec(compile(_SOURCE.read_text(), str(_SOURCE), 'exec'), namespace)
    return namespace['results']()


def test_hopf_determinant_matches_an_independent_reduced_jacobian_oracle():
    """The determinant is evaluated independently from the reduced vector field."""
    Ga, Kk, xx = sp.symbols('Ga Kk xx')
    amplitude = sp.sqrt(xx)
    independent_jacobian = sp.Matrix(
        [
            [-2 * Ga * xx, Ga * amplitude],
            [-2 * Kk * amplitude, 2 * Ga * xx],
        ]
    )

    observed = _values()['hopfDetAtRoot']
    expected = independent_jacobian.det()

    assert observed == sp.expand(2 * Ga * xx * (Kk - 2 * Ga * xx))
    assert sp.simplify(observed - expected) == 0
    assert observed.subs({Ga: sp.Rational(3, 2), Kk: 7, xx: sp.Rational(2, 3)}) == 10
