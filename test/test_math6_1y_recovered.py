"""Independent checks for the bounded math6-1y list-plot recovery."""

import importlib.util
from pathlib import Path

import sympy as sp


def _module():
    path = Path(__file__).parents[1] / 'corpus/archive-old/math6-1y.py'
    spec = importlib.util.spec_from_file_location('math6_1y', path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_joined_list_plots_preserve_source_data_and_option():
    values = _module().results()
    rule = sp.Function('Rule')
    joined = rule(sp.Symbol('PlotJoined'), True)

    expected_ps1 = sp.Function('ListPlot')(
        sp.Tuple(
            sp.Tuple(1, 1),
            sp.Tuple(-2, sp.Float('1.5')),
            sp.Tuple(sp.Float('-1.5'), -1),
            sp.Tuple(sp.Float('0.8'), sp.Float('0.5')),
        ),
        joined,
    )
    expected_ps2 = sp.Function('ListPlot')(
        sp.Tuple(2, 3, 1, 4, sp.Float('2.5'), sp.Float('1.5')),
        joined,
    )

    assert values['ps1'] == expected_ps1
    assert values['ps2'] == expected_ps2
