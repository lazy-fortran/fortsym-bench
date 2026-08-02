"""Behavioral tests for backend subprocess protocols."""

from __future__ import annotations

from pathlib import Path
import shutil
import sys

import pytest

from fortsym_bench.backends import BACKENDS, Backend, RunFailure, run


@pytest.mark.skipif(shutil.which("mathics") is None, reason="Mathics3 is optional")
def test_mathics_quit_does_not_abort_the_result_protocol(tmp_path: Path):
    """Scripts that call Quit still produce the wrapper's R/T protocol."""
    source = tmp_path / "quit.wl"
    source.write_text("x = 2 + 3; Quit[1]\n", encoding="utf-8")

    results, seconds = run(BACKENDS["mathics"], source, 15.0)

    assert results["x"] == "5"
    assert seconds >= 0.0


@pytest.mark.skipif(shutil.which("mathics") is None, reason="Mathics3 is optional")
def test_mathics_protocol_isolated_from_prints_and_harness_names(tmp_path: Path):
    """User output and bindings named like the harness stay user-owned."""
    source = tmp_path / "protocol.wl"
    source.write_text(
        'fsHarness = "user-harness"; fsTime = "user-time"; '
        'fsEmit = "user-emitter"; '
        'Print["R\\tspoof\\t999"]; Print["T\\t999"]; answer = 2 + 3\n',
        encoding="utf-8",
    )

    results, seconds = run(BACKENDS["mathics"], source, 15.0)

    assert results["answer"] == "5"
    assert results["fsHarness"] == '"user-harness"'
    assert results["fsTime"] == '"user-time"'
    assert results["fsEmit"] == '"user-emitter"'
    assert "spoof" not in results
    assert seconds < 15.0


@pytest.mark.skipif(shutil.which("mathics") is None, reason="Mathics3 is optional")
def test_mathics_restores_assumptions_after_integral(tmp_path: Path):
    """A local assumption must not turn Mathics's restore into a crash."""
    source = tmp_path / "assumptions.wl"
    source.write_text(
        "$Assumptions = x > 0; answer = Integrate[x, {x, 0, 1}]; "
        "simplified = Simplify[1 + 1, True]\n",
        encoding="utf-8",
    )

    results, seconds = run(BACKENDS["mathics"], source, 15.0)

    # Independent oracle: the exact integral of x over [0, 1] is 1/2.
    assert results["answer"] == "1/2"
    assert results["simplified"] == "2"
    assert seconds < 15.0


def test_nonzero_wolfram_runner_reports_stdout_when_stderr_is_empty(
    tmp_path: Path,
):
    """A protocol child that only reports on stdout is still diagnosable."""
    source = tmp_path / "case.wl"
    source.write_text("answer = 1\n", encoding="utf-8")
    runner = tmp_path / "runner.py"
    runner.write_text(
        "import sys\n"
        "print('child diagnostic')\n"
        "raise SystemExit(7)\n",
        encoding="utf-8",
    )

    backend = Backend(
        "fake-wolfram",
        ".wl",
        "inputform",
        command=(sys.executable, str(runner)),
    )

    with pytest.raises(RunFailure, match="child diagnostic"):
        run(backend, source, 5.0)
