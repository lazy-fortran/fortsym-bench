"""Independent behavioral regression for the v103 math10y recovery."""

import importlib.util
from pathlib import Path

import sympy as sp


def _module():
    path = Path(__file__).parents[1] / "corpus/archive-tu/math10y.py"
    spec = importlib.util.spec_from_file_location("archive_tu_math10y_v103", path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_fw_is_the_final_inverse_fourier_rebinding_of_fm():
    value = _module().results()["fw"]

    expected = sp.Function("InverseFourierTransform")(
        sp.Symbol("fm"),
        sp.Symbol("ω"),
        sp.Symbol("t"),
    )

    assert value == expected
    assert value.func == sp.Function("InverseFourierTransform")
    assert value.args[0] == sp.Symbol("fm")
    assert {symbol.name for symbol in value.free_symbols} == {"fm", "t", "ω"}
