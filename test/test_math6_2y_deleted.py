import importlib.util
from pathlib import Path

import sympy as sp


def _module():
    path = Path(__file__).parents[1] / (
        'corpus/archive-old/math6-2y_deleted_4d8899d2-ea9971-3c018e87.py'
    )
    spec = importlib.util.spec_from_file_location('math6_2y_deleted', path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_final_p1_preserves_source_parametric_plot():
    value = _module().results()['p1']
    u = sp.Symbol('u')
    expected = sp.Function('ParametricPlot3D')(
        sp.Tuple(sp.sin(8 * u) * sp.sin(u), sp.cos(8 * u) * sp.sin(u), sp.cos(u)),
        sp.Tuple(u, 0, 2 * sp.pi),
        sp.Function('Rule')(sp.Symbol('PlotPoints'), 200),
    )
    assert value == expected
