"""Independent checks for the recovered flux-pumping comparison bindings."""

import importlib.util
from pathlib import Path

import sympy as sp


def _load():
    path = (
        Path(__file__).parents[1]
        / 'corpus/proj-flux_pumping/38_naive_vs_serious_comparison.py'
    )
    spec = importlib.util.spec_from_file_location('flux_pumping_38', path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_corrugated_current_expansion_and_average_are_source_faithful():
    values = _load().results()
    rr, dd, al, phi = sp.symbols('rr dd al phi')
    jm = sp.Function('jm')
    expected = (
        jm(rr) * sp.cos(phi)
        + dd / (2 * rr) * (jm(rr) + rr * sp.diff(jm(rr), rr))
        * (sp.cos(al) + sp.cos(2 * phi + al))
    )

    assert sp.simplify(values['naiveLinear'] - expected) == 0
    assert sp.simplify(values['printedTorcurden'] - expected) == 0
    assert sp.simplify(
        values['meanCurrent']
        - dd * sp.cos(al) / (2 * rr)
        * (jm(rr) + rr * sp.diff(jm(rr), rr))
    ) == 0
