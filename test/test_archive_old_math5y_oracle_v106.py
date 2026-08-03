"""Independent regression for the v106 archive-old math5y recovery."""

import importlib.util
from pathlib import Path

import sympy as sp


def _module():
    path = Path(__file__).parents[1] / 'corpus/archive-old/math5y.py'
    spec = importlib.util.spec_from_file_location(
        'archive_old_math5y_oracle_v106', path
    )
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_polynomial_solve_returns_all_algebraic_roots():
    values = _module().results()
    roots = [rule.args[1] for group in values['sp'] for rule in group]

    assert len(roots) == 4
    assert all(root.free_symbols == set() for root in roots)
    assert all(
        abs(complex(sp.N(root**4 + root - 1, 30))) < 1e-12
        for root in roots
    )
