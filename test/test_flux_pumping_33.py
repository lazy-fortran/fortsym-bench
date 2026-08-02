"""Independent checks for the recovered iota-series intermediates."""

import importlib.util
from pathlib import Path

import sympy as sp


def _load():
    path = (
        Path(__file__).parents[1]
        / 'corpus/proj-flux_pumping/33_iota_series_comparison.py'
    )
    spec = importlib.util.spec_from_file_location('flux_pumping_33', path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_iota_series_intermediates_have_the_source_derivative_forms():
    values = _load().results()
    rho, t = sp.symbols('rho t')
    det = sp.Function('det')
    displacement = sp.Function('displacement')
    a0 = sp.Function('a0')
    a1 = sp.Function('a1')
    a2 = sp.Function('a2')

    gamma = (
        displacement(rho) * sp.diff(displacement(rho), rho)
        + displacement(rho) ** 2
        * (1 + rho * sp.diff(det(rho), rho) / det(rho))
        / (2 * rho)
    )
    expected_surface_residual = sp.expand(
        -rho * det(rho) * gamma
        + (-det(rho) - rho * sp.diff(det(rho), rho))
        * displacement(rho) ** 2 / 2
        + displacement(rho)
        * (
            det(rho) * displacement(rho)
            + rho * sp.diff(det(rho) * displacement(rho), rho)
        )
    )
    expected_second_integrand = (
        gamma * sp.diff(a0(rho), rho)
        + displacement(rho) ** 2 * sp.diff(a0(rho), rho, 2) / 2
        - displacement(rho) * sp.diff(a1(rho), rho)
        + a2(rho)
    )

    assert sp.simplify(
        values['psiSecond']
        - (-det(rho) - rho * sp.diff(det(rho), rho))
    ) == 0
    assert sp.simplify(values['surfaceResidual'] - expected_surface_residual) == 0
    assert sp.simplify(
        values['shiftedRadius']
        - (rho - t * displacement(rho) + t**2 * gamma)
    ) == 0
    assert sp.simplify(values['secondIntegrand'] - expected_second_integrand) == 0
    assert sp.simplify(values['hCoefficient'] - expected_second_integrand) == 0
