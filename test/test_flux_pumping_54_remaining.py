from __future__ import annotations

import math
from pathlib import Path

import pytest


_SOURCE = Path(__file__).parents[1] / 'corpus/proj-flux_pumping/54_access_conditions.py'


def _values():
    namespace = {}
    exec(compile(_SOURCE.read_text(), str(_SOURCE), 'exec'), namespace)
    return namespace['results']()


def _independent_kinetic_slope():
    """Finite-difference oracle for the source's normalized kinetic response."""
    eta0 = 241 / 100 * 1e-9
    bb0 = 257 / 100
    nne = 98 / 100 * 1e20
    rr0 = 441 / 100 / bb0
    me = 91093837 / 1e38
    ee = 1602177 / 1e25
    te_kev = (165 / 100 * 1e-9 * 15 / eta0) ** (2 / 3)
    vte = math.sqrt(te_kev * 1e3 * ee / me)
    nu_eff = nne * ee**2 * eta0 / me
    mfp_over_r0 = vte / nu_eff / rr0

    def response(xi):
        return (
            1
            - math.sqrt(math.pi / 2)
            * math.exp(1 / (2 * xi**2))
            * math.erfc(1 / (xi * math.sqrt(2)))
            / xi
        ) / xi**2

    def psi(detuning):
        return detuning * response(detuning * mfp_over_r0) / (
            0.01 * response(0.01 * mfp_over_r0)
        )

    h = 1e-7
    return (psi(0.01 + h) - psi(0.01 - h)) / (2 * h)


def test_slope_kin_matches_independent_kinetic_response_oracle():
    slope = float(_values()['slopeKin'])
    expected = _independent_kinetic_slope()

    assert slope < 0
    assert slope == pytest.approx(expected, abs=2e-7)


def test_kinetic_feedback_uses_the_source_evaluated_slope():
    values = _values()
    kk_aug_real = 172817679558011 / 100000000000000
    a_star_sq_aug = 1 / 100 + 0.1057289002557545
    expected = -kk_aug_real * a_star_sq_aug * float(values['slopeKin'])

    assert float(values['eEffKinetic']) == pytest.approx(expected, rel=1e-15)
