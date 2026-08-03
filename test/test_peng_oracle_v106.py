"""Independent behavioral regression for the explicit vector curl."""

import importlib.util
from pathlib import Path

import sympy as sp


def _module():
    path = Path(__file__).parents[1] / 'corpus/nc-plasma-DOCUMENTS/peng.py'
    spec = importlib.util.spec_from_file_location('peng_v106', path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_simple_vector_potential_has_unit_z_curl():
    values = _module().results()
    x, y, z = sp.symbols('x y z')
    potential = sp.Matrix((-y / 2, x / 2, 0))
    coordinates = (x, y, z)
    curl = sp.Matrix(
        tuple(
            sp.diff(potential[(index + 2) % 3], coordinates[(index + 1) % 3])
            - sp.diff(potential[(index + 1) % 3], coordinates[(index + 2) % 3])
            for index in range(3)
        )
    )

    assert values['Bsimple'] == sp.Tuple(*curl)
    assert tuple(curl) == (0, 0, 1)
