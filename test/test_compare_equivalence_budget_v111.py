import sympy as sp

from fortsym_bench.compare import AGREE, DIFFER, compare


def test_equivalent_accepts_exactly_equal_large_trees_without_simplify():
    x = sp.Symbol("x")
    expression = sp.Add(*(x**index for index in range(20_000)))

    result = compare(expression, expression, "equivalent")

    assert result.outcome == AGREE


def test_equivalent_declines_oversized_nonidentical_trees_boundedly():
    x = sp.Symbol("x")
    left = sp.Add(*(x**index for index in range(20_000)))
    right = left + 1

    result = compare(left, right, "equivalent")

    assert result.outcome == DIFFER
