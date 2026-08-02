from __future__ import annotations

import importlib.util
from pathlib import Path

import sympy as sp


def test_helical_core_expansion_has_no_dynamic_radius_subs():
    path = Path(__file__).parents[1] / "corpus/proj-flux_pumping/08_helical_core_program.py"
    spec = importlib.util.spec_from_file_location("helical_core", path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    values = module.results()

    assert not values["jphOld"].has(sp.Subs)
    assert isinstance(values["fp"], sp.Tuple)
    assert len(values["fp"]) == 2
    rules = {item.args[0]: item.args[1] for item in values["fp"]}
    q0, D2, gam1, gam2, kap, qsrc = sp.symbols(
        "q0 D2 gam1 gam2 kap qsrc"
    )
    assert sp.simplify(
        (qsrc - rules[q0]) + kap * rules[D2]
    ) == 0
    assert sp.simplify(
        gam1 * (1 - rules[q0]) - gam2 * rules[D2]
    ) == 0
