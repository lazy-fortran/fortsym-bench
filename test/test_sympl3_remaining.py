"""Independent regression for the v96 sympl3 declared difference."""

import importlib.util
from pathlib import Path
import sys

import sympy as sp


def _load_companion():
    root = Path(__file__).parents[1]
    sys.path.insert(0, str(root))
    path = root / "corpus/gh-itpplasma-paper_sympl/sympl3_.py"
    spec = importlib.util.spec_from_file_location("sympl3_remaining", path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_bphcov_preserves_source_assignment_order():
    values = _load_companion().results()
    r, th, R0, h0ph = sp.symbols("r th R0 h0ph")
    c = sp.cos(th)

    # gphph captured symbolic R0 before the notebook set R0=1, whereas
    # Bphctr used the already-normalized sqrtg and B0.  This is the source
    # behavior represented by the native reference result.
    expected = (
        R0**2
        * h0ph
        / r
        * (1 + r * c / R0) ** 2
        / (1 + r * c)
        * (r - r**2 * c)
    )
    assert sp.simplify(values["Bphcov"] - expected) == 0
