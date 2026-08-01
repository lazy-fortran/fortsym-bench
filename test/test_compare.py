from __future__ import annotations

import sympy as sp

from fortsym_bench.cli import _score
from fortsym_bench.compare import ERROR, ORACLE_MISSING, check_oracles, compare
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
