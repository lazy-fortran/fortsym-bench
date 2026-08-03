"""Independent checks for the gvec validation companions."""

from __future__ import annotations

import importlib.util
import hashlib
import math
from pathlib import Path

import sympy as sp


def _load(name: str):
    path = Path(__file__).parents[1] / 'corpus/proj-gvec-stability' / f'{name}.py'
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_export_volume_and_field_groups_follow_independent_geometry_oracle():
    values = _load('gvec_export_consistency').results()

    # For R = 4 + cos(theta) + (2/5) cos(theta - 2 phi) and
    # Z = sin(theta) - (2/5) sin(theta - 2 phi), Fourier orthogonality gives
    # the oriented surface integral 168*pi**2/25 independently of the
    # translated expression.
    assert values['analyticVolume'] == sp.Rational(168, 25) * sp.pi**2

    expected_groups = (
        ('geometry and |B|', ('mod_B', 'xhat', 'yhat', 'zhat')),
        ('metric and Jacobian', ('Jac', 'g_tt', 'g_tz', 'g_zz')),
        ('second fundamental form', ('II_tt', 'II_tz', 'II_zz')),
        ('contravariant B', ('B_contra_t', 'B_contra_z')),
    )
    observed_groups = values['groups']
    assert len(observed_groups) == len(expected_groups)
    for observed_group, expected_group in zip(observed_groups, expected_groups):
        observed_name, observed_fields = observed_group
        expected_name, expected_fields = expected_group
        assert str(observed_name).startswith('fortsymString')
        assert str(observed_name) == 'fortsymString' + hashlib.sha256(
            f'"{expected_name}"'.encode()
        ).hexdigest()
        assert len(observed_fields) == len(expected_fields)
        for observed_field, expected_field in zip(observed_fields, expected_fields):
            assert str(observed_field) == 'fortsymString' + hashlib.sha256(
                f'"{expected_field}"'.encode()
            ).hexdigest()


def test_validation_step_sizes_and_derivative_matrix_are_source_values():
    values = _load('generate_validation_figures').results()

    expected_steps = tuple(10.0 ** (-8 + index / 4) for index in range(29))
    assert len(values['stepSizes']) == len(expected_steps)
    for observed, expected in zip(values['stepSizes'], expected_steps):
        assert math.isclose(float(observed), expected, rel_tol=1e-14)

    # Independently evaluate the source's bounded derivative matrix at a
    # sample eigenvector symbol and eigenvalue.  The source has
    # dK/dp = diag(1,-1) and dM/dp = diag(1/10,0), so its matrix contraction
    # must retain these two diagonal factors under the mass normalization
    # denominator.
    e = sp.Symbol('eigenvector0')
    lam = sp.Symbol('lambda0')
    matrix = values['analyticDerivative']
    assert matrix.func == sp.Function('List')
    first, second = matrix.args
    assert first.func == sp.Function('List')
    assert second.func == sp.Function('List')
    sample = {e: sp.Integer(2), lam: sp.Rational(2, 5)}
    observed = (
        (first.args[0].subs(sample), first.args[1].subs(sample)),
        (second.args[0].subs(sample), second.args[1].subs(sample)),
    )
    mass = sp.Function('List')(
        sp.Function('List')(
            sp.Float('2.033333333333332993', 16) * 4,
            sp.Integer(0),
        ),
        sp.Function('List')(sp.Integer(0), sp.Float('3.0') * 4),
    )
    expected = (
        (sp.Mul(sp.Rational(96, 25), sp.Pow(mass, -1), evaluate=False), 0),
        (0, sp.Mul(-4, sp.Pow(mass, -1), evaluate=False)),
    )
    assert observed[0][0] == expected[0][0]
    assert observed[0][1] == expected[0][1]
    assert observed[1][0] == expected[1][0]
    assert observed[1][1] == expected[1][1]
