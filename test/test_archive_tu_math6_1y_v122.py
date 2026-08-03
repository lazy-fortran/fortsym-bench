"""Independent source-derived regression for the v122 ``k1`` recovery."""

import hashlib
import importlib.util
from pathlib import Path

import sympy as sp


def _module():
    path = Path(__file__).parents[1] / 'corpus/archive-tu/math6-1y.py'
    spec = importlib.util.spec_from_file_location(
        'archive_tu_math6_1y_v122', path
    )
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_k1_is_the_source_final_show_not_the_earlier_local_ellipse():
    value = _module().results()['k1']
    string_atom = lambda literal: sp.Symbol(
        'fortsymString' + hashlib.sha256(f'"{literal}"'.encode()).hexdigest()
    )

    assert value.func.__name__ == 'Show'
    assert value.args[0].func.__name__ == 'ParametricPlot'
    assert value.args[0].args[1] == sp.Tuple(
        sp.Symbol('ϕ'), 0, 2 * sp.pi
    )
    assert value.args[1] == sp.Function('Rule')(
        sp.Symbol('AxesLabel'),
        sp.Tuple(string_atom('x'), string_atom('y')),
    )
    assert value.args[4].args[1].args[0] == string_atom('Ellipse\n')
