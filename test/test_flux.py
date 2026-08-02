"""Independent behavioral checks for the flux-coordinate translation."""

import importlib.util
from pathlib import Path

import sympy as sp


def _module():
    path = Path(__file__).parents[1] / "corpus/nc-plasma-DOCUMENTS/flux.py"
    spec = importlib.util.spec_from_file_location("flux", path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_flux_jacobian_and_metric_are_independent_source_forms():
    values = _module().results()
    r, thf, qa = sp.symbols("r thf qa")
    R0 = sp.Function("Subscript")(sp.Symbol("R"), 0)
    radial = R0**2 - r**2
    major = R0 - r * sp.cos(thf)
    rf = (r**2 - R0**2) / (r * sp.cos(thf) - R0)

    expected_ji = sp.Tuple(
        sp.Tuple(1, 0, 0),
        sp.Tuple(0, 1, 0),
        sp.Tuple(-R0 * sp.sin(thf) / radial, 0, major / sp.sqrt(radial)),
    )
    expected_j = sp.Tuple(
        sp.Tuple(1, 0, 0),
        sp.Tuple(0, 1, 0),
        sp.Tuple(
            R0 * sp.sin(thf) / (sp.sqrt(radial) * major),
            0,
            sp.sqrt(radial) / major,
        ),
    )
    assert values["Ji"] == expected_ji
    assert values["J"] == expected_j

    expected_grr = 1 + r**2 * R0**2 * sp.sin(thf) ** 2 / (
        radial * major**2
    )
    expected_grth = r**2 * R0 * sp.sin(thf) / major**2
    expected_gthth = r**2 * radial / major**2
    assert values["grr"] == expected_grr
    assert values["grth"] == expected_grth
    assert values["gthth"] == expected_gthth
    assert values["gij"] == sp.Tuple(
        sp.Tuple(expected_grr, 0, expected_grth),
        sp.Tuple(0, rf**2, 0),
        sp.Tuple(expected_grth, 0, expected_gthth),
    )

    expected_det = rf**2 * (expected_grr * expected_gthth - expected_grth**2)
    assert sp.simplify(values["sqgf"] ** 2 - expected_det) == 0

    B0 = sp.Function("Subscript")(sp.Symbol("B"), 0)
    bph2 = B0 * R0 / rf**2
    bth2 = bph2 / qa
    expected_btot1 = rf**2 * bph2**2 + expected_gthth * bth2**2
    expected_btot2 = rf**2 * (B0 * R0 / rf**2) ** 2 + r**2 * (
        B0 * R0 / rf**2 / (sp.sqrt(radial) * (qa / rf))
    ) ** 2
    assert sp.simplify(values["Btot1"] ** 2 - expected_btot1) == 0
    assert sp.simplify(values["Btot2"] ** 2 - expected_btot2) == 0


def test_flux_comparison_bindings_preserve_source_psidot_state():
    values = _module().results()
    r, thf = sp.symbols("r thf")
    theta = sp.Symbol("ϑ")
    R0 = sp.Function("Subscript")(sp.Symbol("R"), 0)
    B0 = sp.Function("Subscript")(sp.Symbol("B"), 0)
    psidot = sp.Symbol("psidot")
    radial = R0**2 - r**2
    major = R0 - r * sp.cos(thf)
    thof = -2 * sp.acot(
        (r - R0) * sp.cot(thf / 2) / sp.sqrt(radial)
    )
    expected_rff = R0 + r * sp.cos(thof)
    assert values["Rff"] == expected_rff

    expected_grr = 1 + r**2 * R0**2 * sp.sin(thf) ** 2 / (
        radial * major**2
    )
    expected_grth = r**2 * R0 * sp.sin(thf) / major**2
    expected_gthth = r**2 * radial / major**2
    expected_rf = (r**2 - R0**2) / (r * sp.cos(thf) - R0)
    expected_sqgf = sp.sqrt(
        expected_rf**2 * (expected_grr * expected_gthth - expected_grth**2)
    )
    expected_at_theta = expected_sqgf.subs(
        thf,
        -2 * sp.atan(
            (r - R0) * sp.tan(theta / 2) / sp.sqrt(radial)
        ),
    )
    Bphi = sp.Function("Subscript")(sp.Symbol("B"), sp.Symbol("φ"))
    expected_dnudth = r * (R0 + r * sp.cos(theta)) * Bphi
    assert values["dpsitildedth"] == expected_dnudth - psidot
    assert values["Bph1"] == psidot / expected_at_theta
    assert values["Bphatest"] == psidot / expected_sqgf
    assert values["Bthatest"] == psidot / (
        sp.Symbol("qa") * expected_sqgf
    )
    expected_bphtest = B0 * R0 / expected_rf**2
    assert values["sqgtest"] == psidot / expected_bphtest
