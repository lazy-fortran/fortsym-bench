"""Independent regression for the v99 Clebsch-field recovery."""

from __future__ import annotations

import importlib.util
from pathlib import Path

import sympy as sp


def _load_app():
    path = (
        Path(__file__).parents[1]
        / "corpus/proj-neort-proofs/appA_flux_coordinates.py"
    )
    spec = importlib.util.spec_from_file_location(
        "appA_flux_coordinates_v99", path
    )
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_bclebsch_matches_independent_coordinate_cross_product():
    values = _load_app().results()
    r, ph, th, R0, eps = sp.symbols("r ph th R0 eps")
    af = sp.Function("af")
    bf = sp.Function("bf")
    nut = sp.Function("nut")

    x = sp.Matrix(
        [
            (R0 + r * sp.cos(th)) * sp.cos(ph),
            -(R0 + r * sp.cos(th)) * sp.sin(ph),
            r * sp.sin(th) + eps * r**2 * sp.sin(ph),
        ]
    )
    reciprocal = x.jacobian((r, ph, th)).inv()
    basis = [sp.Matrix(list(reciprocal.row(i))) for i in range(3)]
    nu = af(r) * ph + bf(r) * th + nut(r, ph, th)
    coordinate_derivatives = [sp.diff(nu, variable) for variable in (r, ph, th)]
    gradient = sum(
        (
            coordinate_derivatives[index] * basis[index]
            for index in range(3)
        ),
        sp.zeros(3, 1),
    )

    # Give the opaque source functions concrete local profiles at a nontrivial
    # point. This keeps the oracle independent while avoiding a giant symbolic
    # simplification of the two differently factored vectors.
    profiles = {
        af(r): r**2,
        bf(r): 1 + r,
        sp.diff(af(r), r): 2 * r,
        sp.diff(bf(r), r): 1,
        sp.diff(nut(r, ph, th), r): ph * th,
        sp.diff(nut(r, ph, th), ph): r * th,
        sp.diff(nut(r, ph, th), th): r * ph,
    }
    point = {
        r: sp.Rational(7, 10),
        ph: sp.Rational(2, 5),
        th: sp.Rational(11, 10),
        R0: 3,
        eps: sp.Rational(1, 4),
    }
    expected = basis[0].cross(gradient).xreplace(profiles).subs(point)
    actual = sp.Matrix(values["Bclebsch"]).xreplace(profiles).subs(point)

    for observed, reference in zip(actual, expected):
        assert abs(float(sp.N(observed - reference, 15))) < 1e-12
