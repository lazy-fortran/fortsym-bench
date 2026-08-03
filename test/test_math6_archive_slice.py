"""Independent source-level behavior checks for the archive math6 slice."""

import importlib.util
from pathlib import Path

import sympy as sp


ROOT = Path(__file__).parents[1]


def _load(relative, name):
    spec = importlib.util.spec_from_file_location(name, ROOT / relative)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_one_year_companions_keep_frame_ticks_and_final_plot_region():
    for relative in ('corpus/archive-old/math6-1y.py', 'corpus/archive-tu/math6-1y.py'):
        value = _load(relative, relative.replace('/', '_')).results()
        assert value['bp1'].args[2] == sp.Function('Rule')(sp.Symbol('Frame'), True)
        assert 'μ' in str(value['bp2'])
        assert value['pr'].args[-1] == sp.Function('Rule')(sp.Symbol('ImageSize'), 300)


def test_two_year_companions_keep_nonrendered_bindings_and_plot_heads():
    old = _load('corpus/archive-old/math6-2y.py', 'math6_2y_slice').results()
    deleted = _load('corpus/archive-old/math6-2y_deleted_4d8899d2-ea9971-3c018e87.py', 'math6_2y_deleted_slice').results()
    assert old['pa'].func.__name__ == 'ParametricPlot3D'
    assert old['cp'].args[-1] == sp.Function('Rule')(sp.Symbol('PlotPoints'), 100)
    assert old['tm'].args[0].func.__name__ == 'Text'
    assert deleted['sm'] == sp.Function('Rule')(sp.Symbol('μ'), sp.Rational(1, 4))
    assert deleted['pa'] == old['pa']
