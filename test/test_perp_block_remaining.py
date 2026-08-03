"""Independent regression for the source-faithful perpendicular seed vector."""

import importlib.util
import math
from pathlib import Path

import sympy as sp


def _module():
    path = Path(__file__).parents[1] / 'corpus/proj-cpp-derivation/perp_block_check.py'
    spec = importlib.util.spec_from_file_location('perp_block_remaining', path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_e1_uses_the_source_metric_norm_for_a_nontrivial_projection():
    values = _module().results()
    dot = sp.Function('Dot')
    bc, bn = sp.symbols('Bc Bn')

    # Independent numeric oracle: project seed=(1,0,0) against the opaque
    # field direction, then normalize with the source metric at (r, th)=(.5,.7).
    bc_value, bn_value = 2.0, 5.0
    projection = bc_value / bn_value
    raw = (1.0 - projection**2, -projection**2, -projection**2)
    metric_diag = (
        1.0,
        0.5**2,
        (3.0 + 0.5 * math.cos(0.7))**2,
    )
    norm = math.sqrt(sum(weight * component**2
                         for weight, component in zip(metric_diag, raw)))
    expected = tuple(component / norm for component in raw)

    actual = values['e1'].subs({bc: bc_value, bn: bn_value})
    actual = actual.replace(
        lambda expr: expr.func == dot,
        lambda expr: expr.args[1],
    )
    assert all(
        math.isclose(float(component), expected_component, rel_tol=1e-12)
        for component, expected_component in zip(actual, expected)
    )
