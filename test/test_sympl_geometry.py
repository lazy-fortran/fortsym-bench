from __future__ import annotations

import importlib.util
from pathlib import Path

import sympy as sp


def test_sympl_geometry_fields_match_independent_cylindrical_formulae():
    path = Path(__file__).parents[1] / "corpus/gh-itpplasma-paper_sympl/sympl_.py"
    spec = importlib.util.spec_from_file_location("sympl_geometry", path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    values = module.results()

    r, R0, th, B0th, B0ph = sp.symbols("r R0 th B0th B0ph")
    R = R0 + r * sp.cos(th)
    bth = B0th * R0 / (r * R)
    bph = B0ph * (R0 - r * sp.cos(th)) / (R0 * R)
    expected = {
        "Bthctr": bth,
        "Bphctr": bph,
        "Bthcov": r**2 * bth,
        "Bphcov": R**2 * bph,
    }
    for name, expression in expected.items():
        assert sp.simplify(values[name] - expression) == 0

    expected_mod = sp.sqrt(
        sp.simplify(expected["Bthctr"] * expected["Bthcov"]
                    + expected["Bphctr"] * expected["Bphcov"])
    )
    assert sp.simplify(values["Bmod"] - expected_mod) == 0
