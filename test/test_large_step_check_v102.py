from __future__ import annotations

import importlib.util
from pathlib import Path

import sympy as sp


def _module():
    path = Path(__file__).parents[1] / "corpus/proj-cpp-derivation/large_step_check.py"
    spec = importlib.util.spec_from_file_location("large_step_check_v102", path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_sampled_full_hessian_matches_an_independent_source_oracle():
    values = _module().results()
    r, th, ph, p1, p2, p3, qc = sp.symbols("r th ph p1 p2 p3 qc")
    metric = sp.diag(1, r**2, (3 + r * sp.cos(th)) ** 2)
    a_cov = sp.Matrix([
        0,
        r**2 / 2 - r**3 * sp.cos(th) / 9,
        -(r**2 / 2 - r**4 / 4),
    ])
    sqrt_metric = sp.sqrt(metric.det())
    b_contra = sp.Matrix([
        sp.diff(a_cov[2], th),
        -sp.diff(a_cov[2], r),
        sp.diff(a_cov[1], r),
    ]) / sqrt_metric
    b_magnitude = sp.sqrt((b_contra.T * metric * b_contra)[0])
    momentum = sp.Matrix([p1, p2, p3]) - qc * a_cov
    hamiltonian = (momentum.T * metric.inv() * momentum)[0] / 2 + b_magnitude / 10
    hessian = sp.hessian(hamiltonian, (r, th, ph, p1, p2, p3))
    sample = {
        r: sp.Rational(1, 2),
        th: sp.Rational(7, 10),
        ph: sp.Rational(1, 5),
        p1: sp.Rational(3, 100),
        p2: sp.Rational(1, 4),
        p3: -sp.Rational(2, 5),
    }
    expected = hessian.subs(sample).applyfunc(lambda entry: sp.N(entry, 30))
    actual = values["SqcAt"]

    assert len(actual) == 6
    assert all(len(row) == 6 for row in actual)
    for qc_value in (sp.Integer(0), sp.Integer(1), sp.Rational(7, 3)):
        for i in range(6):
            for j in range(6):
                difference = sp.N(actual[i][j].subs(qc, qc_value) - expected[i, j].subs(qc, qc_value), 25)
                assert abs(float(difference)) < 1e-22
