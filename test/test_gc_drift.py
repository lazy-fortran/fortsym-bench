import importlib.util
from pathlib import Path

import sympy as sp


def _module():
    path = Path(__file__).parents[1] / "corpus/proj-cpp-derivation/gc_drift.py"
    spec = importlib.util.spec_from_file_location("gc_drift_generated", path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def test_unresolved_series_keeps_the_native_opaque_head():
    assert _module().results()["vGCser"] == sp.Symbol("vGC")


def test_scalar_matrix_dot_keeps_the_metric_velocity_identity():
    values = _module().results()
    r, th = sp.symbols("r th")
    Bctr = sp.Symbol("Bctr")
    vpar = sp.Symbol("vpar")
    Rr = sp.Symbol("R0") + r * sp.cos(th)
    metric = sp.diag(1, r**2, Rr**2)
    expected_bcov = sp.Tuple(
        sp.Tuple(Bctr, 0, 0),
        sp.Tuple(0, Bctr * r**2, 0),
        sp.Tuple(0, 0, Bctr * Rr**2),
    )

    # The source's scalar placeholder is threaded through the explicit metric;
    # it is not an opaque Dot[metric, Bctr].  The raised strict velocity then
    # reduces to the scalar speed times the identity matrix.
    assert values["Bcov"] == expected_bcov
    assert (metric * metric.inv()).applyfunc(sp.simplify) == sp.eye(3)
    bmag2 = sp.Function("List")(
        sp.Function("List")(Bctr**2, 0, 0),
        sp.Function("List")(0, Bctr**2 * r**2, 0),
        sp.Function("List")(0, 0, Bctr**2 * Rr**2),
    )
    speed = Bctr * vpar / sp.sqrt(bmag2)
    expected_vstrict = sp.Function("List")(
        sp.Function("List")(speed, 0, 0),
        sp.Function("List")(0, speed, 0),
        sp.Function("List")(0, 0, speed),
    )
    assert values["vStrict"] == expected_vstrict
