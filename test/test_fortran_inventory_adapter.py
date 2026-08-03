from __future__ import annotations

import json
from pathlib import Path
import shutil
import subprocess

import pytest

from fortsym_bench.wl_to_fortran import (
    WolframFortranTranslationError,
    translate_bounded_while,
    translate_wolfram_file_to_fortran,
)
from tools.inventory_wl_to_f90 import main


@pytest.mark.skipif(shutil.which("gfortran") is None, reason="gfortran is required")
def test_assignment_adapter_inventories_and_compiles_real_corpus_source(
    tmp_path: Path,
) -> None:
    repo = Path(__file__).parents[1]
    source = (
        repo
        / "corpus"
        / "nc-stud-Bacc_Verena_Eselbauer"
        / "schreckliches_problem.wl"
    )
    report_path = tmp_path / "inventory.json"

    status = main(
        [
            "--corpus",
            str(source.parent),
            "--report",
            str(report_path),
            "--mode",
            "assignment-adapter",
            "--timeout",
            "5",
        ]
    )

    assert status == 0
    report = json.loads(report_path.read_text())
    assert report["translation_mode"] == "assignment-adapter"
    assert report["counts"]["translated"] >= 1
    result = next(
        item for item in report["sources"]
        if item["source"] == "schreckliches_problem.wl"
    )
    assert result["status"] == "translated"
    assert result["output_bytes"] > 0
    assert not list(source.parent.glob("*.f90"))


def test_assignment_adapter_refuses_sources_over_the_explicit_limit(
    tmp_path: Path,
) -> None:
    source = tmp_path / "large.wl"
    source.write_text("x = 1\n" + " " * 32)
    report_path = tmp_path / "inventory.json"

    status = main(
        [
            "--corpus",
            str(tmp_path),
            "--report",
            str(report_path),
            "--mode",
            "assignment-adapter",
            "--adapter-max-source-bytes",
            "8",
        ]
    )

    assert status == 0
    report = json.loads(report_path.read_text())
    assert report["counts"]["refused"] == 1
    assert "adapter limit" in report["sources"][0]["detail"]


@pytest.mark.skipif(shutil.which("gfortran") is None, reason="gfortran is required")
def test_assignment_adapter_inventories_and_runs_bounded_while(
    tmp_path: Path,
) -> None:
    corpus = tmp_path / "corpus"
    corpus.mkdir()
    source = corpus / "bounded_while.wl"
    source.write_text("Null, While[i < 4, i++], Null\n")
    report_path = tmp_path / "inventory.json"

    status = main(
        [
            "--corpus",
            str(corpus),
            "--report",
            str(report_path),
            "--mode",
            "assignment-adapter",
            "--timeout",
            "5",
        ]
    )

    assert status == 0
    report = json.loads(report_path.read_text())
    assert report["counts"] == {
        "compile-error": 0,
        "error": 0,
        "refused": 0,
        "timeout": 0,
        "translated": 1,
        "unavailable": 0,
    }

    generated = tmp_path / "generated.f90"
    translate_wolfram_file_to_fortran(source, generated)
    driver = tmp_path / "driver.f90"
    driver.write_text(
        """program independent_bounded_while_oracle
  implicit none
  integer :: i
  i = 1
  call fortsym_generated_assignment(i)
  if (i /= 4) error stop 1
  i = 7
  call fortsym_generated_assignment(i)
  if (i /= 7) error stop 2
  print *, "PASS independent bounded While oracle"
end program independent_bounded_while_oracle
"""
    )
    executable = tmp_path / "driver"
    compile = subprocess.run(
        [
            "gfortran",
            "-std=f2018",
            "-Wall",
            "-Werror",
            "-o",
            str(executable),
            str(generated),
            str(driver),
        ],
        capture_output=True,
        text=True,
        check=False,
    )
    assert compile.returncode == 0, compile.stderr
    run = subprocess.run(
        [str(executable)], capture_output=True, text=True, check=False
    )
    assert run.returncode == 0, run.stderr
    assert "PASS independent bounded While oracle" in run.stdout

    with pytest.raises(WolframFortranTranslationError, match="bound exceeds"):
        translate_bounded_while("While[i < 129, i++]")
