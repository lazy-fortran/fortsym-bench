"""Independent behavioral checks for the phase-transform companion."""

import importlib.util
from pathlib import Path

import sympy as sp


def _load():
    path = Path(__file__).parents[1] / "corpus/proj-gvec-stability/phase_transform.py"
    spec = importlib.util.spec_from_file_location("phase_transform", path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def test_phase_transform_repairs_preserve_source_values():
    values = _load().results()

    assert values["coefficientMap"] == (
        (sp.Rational(1, 2), -sp.Rational(1, 2), 0, 0),
        (sp.Rational(1, 2), sp.Rational(1, 2), 0, 0),
        (0, 0, sp.Rational(1, 2), sp.Rational(1, 2)),
        (0, 0, sp.Rational(1, 2), -sp.Rational(1, 2)),
    )
    assert values["inducedPhysicalMass"] == (
        (sp.Rational(1, 2), 0, 0),
        (0, 1, 0),
        (0, 0, 1),
    )
    assert values["minusSidebands"] == ((3, -3), (3, 7))
    assert values["plusSidebands"] == ((3, 7), (3, -3))

    lam = sp.Symbol("lambda")
    kxx, kxy, kyy, mxx, mxy, myy = sp.symbols(
        "kxx kxy kyy mxx mxy myy"
    )
    expected = kxx - lam * mxx - (kxy - lam * mxy) ** 2 / (kyy - lam * myy)
    assert sp.simplify(values["shiftedSchur"] - expected) == 0
    assert values["fixtureFullSpectrum"] == (-1, 5)
