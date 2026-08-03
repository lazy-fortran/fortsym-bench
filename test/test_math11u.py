"""Independent checks for the recovered math11u equation and solve bindings."""

import importlib.util
from pathlib import Path

import sympy as sp


def _module():
    path = Path(__file__).parents[1] / 'corpus/archive-tu/math11u.py'
    spec = importlib.util.spec_from_file_location('math11u', path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_eq_preserves_the_source_piecewise_residual_equation():
    value = _module().results()['eq']
    x = sp.Function('x')
    expected_force = sp.Piecewise((-x(sp.Symbol('t')), sp.Function('Abs')(x(sp.Symbol('t'))) < 1),
                                  (0, True))
    expected = sp.Eq(
        sp.Function('Derivative1')(sp.Symbol('x'), 2, sp.Symbol('t')),
        expected_force,
    )
    assert value == expected


def test_sol_preserves_both_ndsolve_requests_without_fabricating_trajectories():
    values = _module().results()
    assert len(values['sol']) == 2
    for solution, velocity in zip(values['sol'], (1, sp.Float('1.1'))):
        assert solution.func == sp.Function('NDSolve')
        equations, dependent, interval = solution.args
        assert equations[0] == values['eq']
        assert equations[1] == sp.Eq(sp.Function('x')(0), 0)
        assert equations[2] == sp.Eq(
            sp.Function('Derivative1')(sp.Symbol('x'), 1, 0), velocity
        )
        assert dependent == sp.Symbol('x')
        assert interval == sp.Tuple(sp.Symbol('t'), 0, 3)
