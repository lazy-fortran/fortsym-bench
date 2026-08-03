"""Independent source-order check for the sympl3 parallel field."""

import importlib.util
from pathlib import Path
import sys

import sympy as sp


def _load_companion():
    root = Path(__file__).parents[1]
    sys.path.insert(0, str(root))
    path = root / "corpus/gh-itpplasma-paper_sympl/sympl3_.py"
    spec = importlib.util.spec_from_file_location("sympl3_bstarpar", path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_bstarpar_keeps_source_ordered_unit_denominator():
    values = _load_companion().results()
    r, th, R0 = sp.symbols("r th R0")
    h0ph, h0th, vp = sp.symbols("h0ph h0th vp")
    c = sp.cos(th)

    # The notebook evaluates the h0th*vp part after R0=1, while retaining
    # R0 in the surrounding metric factor.  This is independently rebuilt
    # from the source assignment order and catches the lost denominator.
    expected = (
        R0 * h0ph * (1 + r * c / R0)
        * (
            h0ph * (r - c * r**2) / r / (r * c + 1)
            + h0th * vp / r / (r * c + 1)
        )
        + h0th * r
        * (
            -h0ph * vp * c / r / (r * c + 1)
            + h0th / r / (r * c + 1)
        )
    )
    assert sp.simplify(values["Bstarpar"] - expected) == 0

