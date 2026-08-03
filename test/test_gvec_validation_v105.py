"""Independent source-level oracle for the v105 gvec validation data."""

from __future__ import annotations

import importlib.util
from pathlib import Path

import sympy as sp


def _load():
    path = (
        Path(__file__).parents[1]
        / 'corpus/proj-gvec-stability/generate_validation_figures.py'
    )
    spec = importlib.util.spec_from_file_location('gvec_validation_v105', path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_spectrum_data_preserves_the_three_source_branches():
    values = _load().results()

    # Independently mirror the source assignment's three Transpose branches:
    # the normal branch is 1-D, followed by constant shear and compression
    # branches.  Subdivide remains opaque in the bounded native protocol.
    grid = sp.Function('Subdivide')(0, 2, 200)
    transpose = sp.Function('Transpose')
    expected = (
        transpose((grid, sp.Add(1, -grid, evaluate=False))),
        transpose((grid, (1, 1, 1))),
        transpose((
            grid,
            tuple(sp.Float('2.0943951023931957') for _ in range(3)),
        )),
    )

    assert values['spectrumData'] == expected
    assert len(values['spectrumData']) == 3
    assert values['spectrumData'][0].args[0][0] == grid
    assert values['spectrumData'][1].args[0][1] == (1, 1, 1)
    assert all(
        value == sp.Float('2.0943951023931957')
        for value in values['spectrumData'][2].args[0][1]
    )
