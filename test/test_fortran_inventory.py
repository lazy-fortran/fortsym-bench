from __future__ import annotations

import json
from pathlib import Path
import sys

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
    }
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
