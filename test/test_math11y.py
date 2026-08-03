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


def test_literal_plot_options_preserve_their_wolfram_rules():
    values = _module().results()
    rule = sp.Function('Rule')
    dashing = sp.Function('Dashing')
    assert values['dino'] == rule(
        sp.Symbol('DisplayFunction'), sp.Symbol('Identity')
    )
    assert values['dd'] == rule(
        sp.Symbol('PlotStyle'), dashing(sp.Tuple(sp.Float('0.01')))
    )
    assert values['dt'] == rule(
        sp.Symbol('PlotStyle'),
        dashing(
            sp.Tuple(
                sp.Float('0.02'),
                sp.Float('0.01'),
                sp.Float('0.0025'),
                sp.Float('0.01'),
            )
        ),
    )


def test_direct_intermediates_preserve_native_source_aliases():
    values = _module().results()
    assert values['pp'] == sp.Symbol('so')
    assert values['rf1'] == sp.Symbol('rs')
    assert values['rf2'] == sp.Symbol('rs')


def test_transformed_ode_is_the_numeric_product_rule_expansion():
    values = _module().results()
    x = sp.Symbol('x')
    m = sp.Symbol('m')
    w = sp.Function('w')
    z = sp.Function('z')
    part = sp.Function('Part')
    derivative = sp.Function('D')
    product = w(x) * z(x)
    expected_source_form = sp.Add(*(
        part(sp.Symbol('cold'), index)
        * derivative(product, sp.Tuple(x, order))
        for index, order in ((1, 0), (2, 1), (3, 2))
    ))
    assert values['neweq'] == expected_source_form

    source_form = (
        sp.diff(z(x) * w(x), x, 2)
        + sp.diff(z(x) * w(x), x) / x
        + z(x) * w(x) * (1 - m**2 / x**2)
    )
    numeric = {x: sp.Integer(2), m: sp.Integer(3)}
    numeric.update({
        z(x): sp.Integer(5),
        w(x): sp.Integer(7),
        sp.diff(z(x), x): sp.Integer(11),
        sp.diff(w(x), x): sp.Integer(13),
        sp.diff(z(x), x, 2): sp.Integer(17),
        sp.diff(w(x), x, 2): sp.Integer(19),
    })
    assert sp.simplify(source_form.subs(numeric)) == sp.Rational(2109, 4)


def test_transformed_ode_sum_preserves_each_source_coefficient_binding():
    values = _module().results()
    x = sp.Symbol('x')
    z = sp.Function('z')
    part = sp.Function('Part')
    derivative = sp.Function('D')
    expected = sp.Add(*(
        derivative(z(x), sp.Tuple(x, order))
        * part(sp.Symbol('cnew'), index)
        for index, order in ((1, 0), (2, 1), (3, 2))
    ))
    assert values['fneweq'] == expected
