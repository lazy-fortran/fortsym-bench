"""Independent check for the v98 archive-tu math6-1y Plot binding."""

import importlib.util
from pathlib import Path

import sympy as sp


def _module():
    path = Path(__file__).parents[1] / 'corpus/archive-tu/math6-1y.py'
    spec = importlib.util.spec_from_file_location('archive_tu_math6_1y_v98', path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_s_keeps_plot_iterator_local_to_the_source_expression():
    actual = _module().results()['s']

    # Derive the expected tree directly from ``s = Plot[Sin[t], {t, 0, 2*Pi}]``.
    # Plot's iterator is local, so the earlier assignment to the global t does
    # not replace either occurrence here.
    t = sp.Symbol('t')
    expected = sp.Function('Plot')(
        sp.sin(t),
        sp.Tuple(t, 0, 2 * sp.pi),
    )

    assert actual == expected
