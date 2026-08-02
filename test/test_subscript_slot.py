from __future__ import annotations

import pytest
import sympy as sp

from fortsym_bench.wl_to_sympy import evaluate_assignments, evaluate_expression, extract_assignments


def test_nested_subscripts_are_symbolic_labels_not_python_indexing():
    assignments, skipped = extract_assignments(
        "value = r*(Subscript[R, 0] + r*Cos[ϑ]) + Subscript[B, φ]"
    )

    assert skipped == []
    r, theta, phi = sp.symbols("r ϑ φ")
    subscript = sp.Function("Subscript")
    expected = r * (subscript(sp.Symbol("R"), 0) + r * sp.cos(theta))
    expected += subscript(sp.Symbol("B"), phi)
    assert evaluate_assignments(assignments)["value"] == expected


def test_flux_dpsitildedth_has_the_integrated_subscript_expression():
    assignments, skipped = extract_assignments(
        "sqg = r*(Subscript[R, 0] + r*Cos[ϑ]); "
        "dnudth = sqg*Subscript[B, φ]; "
        "psidot = (1/(2*Pi))*Integrate[dnudth, {ϑ, 0, 2*Pi}]; "
        "dpsitildedth = dnudth - psidot"
    )

    assert skipped == []
    r, theta, phi = sp.symbols("r ϑ φ")
    subscript = sp.Function("Subscript")
    expected = r**2 * sp.cos(theta) * subscript(sp.Symbol("B"), phi)
    actual = evaluate_assignments(assignments)["dpsitildedth"]
    assert sp.simplify(actual - expected) == 0


def test_first_surface_slot_pipeline_has_one_based_row_selection():
    assignments, skipped = extract_assignments(
        'number[s_] := ToExpression[StringReplace[s, "E" -> "*^"]]; '
        'tokens = {{"0", "0", "0.05", "1", "2", "3"}, '
        '{"1", "2", "0.01", "4", "5", "6"}, '
        '{"0", "3", "-0.05", "7", "8", "9"}, '
        '{"not-a-number", "4", "0", "1", "2", "3"}}; '
        'modeRows = Map[number, Select[tokens, Length[#] == 6 && '
        'StringMatchQ[#[[1]], NumberString] && '
        'StringMatchQ[#[[2]], NumberString] &], {2}]; '
        'firstSurface = Take[modeRows, 6]; '
        'axisRows = Select[firstSurface, #[[1]] == 0 &]'
    )

    assert skipped == []
    values = evaluate_assignments(assignments)
    assert values["firstSurface"] == sp.Tuple(
        sp.Tuple(0, 0, sp.Float("0.05"), 1, 2, 3),
        sp.Tuple(1, 2, sp.Float("0.01"), 4, 5, 6),
        sp.Tuple(0, 3, sp.Float("-0.05"), 7, 8, 9),
    )
    assert values["axisRows"] == sp.Tuple(
        sp.Tuple(0, 0, sp.Float("0.05"), 1, 2, 3),
        sp.Tuple(0, 3, sp.Float("-0.05"), 7, 8, 9),
    )


def test_unbounded_slot_forms_remain_explicitly_refused():
    with pytest.raises(NotImplementedError, match="SlotSequence"):
        evaluate_expression("SlotSequence[1]")
    with pytest.raises(NotImplementedError, match="one-based"):
        evaluate_expression("Slot[0]")
