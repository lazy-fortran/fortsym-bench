"""Independent behavioral check for the v103 kernel-weighting recovery."""

import importlib.util
from pathlib import Path

import sympy as sp


def _load():
    path = (
        Path(__file__).parents[1]
        / 'corpus/proj-gvec-stability/two_component_energy_identity.py'
    )
    spec = importlib.util.spec_from_file_location(
        'two_component_energy_identity_v103', path
    )
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def _evaluate_opaque_abs(expression):
    """Evaluate only the source wrapper's opaque Abs head."""
    return expression.replace(
        lambda node: getattr(node.func, '__name__', '') == 'Abs',
        lambda node: sp.Abs(node.args[0]),
    )


def test_kernel_weighted_applies_the_source_volume_and_mu0_factors():
    values = _load().results()
    radius, length, mu0 = sp.symbols('r len mu0')
    averaged = sp.Symbol('kernelAveraged')

    observed = values['kernelWeighted']
    assert observed.has(averaged)
    assert getattr(observed, 'func', None) is sp.Mul

    # Independent numerical evaluations of
    #   2 kernelAveraged Abs[2 Pi len r] / mu0
    # check both the volume factor and the source's explicit factor of two.
    for point in (
        {radius: sp.Rational(3, 2), length: 4, mu0: 5, averaged: 7},
        {radius: 5, length: sp.Rational(7, 3), mu0: 2, averaged: -11},
    ):
        actual = _evaluate_opaque_abs(observed.subs(point))
        expected = (
            2 * point[averaged]
            * sp.Abs(2 * sp.pi * point[length] * point[radius])
            / point[mu0]
        )
        assert sp.simplify(actual - expected) == 0
