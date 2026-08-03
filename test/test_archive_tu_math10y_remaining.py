"""Independent behavioral check for one remaining math10y binding."""

import importlib.util
from pathlib import Path

import sympy as sp


def _module():
    path = Path(__file__).parents[1] / 'corpus/archive-tu/math10y.py'
    spec = importlib.util.spec_from_file_location('archive_tu_math10y_remaining', path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_fi_preserves_the_source_fourier_cosine_transform_composition():
    values = _module().results()

    a, t = sp.symbols('a t')
    omega = sp.Symbol('ω')
    unit = sp.Function('UnitStep')
    expected = sp.Function('InverseFourierCosTransform')(
        sp.Function('FourierCosTransform')(
            unit(a + t) + unit(a - t) - 1,
            t,
            omega,
        ),
        omega,
        t,
    )

    assert values['fi'] == expected
    assert values['fi'].args[0].func == sp.Function('FourierCosTransform')
    assert values['fi'].args[0].args[0] == unit(a + t) + unit(a - t) - 1
