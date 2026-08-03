"""Independent regression for the cylinder phase-averaged energy kernel."""

import importlib.util
from pathlib import Path

import sympy as sp


def _load_module():
    path = (
        Path(__file__).parents[1]
        / 'corpus/proj-gvec-stability/cylinder_compressional_spectrum.py'
    )
    spec = importlib.util.spec_from_file_location('cylinder_spectrum_remaining', path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_lag_kernel_is_the_exact_quadratic_phase_average():
    module = _load_module()
    values = module.results()

    phi = sp.Symbol('phi')
    raw = values['sqg'] * (
        values['wKernelDensity'] - sp.Symbol('w2') * values['mKernelDensity']
    )

    # Use a separate numeric oracle: after assigning nonzero rational profile
    # values, integrate the original sin/cos expression over one full phase.
    # This does not call the implementation's four-point averaging rule.
    substitutions = {}
    value = sp.Rational(2, 3)
    for node in raw.atoms(sp.Function):
        if node.func not in (sp.sin, sp.cos):
            substitutions[node] = value
            value += sp.Rational(1, 7)
    for node in raw.atoms(sp.Derivative):
        substitutions[node] = value
        value += sp.Rational(1, 11)
    for node in raw.free_symbols:
        if node != phi:
            substitutions[node] = value
            value += sp.Rational(1, 13)

    expected = sp.integrate(
        raw.xreplace(substitutions), (phi, 0, 2 * sp.pi)
    ) / (2 * sp.pi)
    actual = values['lagKernel'].xreplace(substitutions)

    assert sp.simplify(actual - expected) == 0
    assert not actual.has(sp.sin(phi), sp.cos(phi))


def test_physical_mass_and_lagrangian_follow_the_source_phase_average():
    values = _load_module().results()

    r = sp.Symbol('r')
    rho = sp.Function('rho')
    xr = sp.Function('xr')
    xt = sp.Function('xt')
    xz = sp.Function('xz')
    expected_mass = rho(r) * (
        xr(r)**2 + xt(r)**2 + xz(r)**2
    ) / 2

    assert sp.simplify(values['mPhysical'] - expected_mass) == 0
    expected_lagrangian = 2 * sp.pi * sp.Symbol('len') * r * (
        values['wPhysical'] - sp.Symbol('w2') * values['mPhysical']
    )
    assert sp.simplify(values['lagPhysical'] - expected_lagrangian) == 0
    assert not values['wPhysical'].has(
        sp.sin, sp.cos, sp.Symbol('theta'), sp.Symbol('z')
    )
