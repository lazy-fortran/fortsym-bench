from __future__ import annotations

import json
from pathlib import Path
import shutil

import pytest

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
