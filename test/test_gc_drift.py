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


def test_christoffel_tensor_matches_independent_metric_derivatives():
    values = _module().results()
    r, th, ph, R0 = sp.symbols("r th ph R0")
    coords = (r, th, ph)
    metric = sp.diag(1, r**2, (R0 + r * sp.cos(th))**2)
    inverse = metric.inv()

    # Recompute the defining Christoffel formula independently of the
    # companion's hand-expanded tensor.
    expected = sp.Tuple(*(
        sp.Tuple(*(
            sp.Tuple(*(
                sp.simplify(sum(
                    inverse[i, ell] * (
                        sp.diff(metric[ell, j], coords[k])
                        + sp.diff(metric[ell, k], coords[j])
                        - sp.diff(metric[j, k], coords[ell])
                    ) / 2
                    for ell in range(3)
                ))
                for k in range(3)
            ))
            for j in range(3)
        ))
        for i in range(3)
    ))

    assert values["chr"] == expected
    point = {R0: 10, r: 2, th: sp.Rational(1, 5), ph: 0}

    def leaves(value):
        if isinstance(value, sp.Tuple):
            for item in value:
                yield from leaves(item)
        else:
            yield value

    assert all(
        sp.N(actual.subs(point) - reference.subs(point)) == 0
        for actual, reference in zip(leaves(values["chr"]), leaves(expected))
    )


def test_grad_bmod_matches_independent_derivative_of_field_norm():
    values = _module().results()
    r, th, ph = sp.symbols("r th ph")
    R0, B0, iota0, r0a = sp.symbols("R0 B0 iota0 r0a")
    Rr = R0 + r * sp.cos(th)
    ath_r = B0 * (r - r**2 * sp.cos(th) / R0)
    aph_r = -B0 * iota0 * (r - r**3 / r0a**2)
    field_norm = ath_r**2 / r**2 + aph_r**2 / Rr**2
    expected = sp.Tuple(*(
        sp.diff(sp.sqrt(field_norm), coordinate)
        for coordinate in (r, th, ph)
    ))

    assert all(
        sp.simplify(actual - reference) == 0
        for actual, reference in zip(values["gradBmod"], expected)
    )
    point = {R0: 10, B0: 3, iota0: 2, r0a: 7, r: 2, th: sp.Rational(1, 5)}
    assert all(
        sp.simplify((actual - reference).subs(point)) == 0
        for actual, reference in zip(values["gradBmod"], expected)
    )


def test_grad_bmod_r_component_matches_independent_sample_value():
    values = _module().results()
    r, th = sp.symbols("r th")
    R0, B0, iota0, r0a = sp.symbols("R0 B0 iota0 r0a")
    Rr = R0 + r * sp.cos(th)
    # Recompute the field norm directly from the two source potentials; this
    # does not use Wcl or any intermediate from the generated companion.
    ath_r = B0 * (r - r**2 * sp.cos(th) / R0)
    aph_r = -B0 * iota0 * (r - r**3 / r0a**2)
    direct_norm = ath_r**2 / r**2 + aph_r**2 / Rr**2
    point = {R0: 10, B0: 3, iota0: 2, r0a: 7, r: 2, th: sp.Rational(1, 5)}
    expected = sp.diff(sp.sqrt(direct_norm), r).subs(point)
    actual = values["gradBmod"][0].subs(point)

    assert sp.simplify(actual - expected) == 0
