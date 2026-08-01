from __future__ import annotations

import sympy as sp

from fortsym_bench.cli import _score, _score_against_oracles, _strictness
from fortsym_bench.compare import (
    AGREE,
    DIFFER,
    ERROR,
    MAX_COMPARISON_TEXT,
    ORACLE_MISSING,
    check_oracles,
    compare,
    compare_cross_text,
    compare_text,
)
from fortsym_bench.backends import BACKENDS


def test_candidate_only_binding_is_reported_outside_the_scored_overlap():
    scored = _score(
        {"candidate_only": "Integer(4)"},
        {"oracle_only": "Integer(4)"},
        BACKENDS["fortsym-wl"],
        "mathics",
        {},
    )

    assert scored["candidate_only"]["outcome"] == ORACLE_MISSING


def test_compare_metadata_is_not_scored_as_a_binding():
    scored = _score(
        {"__compare__": {"value": "equivalent"}, "value": "Integer(4)"},
        {"value": "Integer(4)"},
        BACKENDS["fortsym-wl"],
        "mathics",
        {},
    )

    assert list(scored) == ["value"]
    assert scored["value"]["outcome"] == AGREE


def test_compare_metadata_controls_strictness_for_the_pair():
    assert _strictness({"sympy": {"__compare__": {"value": "equivalent"}}}) == {
        "value": "equivalent"
    }


def test_cross_language_comparison_ignores_sympy_assumption_metadata():
    result = compare_cross_text(
        "x",
        "inputform",
        "Symbol('x', real=True)",
        "srepr",
        "structural",
    )

    assert result.outcome == AGREE


def test_cross_language_assumption_stripping_handles_nested_tuples():
    result = compare_cross_text(
        "{f[x], {x}}",
        "inputform",
        "Tuple(Function('f')(Symbol('x', real=True)), Tuple(Symbol('x', real=True)))",
        "srepr",
        "structural",
    )

    assert result.outcome == AGREE


def test_native_score_requires_agreement_between_both_oracles():
    scored = _score_against_oracles(
        {"value": "1"},
        {"value": "Integer(2)"},
        {"value": "3"},
        BACKENDS["fortsym-wl"],
        {},
    )

    assert scored["value"]["outcome"] == "oracle-disagreement"


def test_native_score_uses_a_single_available_oracle():
    scored = _score_against_oracles(
        {"value": "1"},
        {"value": "Integer(1)"},
        None,
        BACKENDS["fortsym-wl"],
        {},
    )

    assert scored["value"]["outcome"] == AGREE


def test_malformed_sympy_expression_is_an_error_not_a_benchmark_crash():
    candidate = sp.Add(sp.Tuple(1, 2), sp.Integer(1), evaluate=False)

    result = compare(candidate, sp.Integer(0), "structural")

    assert result.outcome == ERROR


def test_cross_oracle_booleans_are_not_treated_as_sympy_expressions():
    assert check_oracles(True, True, "structural") is None


def test_mathics_unicode_inputform_is_normalised_before_comparison():
    result = compare_text(
        "{x == 0, x -> -a}",
        "{x ⩵ 0, x ⇾ -a}",
        "inputform",
        "structural",
    )
    assert result.outcome == "agree"


def test_unicode_phi_does_not_make_an_opaque_application_unparseable():
    result = compare_text(
        "{A[r, phi, z]}",
        "{A[r, ϕ, z]}",
        "inputform",
        "structural",
    )
    assert result.outcome == "agree"


def test_inputform_bare_symbols_do_not_collide_with_sympy_builtins():
    result = compare_cross_text(
        "beta + zeta + RR",
        "inputform",
        "Add(Symbol('beta'), Symbol('zeta'), Symbol('RR'))",
        "srepr",
        "structural",
    )

    assert result.outcome == AGREE


def test_inputform_greek_symbols_are_safe_inside_function_arguments():
    result = compare_text(
        "Cos[θ] + beta",
        "Cos[θ] + beta",
        "inputform",
        "structural",
    )

    assert result.outcome == AGREE


def test_inputform_percent_output_reference_is_parseable():
    result = compare_text("% + 1", "% + 1", "inputform", "structural")

    assert result.outcome == AGREE


def test_inputform_wolfram_numeric_and_named_character_spellings_parse():
    result = compare_text(
        "List[3.0*^-2, \\[Omega]]",
        "List[0.03, Omega]",
        "inputform",
        "structural",
    )

    assert result.outcome == AGREE


def test_inputform_empty_applications_are_bounded_opaque_values():
    result = compare_text(
        "Directory[]",
        "Directory[] + 1",
        "inputform",
        "structural",
    )

    assert result.outcome == "differ"


def test_strings_and_first_derivatives_have_stable_comparison_atoms():
    string_result = compare_text(
        '"/tmp/native output"',
        '"/tmp/native output"',
        "inputform",
        "structural",
    )
    derivative_result = compare_text(
        "Derivative1[f, 1, x]",
        "Derivative[1][f][x]",
        "inputform",
        "structural",
    )
    assert string_result.outcome == "agree"
    assert derivative_result.outcome == "agree"


def test_first_partial_derivatives_use_the_native_coordinate_spelling():
    result = compare_text(
        "Derivative1[f, 3, x, y, z]",
        "Derivative[0, 0, 1][f][x, y, z]",
        "inputform",
        "structural",
    )
    assert result.outcome == AGREE


def test_mixed_derivatives_are_not_collapsed_to_first_derivatives():
    result = compare_text(
        "Derivative1[f, 1, x, y]",
        "Derivative[1, 1][f][x, y]",
        "inputform",
        "structural",
    )
    assert result.outcome == DIFFER


def test_distinct_strings_are_different_not_parser_errors():
    result = compare_text('"/tmp/a"', '"/tmp/b"', "inputform", "structural")
    assert result.outcome == "differ"


def test_identical_serialized_results_are_agree_without_parsing():
    result = compare_text("x + 1", "x + 1", "inputform", "structural")

    assert result.outcome == AGREE


def test_oversized_nonidentical_result_is_bounded():
    result = compare_text(
        "x" * (MAX_COMPARISON_TEXT + 1), "y", "srepr", "structural"
    )

    assert result.outcome == ERROR
    assert "too large to parse" in result.detail
