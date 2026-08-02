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


@pytest.mark.skipif(shutil.which("mathics") is None, reason="Mathics3 is optional")
def test_mathics_leaves_invalid_curl_unevaluated_without_sympy_api_crash(
    tmp_path: Path,
):
    """Invalid Curl arity is unevaluated, while a valid 2-D curl still works."""
    source = tmp_path / "curl_compat.wl"
    source.write_text(
        "invalid = Curl[a]; valid = Curl[{y, -x}, {x, y}]\n",
        encoding="utf-8",
    )

    results, seconds = run(BACKENDS["mathics"], source, 15.0)

    # Wolfram's own arity behavior is the independent oracle here: the bad
    # call stays as Curl[a], and curl({y,-x}) = d(-x)/dx - d(y)/dy = -2.
    assert results["invalid"] == "Curl[a]"
    assert results["valid"] == "-2"
    assert seconds < 15.0


@pytest.mark.skipif(shutil.which("mathics") is None, reason="Mathics3 is optional")
def test_mathics_evaluates_bounded_cylindrical_curl(tmp_path: Path):
    """The explicit cylindrical Curl rule has the hand-derived components."""
    source = tmp_path / "cylindrical_curl.wl"
    source.write_text(
        'value = Curl[{r^2, r*z, r*theta}, {r, theta, z}, "Cylindrical"] '
        '/. {r -> 2, theta -> 3, z -> 5}\n',
        encoding="utf-8",
    )

    results, seconds = run(BACKENDS["mathics"], source, 15.0)

    # (d_theta A_z - d_z(r A_theta))/r, d_z A_r - d_r A_z,
    # (d_r(r A_theta) - d_theta A_r)/r = (-1, -3, 10).
    assert results["value"] == "{-1, -3, 10}"
    assert seconds < 15.0


@pytest.mark.skipif(shutil.which("mathics") is None, reason="Mathics3 is optional")
def test_mathics_leaves_derivative_of_relational_unevaluated(tmp_path: Path):
    """A relational derivative must not enter SymPy's invalid derivative path."""
    source = tmp_path / "relational_derivative.wl"
    source.write_text(
        "answer = Simplify[D[x > 0, x]]\n",
        encoding="utf-8",
    )

    results, seconds = run(BACKENDS["mathics"], source, 15.0)

    # Independent Mathics evaluation of D[x > 0, x] is
    # Derivative[1, 0][Greater][x, 0]; Simplify must preserve that result.
    assert results["answer"] == "Derivative[1, 0][Greater][x, 0]"
    assert seconds < 15.0
