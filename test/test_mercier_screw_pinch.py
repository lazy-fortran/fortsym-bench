import importlib.util
from pathlib import Path

import sympy as sp


def _load():
    path = Path(__file__).parents[1] / 'corpus/proj-gvec-stability/mercier_screw_pinch.py'
    spec = importlib.util.spec_from_file_location('mercier_screw_pinch', path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_force_balance_rule_and_geodesic_term_are_source_faithful():
    values = _load().results()
    r, mu0 = sp.symbols('r mu0')
    btheta = sp.Function('btheta')
    bz = sp.Function('bz')
    derivative1 = sp.Function('Derivative1')
    expected = (
        -btheta(r) * (
            btheta(r) + r * derivative1(sp.Symbol('btheta'), 1, r)
        ) / (mu0 * r)
        - bz(r) * derivative1(sp.Symbol('bz'), 1, r) / mu0
    )
    rule = values['forceBalance']
    assert rule.func == sp.Function('RuleDelayed')
    assert sp.simplify(
        rule.args[1].subs({sp.Symbol('rr'): r}) - expected
    ) == 0
    assert values['dGeodesic'] == 0


def test_screw_pinch_mercier_reductions_preserve_source_derivative_heads():
    values = _load().results()
    r, rzero, mu0 = sp.symbols('r rzero mu0')
    pi = sp.pi
    btheta = sp.Function('btheta')
    bz = sp.Function('bz')
    derivative1 = sp.Function('Derivative1')
    B2 = btheta(r) ** 2 + bz(r) ** 2
    dbtheta = derivative1(sp.Symbol('btheta'), 1, r)
    dbz = derivative1(sp.Symbol('bz'), 1, r)
    xi_dot_b = (
        -dbz * btheta(r)
        - derivative1(sp.Symbol('currentI'), 1, r) * B2 / (r * bz(r))
        + bz(r) * (btheta(r) + r * dbtheta) / r
    )
    assert values['muJdotB'] == (
        -dbz * btheta(r) + bz(r) * (btheta(r) + r * dbtheta) / r
    )
    assert values['xiDotB'] == xi_dot_b
    assert values['dShear'] == (
        derivative1(sp.Symbol('iota'), 1, r) ** 2
        / (16 * r ** 2 * pi ** 2 * bz(r) ** 2)
    )
    assert values['dCurrent'] == (
        -rzero * derivative1(sp.Symbol('iota'), 1, r) * xi_dot_b
        / (4 * r ** 3 * pi ** 2 * bz(r) ** 4)
    )
    d2 = (
        r * derivative1(sp.Symbol('volume'), 2, r) * bz(r)
        - derivative1(sp.Symbol('psiR'), 1, r)
        * derivative1(sp.Symbol('volume'), 1, r)
    ) / (r ** 3 * bz(r) ** 3)
    assert values['d2VdPsi2'] == d2
    dp = derivative1(sp.Symbol('p'), 1, r)
    expected_well = (
        mu0 * rzero * dp * B2
        * (d2 - 4 * pi ** 2 * mu0 * rzero * dp
           / (r * bz(r) ** 2 * B2))
        / (16 * r ** 3 * pi ** 4 * bz(r) ** 4)
    )
    assert values['dWell'] == expected_well
    assert values['dMercier'] == values['dShear'] + values['dCurrent'] + expected_well
    safety_derivative = derivative1(sp.Symbol('safety'), 1, r)
    assert values['shearRatio'] == rzero * safety_derivative * btheta(r) / (r * bz(r))
    assert values['suydamRatio'] == (
        1 + 8 * mu0 * r * dp
        / (rzero ** 2 * safety_derivative ** 2 * btheta(r) ** 2)
    )
