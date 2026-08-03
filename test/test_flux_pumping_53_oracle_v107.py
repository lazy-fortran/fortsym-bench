from __future__ import annotations

import importlib.util
from pathlib import Path

import sympy as sp


_SOURCE = (
    Path(__file__).parents[1]
    / "corpus/proj-flux_pumping/53_access_limit_cycle.py"
)


def _values():
    spec = importlib.util.spec_from_file_location("access_limit_cycle_53_v107", _SOURCE)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module.results()


def test_det_matches_an_independent_fixed_point_jacobian_oracle():
    """Evaluate the recovered determinant from a separately built Jacobian."""
    a, As, Dc, Dohm, eps, g0, k, tR = sp.symbols(
        "a As Dc Dohm eps g0 k tR"
    )
    A, D0 = sp.symbols("A D0")
    ds = Dc + a * As**2 / g0
    f = g0 * (D0 - Dc) * A - a * A**3
    g = (Dohm - D0) / tR + eps * D0 - k * A**2
    independent = sp.Matrix(
        [[sp.diff(f, A), sp.diff(f, D0)], [sp.diff(g, A), sp.diff(g, D0)]]
    ).subs({A: As, D0: ds})

    observed = _values()["det"]
    expected = sp.factor(independent.det())

    assert sp.simplify(observed - expected) == 0
    assert observed.subs(
        {a: 2, As: 3, Dc: 1, Dohm: 8, eps: sp.Rational(1, 5), g0: 4, k: 5, tR: 2}
    ) == expected.subs(
        {a: 2, As: 3, Dc: 1, Dohm: 8, eps: sp.Rational(1, 5), g0: 4, k: 5, tR: 2}
    )
