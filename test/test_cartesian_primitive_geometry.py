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
