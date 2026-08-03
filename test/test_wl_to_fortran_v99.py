from __future__ import annotations

from pathlib import Path
import shutil
import subprocess

import pytest

from fortsym_bench.wl_to_fortran import (
    WolframFortranTranslationError,
    translate_bounded_do,
)


@pytest.mark.skipif(shutil.which("gfortran") is None, reason="gfortran is required")
def test_bounded_do_generates_and_runs_against_independent_oracle(
    tmp_path: Path,
) -> None:
    generated = translate_bounded_do(
        "Null, Do[result = offset + 0.5*i, {i, 2, 5}], Null"
    )
    generated_path = tmp_path / "generated.f90"
    driver_path = tmp_path / "driver.f90"
    executable = tmp_path / "driver"
    generated_path.write_text(generated)
    driver_path.write_text(
        """program independent_bounded_do_oracle
  use, intrinsic :: iso_fortran_env, only: real64
  implicit none
  real(real64) :: offset, result
  offset = 1.25_real64
  call fortsym_generated_assignment(offset, result)
  if (abs(result - (offset + 0.5_real64*5.0_real64)) > 1.0e-14_real64) error stop 1
  print *, "PASS independent bounded Do oracle"
end program independent_bounded_do_oracle
"""
    )

    compile = subprocess.run(
        [
            "gfortran",
            "-std=f2018",
            "-Wall",
            "-Werror",
            "-o",
            str(executable),
            str(generated_path),
            str(driver_path),
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
    assert "PASS independent bounded Do oracle" in run.stdout


def test_bounded_do_rejects_empty_oversized_and_noncanonical_ranges() -> None:
    with pytest.raises(WolframFortranTranslationError, match="range is empty"):
        translate_bounded_do("Do[result = x + i, {i, 4, 3}]")
    with pytest.raises(WolframFortranTranslationError, match="128-iteration"):
        translate_bounded_do("Do[result = x + i, {i, 1, 129}]")
    with pytest.raises(WolframFortranTranslationError, match="three-item range"):
        translate_bounded_do("Do[result = x + i, {i, 1, 5, 2}]")
