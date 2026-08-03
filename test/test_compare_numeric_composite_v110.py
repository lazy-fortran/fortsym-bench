"""Independent regression for numeric composite guard-digit comparison."""

import sympy as sp

from fortsym_bench.compare import AGREE, compare


def test_machine_and_exact_complex_composites_are_numeric_equivalents():
    exact = sp.Float("1.85019542867544e-6") * sp.sqrt(2) * (
        -500 + sp.Float("3104.0") * sp.sqrt(30) * sp.I
    )
    machine = sp.Float("1.85019542867544e-6") * sp.sqrt(2) * (
        -500 + sp.Float("17001.3081849604") * sp.I
    )

    assert compare(exact, machine, "numeric").outcome == AGREE
