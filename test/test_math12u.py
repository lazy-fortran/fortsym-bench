"""Independent behavioral check for the recovered final plot binding."""

import hashlib
import importlib.util
from pathlib import Path

import sympy as sp


def _module():
    path = Path(__file__).parents[1] / 'corpus/archive-tu/math12u.py'
    spec = importlib.util.spec_from_file_location('math12u', path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_final_p2_preserves_source_plot_and_markers():
    values = _module().results()
    rule = sp.Function('Rule')
    def string(value):
        return sp.Symbol(
            'fortsymString' + hashlib.sha256(
                f'"{value}"'.encode('utf-8')
            ).hexdigest()
        )
    expected = sp.Function('ListPointPlot3D')(
        sp.Tuple(
            sp.Tuple(1.0, 1.0, 0.126),
            sp.Tuple(1.0, 2.0, 0.076),
            sp.Tuple(2.0, 1.0, 0.219),
            sp.Tuple(2.0, 2.0, 0.126),
            sp.Tuple(0.1, 0.0, 0.186),
        ),
        rule(
            sp.Symbol('PlotStyle'),
            sp.Tuple(
                rule(sp.Symbol('PointSize'), sp.Symbol('Large')),
                rule(
                    sp.Symbol('PlotMarkers'),
                    sp.Tuple(*(string(value) for value in ('1', '2', '3', '4', '5'))),
                ),
            ),
        ),
    )
    assert values['p2'] == expected
