import importlib.util

import sympy as sp


def _module():
    path = 'corpus/archive-old/math3y.py'
    spec = importlib.util.spec_from_file_location('math3y_generated', path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def test_math3y_p3_is_the_late_source_binding():
    x = sp.Symbol('x')
    p3 = _module().results()['p3']

    assert sp.expand(p3 - (x**3 + x + 1)) == 0
    assert p3.subs(x, 0) == 1
    assert p3.subs(x, -1) == -1


def test_math3y_p5_is_not_replaced_by_numeric_last_output():
    x = sp.Symbol('x')

    assert _module().results()['p5'] == x**5 - x + 1


def test_math3y_threaded_acceleration_equations_are_source_bindings():
    t = sp.Symbol('t')
    derivative2 = sp.Function('Derivative2')
    expected = sp.Tuple(
        sp.Eq(derivative2(sp.Symbol('x'), 1, 1, t), 0),
        sp.Eq(derivative2(sp.Symbol('y'), 1, 1, t), -10),
    )

    assert _module().results()['sys'] == expected


def test_math3y_initial_conditions_use_cleared_coordinate_symbols():
    derivative1 = sp.Function('Derivative1')
    expected = sp.Tuple(
        sp.Eq(sp.Function('x')(0), 0),
        sp.Eq(sp.Function('y')(0), 0),
        sp.Eq(derivative1(sp.Symbol('x'), 1, 0), 2),
        sp.Eq(derivative1(sp.Symbol('y'), 1, 0), 10),
    )

    assert _module().results()['anf'] == expected
