import hashlib
import importlib.util
from pathlib import Path

import sympy as sp


_SOURCE = Path(__file__).parents[1] / "corpus" / "nc-stud-Bacc_FEM" / "torus.py"
_SPEC = importlib.util.spec_from_file_location("torus_translation", _SOURCE)
_MODULE = importlib.util.module_from_spec(_SPEC)
_SPEC.loader.exec_module(_MODULE)


def test_torus_recovers_symbolic_laplacian_intermediates():
    values = _MODULE.results()
    laplacian = sp.Function("Laplacian")
    u = sp.Function("u")
    option = sp.Symbol(
        "fortsymString"
        + hashlib.sha256(b'"Toroidal"').hexdigest()
    )

    assert values["lapu0"] == laplacian(
        u(sp.Symbol("et"), sp.Symbol("th"), sp.Symbol("ph")),
        sp.Tuple(sp.Symbol("et"), sp.Symbol("th"), sp.Symbol("ph")),
        option,
    )
    expected = laplacian(
        u(sp.Symbol("r"), sp.Symbol("th"), sp.Symbol("Z")),
        sp.Tuple(sp.Symbol("r"), sp.Symbol("th"), sp.Symbol("Z")),
        option,
    )
    assert values["lapu"] == expected
    assert values["lapu2"] == expected
