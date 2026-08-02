"""Independent checks for the source-faithful sympl3 field forms."""

import importlib.util
from pathlib import Path
import sys

import sympy as sp


def _load_companion():
    root = Path(__file__).parents[1]
    sys.path.insert(0, str(root))
    path = root / "corpus/gh-itpplasma-paper_sympl/sympl3_.py"
    spec = importlib.util.spec_from_file_location("sympl3_parity_companion", path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def test_sympl3_repaired_fields_follow_cylindrical_source_formulae():
    values = _load_companion().results()
    r, th, R0 = sp.symbols("r th R0")
    B0, h0ph, h0th, vp = sp.symbols("B0 h0ph h0th vp")
    c, s = sp.cos(th), sp.sin(th)

    # These are derived independently from the source potentials and guiding
    # vector, rather than copied from the generated companion's expressions.
    assert sp.simplify(
        values["Bthctr"] - B0 * h0th / r / (r * c / R0 + 1)
    ) == 0
    assert sp.simplify(
        values["Bstarr"] + h0ph * vp * s / R0 / (r * c / R0 + 1)
    ) == 0
    assert sp.simplify(
        values["Bstarph"]
        - (
            h0ph * (r - c * r**2) / r / (r * c + 1)
            + h0th * vp / R0 / r / (r * c / R0 + 1)
        )
    ) == 0
