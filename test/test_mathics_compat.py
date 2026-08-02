"""Behavioral coverage for the Mathics 10.0.1 compatibility shim."""

from __future__ import annotations

from pathlib import Path
import shutil

import pytest

from fortsym_bench.backends import BACKENDS, run


@pytest.mark.skipif(shutil.which("mathics") is None, reason="Mathics3 is optional")
def test_mathics_leaves_derivative_of_expression_head_unevaluated(tmp_path: Path):
    """A valid non-symbolic derivative head must not crash conversion."""
    source = tmp_path / "expression_head.wl"
    source.write_text(
        "answer = Simplify[Derivative[1][Subscript[y, 1]][t]]\n"
        "ordinary = Simplify[Derivative[1][f][t]]\n",
        encoding="utf-8",
    )

    results, seconds = run(BACKENDS["mathics"], source, 15.0)

    assert results["answer"] == "Derivative[1][Subscript[y, 1]][t]"
    assert results["ordinary"] == "Derivative[1][f][t]"
    assert seconds < 15.0
