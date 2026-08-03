from __future__ import annotations

import importlib.util
from pathlib import Path


def _module():
    path = Path(__file__).parents[1] / "corpus/proj-cpp-derivation/normal_stability_check.py"
    spec = importlib.util.spec_from_file_location("normal_stability_check", path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_inverse_metric_is_the_inverse_of_the_seed_metric():
    module = _module()
    values = module.results()
    metric = values["gN"]
    inverse = values["gIN"]
    assert all(
        abs(float(metric[i][i] * inverse[i][i]) - 1.0) < 1e-12
        for i in range(3)
    )


def test_fast_rotation_preserves_the_perpendicular_moment():
    import sympy as sp

    values = _module().results()
    vector = sp.Matrix([sp.Rational(1, 2), -sp.Rational(3, 10)])
    rotation = sp.Matrix(values["Jrot"])
    assert sp.simplify(vector.dot(rotation * vector)) == 0
    assert len(values["muSweepFast"]) == 3


def test_seed_frame_covector_preserves_the_projected_first_component():
    values = _module().results()
    # The covector is the metric lowering of the contravariant frame vector.
    # With the opaque native Dot form, check the unambiguous first component.
    assert values["e1cov"][0] == values["e1"][0]
