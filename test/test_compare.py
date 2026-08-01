from __future__ import annotations

import sympy as sp

from fortsym_bench.cli import _score
from fortsym_bench.compare import (
    AGREE,
    ERROR,
    MAX_COMPARISON_TEXT,
    ORACLE_MISSING,
    check_oracles,
    compare,
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


def test_identical_serialized_results_are_agree_without_parsing():
    result = compare_text("x + 1", "x + 1", "inputform", "structural")

    assert result.outcome == AGREE


def test_oversized_nonidentical_result_is_bounded():
    result = compare_text(
        "x" * (MAX_COMPARISON_TEXT + 1), "y", "srepr", "structural"
    )

    assert result.outcome == ERROR
    assert "too large to parse" in result.detail
