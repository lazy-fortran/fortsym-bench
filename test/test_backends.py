"""Behavioral tests for backend subprocess protocols."""

from __future__ import annotations

from pathlib import Path
import shutil

import pytest

from fortsym_bench.backends import BACKENDS, run


@pytest.mark.skipif(shutil.which("mathics") is None, reason="Mathics3 is optional")
def test_mathics_quit_does_not_abort_the_result_protocol(tmp_path: Path):
    """Scripts that call Quit still produce the wrapper's R/T protocol."""
    source = tmp_path / "quit.wl"
    source.write_text("x = 2 + 3; Quit[1]\n", encoding="utf-8")

    results, seconds = run(BACKENDS["mathics"], source, 15.0)

    assert results["x"] == "5"
    assert seconds >= 0.0
