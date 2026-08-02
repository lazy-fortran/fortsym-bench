"""Independent regression for the numeric ``Abs`` oracle mismatch."""

import sympy as sp

from fortsym_bench.wl_to_sympy import evaluate_assignments, extract_assignments


def test_numeric_abs_is_evaluated_before_downstream_arithmetic():
    assignments, skipped = extract_assignments(
        "epsCore = 1/165; DqPrimary = 1/100; "
        "DqSideband = Abs[2 - 1]; "
        "sidebandResonant = epsCore (DqPrimary/DqSideband)"
    )

    assert skipped == []
    values = evaluate_assignments(assignments)

    # Independent arithmetic oracle: |2 - 1| = 1, hence
    # (1/165) * ((1/100) / 1) = 1/16500.
    assert values["DqSideband"] == sp.Integer(1)
    assert values["sidebandResonant"] == sp.Rational(1, 16500)


def test_symbolic_abs_remains_an_explicit_opaque_wolfram_head():
    x = sp.Symbol("x")

    assert evaluate_assignments(extract_assignments("value = Abs[x]")[0])["value"] == (
        sp.Function("Abs")(x)
    )
