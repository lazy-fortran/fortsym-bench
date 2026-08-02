"""Independent checks for the NAE-to-DESC cylindrical geometry companion."""

import importlib.util
from pathlib import Path

import sympy as sp


def _load_companion():
    path = Path(__file__).parents[1] / "corpus/code-DESC/NAE_to_DESC_geometry_2nd_order.py"
    spec = importlib.util.spec_from_file_location("nae_desc_geometry", path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_cylindrical_frame_and_jacobian_are_independent_geometry_identities():
    module = _load_companion()
    values = module.results()
    # The benchmark protocol canonicalises Wolfram's phi glyph to ``phi``.
    phi = sp.Symbol("phi")
    radial = sp.Matrix([sp.cos(phi), sp.sin(phi), 0])
    toroidal = sp.Matrix([-sp.sin(phi), sp.cos(phi), 0])
    vertical = sp.Matrix([0, 0, 1])

    assert sp.Matrix(values["radial"]) == radial
    assert sp.Matrix(values["toroidal"]) == toroidal
    assert sp.Matrix(values["vertical"]) == vertical
    assert radial.dot(toroidal) == 0
    assert radial.cross(toroidal).applyfunc(sp.trigsimp) == vertical

    radius, height = sp.symbols("radius height")
    cylindrical_position = sp.Matrix(
        [radius * sp.cos(phi), radius * sp.sin(phi), height]
    )
    assert sp.simplify(
        cylindrical_position.jacobian([radius, phi, height]).det() - radius
    ) == 0
