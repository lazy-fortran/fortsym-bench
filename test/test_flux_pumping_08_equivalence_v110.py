"""Independent checks for the v110 helical-core comparison policies."""

import sympy as sp

from fortsym_bench.compare import AGREE, DIFFER, compare


def test_rule_normal_forms_are_equivalent_only_when_declared():
    q0, d2, gam1, gam2, kap, qsrc = sp.symbols(
        "q0 d2 gam1 gam2 kap qsrc"
    )
    rule = sp.Function("Rule")
    native = sp.Tuple(
        rule(q0, qsrc - gam1 * kap * (1 - qsrc) / (-gam1 * kap - gam2)),
        rule(d2, -gam1 * (1 - qsrc) / (-gam1 * kap - gam2)),
    )
    canonical = sp.Tuple(
        rule(q0, qsrc + gam1 * kap * (1 - qsrc) / (gam1 * kap + gam2)),
        rule(d2, gam1 * (1 - qsrc) / (gam1 * kap + gam2)),
    )

    assert compare(native, canonical, "structural").outcome == DIFFER
    assert compare(native, canonical, "equivalent").outcome == AGREE
