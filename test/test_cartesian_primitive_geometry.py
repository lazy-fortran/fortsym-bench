import importlib.util

import sympy as sp


def _module():
    path = 'corpus/proj-gvec-stability/cartesian_primitive_geometry.py'
    spec = importlib.util.spec_from_file_location('cartesian_primitive_geometry', path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def test_phi_prime_behaves_as_profile_derivative():
    s = sp.Symbol('s')
    profile = sp.Function('phiProfile')
    derivative = _module().results()['phiPrime']

    concrete_profile = s**3 + 2*s
    assert derivative.subs(profile(s), concrete_profile).doit().subs(s, 2) == 14


def test_flux_intermediates_follow_the_source_product_rules():
    values = _module().results()
    s = sp.Symbol('s')
    periods = sp.Symbol('periods')
    jacobian = values['jacobian']
    chi = sp.Function('chiProfile')(s)
    phi = sp.Function('phiProfile')(s)

    assert values['chiPrime'] == sp.diff(chi, s)
    assert values['chiSecond'] == sp.diff(chi, s, 2)
    assert values['phiSecond'] == sp.diff(phi, s, 2)
    assert values['bt'] == -values['chiPrime'] / (periods * jacobian)
    assert values['bz'] == -values['phiPrime'] / jacobian
    assert sp.simplify(values['btRadial'] - sp.diff(values['bt'], s)) == 0
    assert sp.simplify(values['bzRadial'] - sp.diff(values['bz'], s)) == 0
