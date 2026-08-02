"""Independent checks for the recovered math11y equation cells."""

import importlib.util
from pathlib import Path

import sympy as sp


def _module():
    path = Path(__file__).parents[1] / 'corpus/archive-tu/math11y.py'
    spec = importlib.util.spec_from_file_location('math11y', path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def test_lorentz_force_expansion_is_independent_of_the_source_lists():
    values = _module().results()
    t = sp.symbols('t')
    x, y, z = (sp.Function(name) for name in ('x', 'y', 'z'))
    m, q, B0, E0 = sp.symbols('m q B0 E0')
    velocity = sp.Matrix([sp.diff(x(t), t), sp.diff(y(t), t), sp.diff(z(t), t)])
    acceleration = sp.Matrix([
        sp.diff(x(t), t, 2), sp.diff(y(t), t, 2), sp.diff(z(t), t, 2)
    ])
    expected = tuple(
        sp.Eq(component, rhs)
        for component, rhs in zip(
            q * (sp.Matrix([0, E0, 0]) + velocity.cross(sp.Matrix([0, 0, B0]))),
            m * acceleration,
        )
    )
    assert all(
        sp.simplify(got.lhs - want.lhs) == 0
        and sp.simplify(got.rhs - want.rhs) == 0
        for got, want in zip(values['eq'], expected)
    )


def test_drag_system_expansion_uses_the_speed_norm():
    values = _module().results()
    t = sp.symbols('t')
    x, y = (sp.Function(name) for name in ('x', 'y'))
    speed = sp.sqrt(sp.diff(x(t), t)**2 + sp.diff(y(t), t)**2)
    expected = (
        sp.Eq(sp.diff(x(t), t, 2), -sp.Float('0.3')*sp.diff(x(t), t)*speed),
        sp.Eq(sp.diff(y(t), t, 2), -sp.Float('0.3')*sp.diff(y(t), t)*speed - 10),
    )
    assert all(
        sp.simplify(got.lhs - want.lhs) == 0
        and sp.simplify(got.rhs - want.rhs) == 0
        for got, want in zip(values['sysa'], expected)
    )


def test_final_deq_is_the_cylindrical_laplace_equation():
    values = _module().results()
    r, phi = sp.symbols('r phi')
    u = sp.Function('u')
    expected = sp.Eq(
        sp.diff(u(r, phi), r, 2)
        + sp.diff(u(r, phi), r) / r
        + sp.diff(u(r, phi), phi, 2) / r**2,
        0,
    )
    assert sp.simplify(values['deq'].lhs - expected.lhs) == 0
    assert values['deq'].rhs == 0
