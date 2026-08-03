"""Independent regression tests for explicitly equivalent equations."""

import sympy as sp

from fortsym_bench.compare import AGREE, DIFFER, compare


def test_rearranged_equations_are_equivalent_only_under_explicit_policy():
    h1, h2, m0, m1, m2, y0, y1, y2 = sp.symbols(
        "h1 h2 m0 m1 m2 y0 y1 y2"
    )
    left = sp.Eq(
        h1 * m0 + 2 * (h1 + h2) * m1 + h2 * m2,
        6 * ((y2 - y1) / h2 - (y1 - y0) / h1),
        evaluate=False,
    )
    right = sp.Eq(
        h1 * m0 + 2 * (h1 + h2) * m1 + h2 * m2,
        6 * (-(y1 - y0) / h1 + (y2 - y1) / h2),
        evaluate=False,
    )

    assert compare(left, right, "structural").outcome == DIFFER
    assert compare(left, right, "equivalent").outcome == AGREE


def test_equivalent_equations_do_not_hide_a_changed_residual():
    x, y = sp.symbols("x y")
    original = sp.Eq(x + 1, y, evaluate=False)
    changed = sp.Eq(x + 2, y, evaluate=False)

    assert compare(original, changed, "equivalent").outcome == DIFFER
