from __future__ import annotations

import math
from pathlib import Path
import shutil
import subprocess

import pytest

from fortsym_bench.wl_to_fortran import (
    normalize_assignment_stream,
    translate_wolfram_to_fortran,
)


def test_normalization_removes_only_top_level_null_fragments() -> None:
    source = 'a = f[1, 2]; Null, b = "Null, still text"; c = Null'

    assert normalize_assignment_stream(source) == (
        'a = f[1, 2]\n'
        'b = "Null, still text"\n'
        'c = Null\n'
    )


@pytest.mark.skipif(shutil.which("gfortran") is None, reason="gfortran is required")
def test_corpus_null_separators_generate_numerically_correct_fortran(
    tmp_path: Path,
) -> None:
    source_path = (
        Path(__file__).parents[1]
        / "corpus"
        / "nc-stud-Bacc_Verena_Eselbauer"
        / "schreckliches_problem.wl"
    )
    source = source_path.read_text()
    generated = translate_wolfram_to_fortran(source)

    radius = 2.0
    z = 3.0
    c1, c2, c3, c4, c5 = 1.0, 0.5, -0.25, 0.125, -0.0625
    d1, d2, d3, d4, d5 = -2.0, 0.25, 0.5, -0.125, 0.0625
    log_radius = math.log(radius)
    expected_uh = (
        c1
        + c2 * radius**2
        + c3 * (z**2 + radius**2 / 2 - radius**2 * log_radius)
        + c4 * (z**2 * (radius**2 / 2) - radius**4 / 8)
        + c5
        * (
            z**4
            + 3 * z**2 * radius**2
            - 15 * (radius**4 / 8)
            - 6 * z**2 * radius**2 * log_radius
            + (3 / 2) * radius**4 * log_radius
        )
    )
    expected_uf = (
        d1
        + d2 * radius**2
        + d3 * (z**2 + radius**2 * log_radius)
        + d4 * (radius**4 - 4 * radius**2 * z**2)
        + d5
        * (
            2 * z**4
            - 9 * z**2 * radius**2
            + 3 * radius**4 * log_radius
            - 12 * radius**2 * z**2 * log_radius
        )
    )

    generated_path = tmp_path / "generated.f90"
    driver_path = tmp_path / "driver.f90"
    executable = tmp_path / "driver"
    generated_path.write_text(generated)
    driver_path.write_text(
        f"""program independent_oracle
  use, intrinsic :: iso_fortran_env, only: real64
  implicit none
  real(real64) :: c1v, c2v, rv, c3v, zv, c4v, c5v
  real(real64) :: d1v, d2v, d3v, d4v, d5v, uh, uf
  c1v = {c1:.17g}_real64; c2v = {c2:.17g}_real64
  rv = {radius:.17g}_real64; c3v = {c3:.17g}_real64
  zv = {z:.17g}_real64; c4v = {c4:.17g}_real64
  c5v = {c5:.17g}_real64; d1v = {d1:.17g}_real64
  d2v = {d2:.17g}_real64; d3v = {d3:.17g}_real64
  d4v = {d4:.17g}_real64; d5v = {d5:.17g}_real64
  call fortsym_generated_assignment( &
      c1v, c2v, rv, c3v, zv, c4v, c5v, d1v, d2v, d3v, d4v, d5v, uh, uf)
  if (abs(uh - {expected_uh:.17g}_real64) > 1.0e-12_real64) error stop 1
  if (abs(uf - ({expected_uf:.17g}_real64)) > 1.0e-12_real64) error stop 2
  print *, "PASS independent Fortran oracle"
end program independent_oracle
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
    assert "PASS independent Fortran oracle" in run.stdout
