"""Independent checks for the CAS3D component formula lowering."""

import importlib.util
from pathlib import Path

import sympy as sp


def _load():
    path = Path(__file__).parents[1] / 'corpus/proj-gvec-stability/c_components.py'
    spec = importlib.util.spec_from_file_location('c_components', path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_component_formulas_follow_the_source_terms_without_guessing_intermediates():
    values = _load().results()

    r, u, v, length = sp.symbols('r u v len')
    btheta = sp.Function('btheta')
    bz = sp.Function('bz')
    xs = sp.Function('xs')(r, u, v)
    derivative1 = sp.Function('Derivative1')
    d2xu = derivative1(sp.Symbol('xu'), 2, r, u, v)
    d2xv = derivative1(sp.Symbol('xv'), 2, r, u, v)
    d3xu = derivative1(sp.Symbol('xu'), 3, r, u, v)
    d3xv = derivative1(sp.Symbol('xv'), 3, r, u, v)
    eta_u = -length * d2xv * btheta(r) + 2 * sp.pi * r * d2xu * bz(r)
    eta_v = -length * d3xv * btheta(r) + 2 * sp.pi * r * d3xu * bz(r)
    flux_t = derivative1(sp.Symbol('fluxT'), 1, r)
    flux_p = derivative1(sp.Symbol('fluxP'), 1, r)
    bmag = sp.sqrt(btheta(r) ** 2 + bz(r) ** 2)
    sqg = sp.Symbol('sqg')

    expected_two = -(
        sp.Symbol('jDotB') * sqg * xs
        + length * btheta(r) * eta_u
        + 2 * sp.pi * r * bz(r) * eta_v
        - xs * (-length * flux_t * btheta(r) + 2 * sp.pi * r * flux_p * bz(r))
    ) / (sqg * bmag)
    assert sp.simplify(values['cTwoFormula'] - expected_two) == 0

    pressure = -derivative1(sp.Symbol('bz'), 1, r) * bz(r) - btheta(r) * (
        btheta(r) + r * derivative1(sp.Symbol('btheta'), 1, r)
    ) / r
    expected_three = (
        -length * bz(r) * eta_u
        + 2 * sp.pi * r * btheta(r) * eta_v
        - sqg * xs * pressure
        - derivative1(sp.Symbol('xs'), 1, r, u, v)
        * (2 * sp.pi * length * r * btheta(r) ** 2
           + 2 * sp.pi * length * r * bz(r) ** 2)
        - xs * (length * flux_t * bz(r) + 2 * sp.pi * r * flux_p * btheta(r))
    ) / (sqg * bmag)
    assert sp.simplify(values['cThreeFormula'] - expected_three) == 0

    # The separate native-parser differences are intentionally not normalized
    # by this focused recovery.
