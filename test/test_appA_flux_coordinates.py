from __future__ import annotations

import importlib.util
import sys
from pathlib import Path

import sympy as sp


def _load_app():
    root = Path(__file__).parents[1]
    sys.path.insert(0, str(root))
    path = root / "corpus/proj-neort-proofs/appA_flux_coordinates.py"
    spec = importlib.util.spec_from_file_location("appA_flux_coordinates", path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_appA_coordinate_basis_is_source_faithful():
    app = _load_app()
    values = app.results()

    r, ph, th, R0, eps = sp.symbols("r ph th R0 eps")
    x = sp.Tuple(
        (R0 + r * sp.cos(th)) * sp.cos(ph),
        -(R0 + r * sp.cos(th)) * sp.sin(ph),
        r * sp.sin(th) + eps * r**2 * sp.sin(ph),
    )
    expected_jacobian = sp.Matrix.hstack(
        sp.Matrix([sp.diff(component, r) for component in x]),
        sp.Matrix([sp.diff(component, ph) for component in x]),
        sp.Matrix([sp.diff(component, th) for component in x]),
    )
    actual_jacobian = sp.Matrix(values["jacM"])
    point = {
        r: sp.Rational(7, 10),
        ph: sp.Rational(2, 5),
        th: sp.Rational(11, 10),
        R0: 3,
        eps: sp.Rational(1, 4),
    }

    assert actual_jacobian.subs(point) == expected_jacobian.subs(point)
    reciprocal = (sp.Matrix(values["gradu"]) * actual_jacobian).subs(point)
    assert reciprocal.applyfunc(sp.trigsimp) == sp.eye(3)
    assert sp.trigsimp(values["sg"].subs(point) + actual_jacobian.det().subs(point)) == 0


def test_appA_derived_fields_preserve_opaque_derivative_heads():
    values = _load_app().results()
    derivative1 = sp.Function("Derivative1")

    for name in ("Br", "Bph", "Bth", "Blin", "Blinreduced"):
        assert not any(
            isinstance(node, sp.Derivative)
            for node in sp.preorder_traversal(values[name])
        )
    assert any(
        node.func == derivative1
        for node in sp.preorder_traversal(values["Bph"])
        if getattr(node, "is_Function", False)
    )


def test_appA_contravariant_and_linear_flux_identities():
    values = _load_app().results()
    r, ph, th = sp.symbols("r ph th")
    derivative1 = sp.Function("Derivative1")
    dnu_th = sp.Function("bf")(r) + derivative1(
        sp.Symbol("nut"), 3, r, ph, th
    )
    dnu_ph = sp.Function("af")(r) + derivative1(
        sp.Symbol("nut"), 2, r, ph, th
    )

    assert values["Br"] == 0
    assert sp.simplify(values["Bph"] - dnu_th / values["sg"]) == 0
    assert sp.simplify(values["Bth"] + dnu_ph / values["sg"]) == 0
    assert all(
        sp.simplify(left - right) == 0
        for left, right in zip(values["Blin"], values["Blinreduced"])
    )
