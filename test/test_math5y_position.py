"""Independent regression for the math5y ``Position`` oracle mismatch."""

import sympy as sp

from fortsym_bench.wl_to_sympy import evaluate_assignments, extract_assignments


def test_math5y_power_positions_follow_wolfram_plus_order():
    assignments, skipped = extract_assignments(
        "poly = c^3 + a*x^3 + 3*x*y + b^4*y^3; "
        "powerPositions = Position[poly, (y_)^(n_)]"
    )

    assert skipped == []
    actual = evaluate_assignments(assignments)["powerPositions"]

    # Hand-derived from Wolfram's FullForm:
    # Plus[Times[a, Power[x, 3]], Times[Power[b, 4], Power[y, 3]],
    #      Power[c, 3], Times[3, x, y]].  The blank-power pattern matches
    # each Power node at the following one-based paths.
    assert actual == sp.Tuple(
        sp.Tuple(1, 2),
        sp.Tuple(2, 1),
        sp.Tuple(2, 2),
        sp.Tuple(3),
    )
