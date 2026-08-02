"""Independent checks for the scalar screw-pinch intermediates."""

import importlib.util
from pathlib import Path

import sympy as sp


def _values():
    path = Path(__file__).parents[1] / 'corpus/code-mhd1d/41_screwpinch_equilibrium.py'
    spec = importlib.util.spec_from_file_location('screwpinch_equilibrium', path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module.results()


def test_scalar_intermediates_preserve_the_source_equations_and_identities():
    values = _values()
    r, c, B2 = sp.symbols('r c B2')
    Bt, Bz, lam, p = (sp.Function(name) for name in ('Bt', 'Bz', 'lam', 'p'))
    bt, bz, lp, pp = Bt(r), Bz(r), lam(r), p(r)
    bt_d = sp.Derivative(bt, r)
    bz_d = sp.Derivative(bz, r)
    p_d = sp.Derivative(pp, r)

    assert values['jtAmp'] == -c * bz_d / (4 * sp.pi)
    assert values['ode1'] == sp.Eq(
        values['jtAmp'], lp * bt + c * p_d * bz / (bt**2 + bz**2)
    )
    assert values['ode2'] == sp.Eq(
        c * (r * bt_d + bt) / (4 * sp.pi * r),
        lp * bz - c * p_d * bt / (bt**2 + bz**2),
    )
    assert values['fbResidual'] == 0
    assert values['consForm'] == 0
