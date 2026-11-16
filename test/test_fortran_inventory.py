from __future__ import annotations

import json
import os
from pathlib import Path
import signal
import subprocess
import sys
import time

import pytest

from tools.inventory_wl_to_f90 import inventory, main


def test_inventory_reports_acceptance_boundary_without_writing_corpus(tmp_path: Path):
    corpus = tmp_path / "corpus"
    (corpus / "nested").mkdir(parents=True)
    (corpus / "accepted.wl").write_text("x = 1;\n")
    (corpus / "nested" / "also_accepted.wl").write_text("y = 2;\n")
    (corpus / "refused.wl").write_text("Plot[x, {x, 0, 1}]\n")

    translator = tmp_path / "fake_translator.py"
    translator.write_text(
        "import pathlib, sys\n"
        "source, output = map(pathlib.Path, sys.argv[1:])\n"
        "if 'Plot' in source.read_text():\n"
        "    print('translation refused: plot is unsupported', file=sys.stderr)\n"
        "    raise SystemExit(1)\n"
        "output.write_text('subroutine translated()\\nend subroutine translated\\n')\n"
    )

    report = inventory(
        corpus,
        (sys.executable, str(translator)),
        timeout=2,
    )

    assert report["source_count"] == 3
    assert report["counts"] == {
        "translated": 2,
        "compile-error": 0,
        "refused": 1,
        "timeout": 0,
        "unavailable": 0,
        "error": 0,
    }, report["sources"]
    assert report["sources"][2]["source"] == "refused.wl"
    assert report["sources"][2]["detail"] == "plot is unsupported"
    assert "semantic parity are not assessed" in report["acceptance_boundary"]
    assert not list(corpus.rglob("*.f90"))
    assert not list(corpus.rglob("*.o"))


def test_inventory_distinguishes_fortran_compile_errors(tmp_path: Path):
    corpus = tmp_path / "corpus"
    corpus.mkdir()
    (corpus / "broken.wl").write_text("x = 1;\n")

    translator = tmp_path / "bad_translator.py"
    translator.write_text(
        "import pathlib, sys\n"
        "_, output = map(pathlib.Path, sys.argv[1:])\n"
        "output.write_text('subroutine broken(\\nend subroutine broken\\n')\n"
    )

    report = inventory(
        corpus,
        (sys.executable, str(translator)),
        timeout=2,
    )

    assert report["schema"] == "fortsym-bench/wl-to-f90-inventory-v2"
    assert report["counts"]["compile-error"] == 1
    assert report["counts"]["translated"] == 0
    assert report["sources"][0]["output_bytes"] > 0
    assert report["sources"][0]["detail"]
    assert not list(corpus.rglob("*.f90"))
    assert not list(corpus.rglob("*.o"))


def test_inventory_cli_writes_machine_report_and_fails_strict_gate(tmp_path: Path):
    corpus = tmp_path / "corpus"
    corpus.mkdir()
    (corpus / "refused.wl").write_text("Unsupported[]\n")
    translator = tmp_path / "refuse.py"
    translator.write_text(
        "import sys\n"
        "print('translation refused: unsupported construct', file=sys.stderr)\n"
        "raise SystemExit(1)\n"
    )
    report_path = tmp_path / "report.json"

    status = main(
        [
            "--corpus",
            str(corpus),
            "--report",
            str(report_path),
            "--translator",
            sys.executable,
            str(translator),
            "--require-all-translated",
        ]
    )

    assert status == 1
    report = json.loads(report_path.read_text())
    assert report["source_count"] == 1
    assert report["counts"]["refused"] == 1


def _process_running(pid: int) -> bool:
    state = subprocess.run(
        ["ps", "-p", str(pid), "-o", "stat="], capture_output=True, text=True,
        check=False,
    ).stdout.strip()
    return bool(state) and not state.startswith("Z")


@pytest.mark.parametrize(("stage", "leader_exits"), [
    ("translator", False),
    ("assignment-adapter", False),
    ("compiler", False),
    ("translator", True),
    ("compiler", True),
])
def test_inventory_cleans_up_child_processes(
    tmp_path: Path, monkeypatch, stage: str, leader_exits: bool,
):
    corpus = tmp_path / "corpus"
    corpus.mkdir()
    (corpus / "input.wl").write_text("x = 1\n")
    pid_file = tmp_path / "child.pid"
    child = tmp_path / "child.py"
    child.write_text(
        "import os, signal, time\n"
        "from pathlib import Path\n"
        "signal.signal(signal.SIGTERM, signal.SIG_IGN)\n"
        f"Path({str(pid_file)!r}).write_text(str(os.getpid()))\n"
        "time.sleep(60)\n"
    )
    emitted_source = "subroutine translated()\nend subroutine translated\n"
    normal = tmp_path / "normal.py"
    normal.write_text(
        "import sys\nfrom pathlib import Path\n"
        f"Path(sys.argv[-1]).write_text({emitted_source!r})\n"
    )
    spawner = tmp_path / "fortsym_wl_to_f90"
    spawner.write_text(
        f"#!{sys.executable}\n"
        "import subprocess, sys, time\nfrom pathlib import Path\n"
        f"subprocess.Popen([sys.executable, {str(child)!r}], "
        f"stdout={'subprocess.DEVNULL' if leader_exits else 'None'}, "
        f"stderr={'subprocess.DEVNULL' if leader_exits else 'None'})\n"
        f"while not Path({str(pid_file)!r}).exists(): time.sleep(0.01)\n"
        f"Path(sys.argv[-1]).write_text({emitted_source!r})\n"
        + ("" if leader_exits else "time.sleep(60)\n")
    )
    spawner.chmod(0o755)
    monkeypatch.setenv("PATH", str(tmp_path) + os.pathsep + os.environ["PATH"])
    command = (sys.executable, str(spawner if stage == "translator" else normal))
    compiler = (sys.executable, str(spawner if stage == "compiler" else normal))

    try:
        report = inventory(
            corpus, command, timeout=0.5, compiler=compiler,
            mode="assignment-adapter" if stage == "assignment-adapter" else "native",
        )
        expected = "translated" if leader_exits else "timeout"
        assert report["sources"][0]["status"] == expected, report["sources"]
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
