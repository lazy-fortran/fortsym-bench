"""Independent checks for deterministic math20y source bindings."""

import hashlib
import importlib.util
from pathlib import Path

import sympy as sp


def _module():
    path = Path(__file__).parents[1] / 'corpus/archive-tu/math20y.py'
    spec = importlib.util.spec_from_file_location('math20y_residuals', path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def _string_atom(value):
    digest = hashlib.sha256(f'"{value}"'.encode()).hexdigest()
    return sp.Symbol('fortsymString' + digest)


def test_equation_binding_preserves_the_source_numeric_coefficient_and_shape():
    values = _module().results()
    a, bx, d, x, y, z = sp.symbols('a bx d x y z')
    expected = sp.Eq(
        a + bx + sp.Float('0.15') * x**2
        + sp.Float('3.33') * d * y + sp.pi * z**3,
        0,
        evaluate=False,
    )
    assert values['eq'] == expected


def test_character_binding_maps_the_source_decimal_string_characterwise():
    values = _module().results()['sv']
    assert values == sp.Tuple(*(_string_atom(character)
                                for character in '1234567890'))
