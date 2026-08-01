from __future__ import annotations

import sympy as sp

from fortsym_bench.wl_to_sympy import evaluate_assignments, extract_assignments


def test_compound_expression_and_function_assignments_are_evaluated_in_order():
    assignments, skipped = extract_assignments(
        "Clear[x], Null, f[i_] := i^2; values = Table[f[i], {i, 3}]"
    )

    assert [assignment.name for assignment in assignments] == ["f", "values"]
    assert skipped == ["Clear[x]", "Null"]

    values = evaluate_assignments(assignments)
    assert values["values"] == sp.Tuple(1, 4, 9)


def test_matrix_operations_and_replacement_have_independent_sympy_answers():
    assignments, _ = extract_assignments(
        "m = {{1, 2}, {3, 4}}; v = {x, y}; "
        "product = m . v; replaced = product /. {x -> 5, y -> 7}; "
        "inverse = Inverse[m]"
    )

    values = evaluate_assignments(assignments)
    x, y = sp.symbols("x y")
    assert values["product"] == sp.Tuple(x + 2 * y, 3 * x + 4 * y)
    assert values["replaced"] == sp.Tuple(19, 43)
    assert values["inverse"] == sp.Tuple(
        sp.Tuple(-2, 1), sp.Tuple(sp.Rational(3, 2), -sp.Rational(1, 2))
    )


def test_pure_functions_map_apply_and_mapthread():
    assignments, skipped = extract_assignments(
        "squares = Map[#^2 &, {1, 2, 3}]; "
        "total = Apply[Plus, {1, 2, 3}]; "
        "paired = MapThread[#1 + #2 &, {{1, 2}, {3, 4}}]"
    )

    assert skipped == []
    values = evaluate_assignments(assignments)

    assert values["squares"] == sp.Tuple(1, 4, 9)
    assert values["total"] == 6
    assert values["paired"] == sp.Tuple(4, 6)


def test_a_script_without_assignments_returns_an_empty_result_set():
    assignments, skipped = extract_assignments("Print[1]; Null")

    assert assignments == []
    assert skipped == ["Print[1]", "Null"]
    assert evaluate_assignments(assignments) == {}
