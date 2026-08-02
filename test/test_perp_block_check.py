import importlib.util
from pathlib import Path

import sympy as sp


def _module():
    path = Path(__file__).parents[1] / 'corpus/proj-cpp-derivation/perp_block_check.py'
    spec = importlib.util.spec_from_file_location('perp_block_check', path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_gin_is_the_inverse_of_the_source_metric_at_the_seed():
    values = _module().results()
    r0 = sp.Float('0.5')
    th0 = sp.Float('0.7')
    metric = sp.diag(1, r0**2, (3 + r0 * sp.cos(th0))**2)

    gin = sp.Matrix(values['gIN'])
    expected = metric.inv()
    assert all(
        abs(float(gin[i, j] - expected[i, j])) < 1e-12
        for i in range(3)
        for j in range(3)
    )
    product = gin * metric
    assert all(
        abs(float(product[i, j] - (1 if i == j else 0))) < 1e-12
        for i in range(3)
        for j in range(3)
    )
