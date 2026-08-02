from __future__ import annotations

import importlib.util
from pathlib import Path

import sympy as sp


def _module():
    path = (
        Path(__file__).parents[1]
        / 'corpus/proj-cpp-derivation/variational_symplectic.py'
    )
    spec = importlib.util.spec_from_file_location('variational_symplectic', path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_legendre_transform_bindings_preserve_source_dot_forms():
    values = _module().results()
    dot = sp.Function('Dot')
    inverse_gm = sp.Function('Inverse')(sp.Symbol('gM'))
    mm = sp.Symbol('mm')
    pi_cov = values['piCov']

    expected_u = dot(inverse_gm, pi_cov) / mm
    expected_h = (
        sp.Symbol('muu') * values['Bm']
        + dot(dot(pi_cov, inverse_gm), pi_cov) / (2 * mm)
    )
    assert values['uOfp'] == expected_u
    assert values['HcppExp'] == expected_h
