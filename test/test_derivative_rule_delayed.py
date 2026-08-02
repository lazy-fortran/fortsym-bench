from __future__ import annotations

import pytest
import sympy as sp

from fortsym_bench.wl_to_sympy import evaluate_expression


def test_one_argument_derivative_rule_delayed_substitutes_its_pattern_variable():
    assert evaluate_expression(
        "Derivative[1][p][r] /. Derivative[1][p][rr_] :> rr + 1"
    ) == sp.Symbol("r") + 1


def test_general_pattern_rule_delayed_is_refused_instead_of_guessed():
    with pytest.raises(NotImplementedError, match="derivative Pattern/Blank"):
        evaluate_expression("f[r] /. f[rr_] :> rr + 1")
