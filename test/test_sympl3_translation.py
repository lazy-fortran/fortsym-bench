from __future__ import annotations

import importlib.util
from pathlib import Path
import sys

import sympy as sp


def test_sympl3_euler_lagrange_keeps_vp_time_derivative():
    path = Path("corpus/gh-itpplasma-paper_sympl/sympl3_.py")
    sys.path.insert(0, str(path.parent.parent.parent))
    spec = importlib.util.spec_from_file_location("sympl3_companion", path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)

    equation = module.results()["eq1"]
    th = sp.Function("th")
    vp = sp.Function("vp")
    expected = sp.Eq(
        sp.Rational(3, 10) * sp.diff(vp(sp.Symbol("t")), sp.Symbol("t"))
        + sp.Rational(3, 100) * sp.sin(th(sp.Symbol("t"))),
        0,
    )
    assert sp.simplify(equation.lhs - expected.lhs) == 0
    assert equation.rhs == expected.rhs
