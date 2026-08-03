"""Independent behavioral regression for the v99 math11y plot binding."""

import importlib.util
import hashlib
from pathlib import Path

import sympy as sp


def _module():
    path = Path(__file__).parents[1] / 'corpus/archive-tu/math11y.py'
    spec = importlib.util.spec_from_file_location('math11y_v99', path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def test_pleb1_preserves_the_native_parametric_plot_contract():
    """Check the source's plot head, path variable, range, and plot options."""
    value = _module().results()['pleb1']

    assert value.func.__name__ == 'ParametricPlot3D'
    assert value.args[0] == sp.Function('Evaluate')(sp.Symbol('rs'))
    assert value.args[1] == sp.Tuple(sp.Symbol('t'), 0, 20)

    options = {
        option.args[0]: option.args[1]
        for option in value.args[2:]
        if option.func.__name__ == 'Rule'
    }
    assert options[sp.Symbol('Boxed')] is sp.false
    assert options[sp.Symbol('AxesLabel')].args == tuple(
        sp.Symbol('fortsymString' + hashlib.sha256(
            f'"{label}"'.encode('utf-8')
        ).hexdigest())
        for label in ('x', 'y', 'z')
    )
    assert options[sp.Symbol('BoxRatios')] == sp.Tuple(1, 1, 1)
    assert options[sp.Symbol('ViewPoint')] == sp.Tuple(
        sp.Float('-1.01'), sp.Float('-2.4'), sp.Float('2.0')
    )
