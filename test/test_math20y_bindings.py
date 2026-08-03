"""Independent behavioral checks for the recovered math20y bindings."""

import hashlib
import importlib.util
import sys
from pathlib import Path

import sympy as sp


ROOT = Path(__file__).parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))


def _module():
    path = ROOT / "corpus/archive-tu/math20y.py"
    spec = importlib.util.spec_from_file_location("math20y_bindings", path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def _string_atom(value):
    digest = hashlib.sha256(f'"{value}"'.encode()).hexdigest()
    return sp.Symbol("fortsymString" + digest)


def test_eq_preserves_the_source_equation_and_decimal_coefficients():
    values = _module().results()
    a, bx, d, x, y, z = sp.symbols("a bx d x y z")
    expected = sp.Eq(
        a + bx + sp.Float("0.15") * x**2
        + sp.Float("3.33") * d * y + sp.pi * z**3,
        0,
        evaluate=False,
    )
    assert values["eq"] == expected


def test_string_bindings_keep_wolfram_character_and_list_semantics():
    values = _module().results()
    assert values["sv"] == sp.Tuple(*(
        _string_atom(character) for character in "1234567890"
    ))
    assert values["s9"] == values["sv"][8]
    assert values["lx"] == sp.Tuple(*(
        _string_atom(value) for value in ("x1", "x2", "x3")
    ))


def test_lp_uses_the_preceding_numeric_output_for_percent():
    values = _module().results()
    expected_text = str(sp.N(sp.pi, 17))
    assert expected_text == "3.1415926535897932"
    assert values["lp"] == sp.Tuple(*(
        _string_atom(character) for character in expected_text
    ))


def test_g_is_the_source_integral_not_an_intermediate_replacement_tree():
    values = _module().results()
    x = sp.Symbol("x")
    integrand = ((1 - x)**2 * (x**2 + 1)**2)**-1
    assert sp.simplify(sp.diff(values["g"], x) - integrand) == 0
