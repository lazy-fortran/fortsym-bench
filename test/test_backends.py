"""Behavioral tests for backend subprocess protocols."""

from __future__ import annotations

from pathlib import Path
import os
import signal
import shutil
import subprocess
import sys
import time

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


def test_successful_partial_runner_retains_bindings_and_refusal_context(tmp_path):
    from fortsym_bench.cache import ReferenceCache
    from fortsym_bench.cli import score_raw

    source = tmp_path / "case.wl"
    source.write_text("answer = 5\n")
    runner = tmp_path / "partial.py"
    runner.write_text(
        "import sys\n"
        "print('R\\tanswer\\t5')\nprint('T\\t0.0')\n"
        "print('UNSUPPORTED: <statement 2>: declined side effect', file=sys.stderr)\n"
    )
    backend = Backend("fortsym-wl", ".wl", "inputform",
                      command=(sys.executable, str(runner)))
    results, _ = run(backend, source, 5.0)
    assert results == {"answer": "5"}
    assert results.coverage == {
        "status": "partial",
        "refusals": ["UNSUPPORTED: <statement 2>: declined side effect"],
    }
    cache = ReferenceCache(tmp_path / "cache.json")
    cache.put_result(backend, source, 5.0, results)
    restored = ReferenceCache(cache.path).get(backend, source, 5.0).results
    assert restored.coverage == results.coverage
    scored = score_raw({"fortsym-wl": restored, "mathics": {"answer": "5"}}, {}, {})
    assert scored["outcomes"]["fortsym-wl"]["answer"]["outcome"] == "agree"
    assert scored["coverage"]["fortsym-wl"]["status"] == "partial"


def _process_running(pid: int) -> bool:
    state = subprocess.run(
        ["ps", "-p", str(pid), "-o", "stat="], capture_output=True, text=True,
        check=False,
    ).stdout.strip()
    return bool(state) and not state.startswith("Z")


@pytest.mark.parametrize("parent_exits", [False, True])
def test_backend_cleans_up_child_processes(tmp_path: Path, parent_exits: bool):
    source = tmp_path / "case.wl"
    source.write_text("answer = 1\n", encoding="utf-8")
    pid_file = tmp_path / "child.pid"
    child_code = (
        "import os, signal, time\n"
        "from pathlib import Path\n"
        "signal.signal(signal.SIGTERM, signal.SIG_IGN)\n"
        f"Path({str(pid_file)!r}).write_text(str(os.getpid()))\n"
        "time.sleep(60)\n"
    )
    runner = tmp_path / "runner.py"
    runner.write_text(
        "import subprocess, sys, time\n"
        "from pathlib import Path\n"
        f"subprocess.Popen([sys.executable, '-c', {child_code!r}], "
        f"stdout={'subprocess.DEVNULL' if parent_exits else 'None'}, "
        f"stderr={'subprocess.DEVNULL' if parent_exits else 'None'})\n"
        f"while not Path({str(pid_file)!r}).exists(): time.sleep(0.01)\n"
        + ("print('R\\tanswer\\t1'); print('T\\t0.0')\n" if parent_exits
           else "time.sleep(60)\n"),
        encoding="utf-8",
    )
    backend = Backend(
        "fortsym-wl", ".wl", "inputform",
        command=(sys.executable, str(runner)),
    )

    try:
        if parent_exits:
            results, _ = run(backend, source, 1.0)
            assert results == {"answer": "1"}
        else:
            with pytest.raises(RunFailure, match="exceeded") as failure:
                run(backend, source, 0.5)
            assert failure.value.kind == "timeout"
        pid = int(pid_file.read_text())
        deadline = time.monotonic() + 1.0
        while _process_running(pid) and time.monotonic() < deadline:
            time.sleep(0.01)
        assert not _process_running(pid)
    finally:
        if pid_file.exists():
            pid = int(pid_file.read_text())
            if _process_running(pid):
                os.kill(pid, signal.SIGKILL)
