"""Independent checks for the remaining geomint2d symbolic binding."""

import importlib.util
from pathlib import Path

import sympy as sp


def _module():
    path = Path(__file__).parents[1] / 'corpus/nc-kineq-old/geomint2d.py'
    spec = importlib.util.spec_from_file_location('geomint2d', path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_minv_preserves_the_source_symbolic_inverse_head():
    values = _module().results()

    x1, y1, x2, y2, x3, y3 = sp.symbols('x1 y1 x2 y2 x3 y3')
    expected = sp.Matrix(((1, 1, 1), (x1, x2, x3), (y1, y2, y3))).inv()
    assert sp.Matrix(values['Minv']) == expected


def test_affine_triangle_bindings_reconstruct_coordinates():
    values = _module().results()
    x1, y1, x2, y2, x3, y3, x, y = sp.symbols(
        'x1 y1 x2 y2 x3 y3 x y'
    )
    node = sp.Matrix(((x1, y1), (x2, y2), (x3, y3)))
    coordinates = sp.Matrix(values['L'])

    reconstructed = sp.Matrix(values['Mtri']) * coordinates
    assert reconstructed.applyfunc(sp.simplify) == sp.Matrix((1, x, y))
    assert sp.simplify(coordinates.dot(sp.ones(3, 1)) - 1) == 0
    assert (node.T * coordinates).applyfunc(sp.simplify) == sp.Matrix((x, y))


def test_n12_is_the_source_antisymmetric_barycentric_gradient():
    values = _module().results()
    x, y = sp.symbols('x y')
    l1, l2, _ = values['L']
    expected = sp.Tuple(
        l1 * sp.diff(l2, y) - l2 * sp.diff(l1, y),
        l1 * sp.diff(l2, x) - l2 * sp.diff(l1, x),
    )
    assert values['N12'] == expected


def test_cylindrical_curl_recovers_the_nonzero_source_field():
    values = _module().results()
    R, Z = sp.symbols('R Z')
    r2 = (R - 1)**2 + Z**2
    radial_root = sp.sqrt(1 - r2)
    expected = sp.Tuple(
        -Z * r2 / (R * radial_root * (1 + 4 * r2)),
        (R - 1) * r2 / (R * radial_root * (1 + 4 * r2)),
    )

    assert all(sp.simplify(a - b) == 0 for a, b in zip(values['Bsol2'], expected))
    assert any(component != 0 for component in values['Bsol2'])

    aphi = values['Aphsol2']
    assert sp.simplify(sp.diff(aphi, Z) + R * values['Bsol2'][0]) == 0
    assert sp.simplify(sp.diff(aphi, R) - R * values['Bsol2'][1]) == 0


def test_velocity_split_preserves_the_source_energy_identity_and_precision():
    values = _module().results()

    assert values['w'] == sp.Rational(1, 10000)
    assert values['mu'].is_Float
    assert values['R0'].is_Float
    assert values['Z0'].is_Float
    assert sp.simplify(
        values['vpar']**2 + values['vperp']**2
        - 2 * values['w'] / values['m']
    ) == 0

    B = values['B']
    assert sp.simplify(
        B**2 - (values['Bvec'][0]**2 + values['Bvec'][1]**2
                + values['Bphi']**2 / sp.Symbol('R')**2)
    ) == 0


def test_pphi_freezes_the_source_point_and_h0_is_machine_zero():
    values = _module().results()
    R, Z = sp.symbols('R Z')
    point = {R: values['R0'], Z: values['Z0']}
    B0 = values['B'].subs(point)
    vpar0 = values['vpar'].subs(point)
    aphi0 = values['Aphsol2'].subs(point)
    expected_pphi = (
        values['m'] * vpar0 * values['Bphi'] / B0
        + values['e'] / values['c'] * aphi0
    )

    assert abs(float(sp.N(values['pphi'] - expected_pphi, 16))) < 1e-15
    assert abs(float(values['H0'])) < 1e-15


def test_bstar_matches_an_independent_finite_difference_of_hamiltonian():
    values = _module().results()
    R, Z = sp.symbols('R Z')
    hamiltonian = sp.lambdify((R, Z), values['H'], 'math')
    bstar = [sp.lambdify((R, Z), component, 'math') for component in values['Bstar']]
    radius, height, step = 1.2, 0.1, 1e-5

    d_h_dz = (hamiltonian(radius, height + step)
              - hamiltonian(radius, height - step)) / (2 * step)
    d_h_dr = (hamiltonian(radius + step, height)
              - hamiltonian(radius - step, height)) / (2 * step)
    assert abs(float(bstar[0](radius, height)) + d_h_dz / radius) < 1e-8
    assert abs(float(bstar[1](radius, height)) - d_h_dr / radius) < 1e-8
