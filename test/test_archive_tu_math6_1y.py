"""Independent behavioral check for the recovered archive-tu ``ps1`` binding."""

import importlib.util
from pathlib import Path

import sympy as sp


def _module():
    path = Path(__file__).parents[1] / 'corpus/archive-tu/math6-1y.py'
    spec = importlib.util.spec_from_file_location('archive_tu_math6_1y', path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_ps1_preserves_list_plot_points_and_joined_option():
    values = _module().results()

    # Derive the expected value directly from the Wolfram statement
    # ``ps1 = ListPlot[l1, PlotJoined -> True]`` rather than reusing the
    # generated assignment table or the implementation's construction.
    points = sp.Tuple(
        sp.Tuple(1, 1),
        sp.Tuple(-2, sp.Float('1.5')),
        sp.Tuple(sp.Float('-1.5'), -1),
        sp.Tuple(sp.Float('0.8'), sp.Float('0.5')),
    )
    expected = sp.Function('ListPlot')(
        points,
        sp.Function('Rule')(sp.Symbol('PlotJoined'), True),
    )

    assert values['ps1'] == expected
