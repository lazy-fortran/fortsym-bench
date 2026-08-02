import sympy as sp
from importlib.util import module_from_spec, spec_from_file_location
from pathlib import Path


def _target_results():
    path = Path(__file__).parents[1] / "corpus/proj-flux_pumping/28_general_maxwell_surface.py"
    spec = spec_from_file_location("general_maxwell_surface", path)
    module = module_from_spec(spec)
    spec.loader.exec_module(module)
    return module.results()


def test_maxwell_surface_normal_forms_and_first_order_surface_identity():
    r, theta, z, m, k, cl, eps = sp.symbols(
        "r theta z m k cl eps"
    )
    current = sp.Function("current")(r)
    u = sp.Function("u")(r)
    btheta0 = sp.Function("btheta0")(r)
    bz0 = sp.Function("bz0")(r)
    psi0 = sp.Function("psi0")(r)
    chi = m * theta + k * z
    br_amp = (sp.diff(u, r) - 4 * sp.pi * r * current / cl) / m
    btheta_amp = u / r
    bz_amp = k * u / m
    detuning = m * btheta0 / r + k * bz0
    br_total = eps * br_amp * sp.sin(chi)
    btheta_total = btheta0 + eps * btheta_amp * sp.cos(chi)
    bz_total = bz0 + eps * bz_amp * sp.cos(chi)
    psi = psi0 - eps * r * br_amp * sp.cos(chi)
    rho = r + eps * br_amp / detuning * sp.cos(chi)

    rho_dot = (
        br_total * sp.diff(rho, r)
        + btheta_total * sp.diff(rho, theta) / r
        + bz_total * sp.diff(rho, z)
    )
    assert sp.simplify(sp.expand(rho_dot).coeff(eps, 1)) == 0

    psi_dot = (
        br_total * sp.diff(psi, r)
        + btheta_total * sp.diff(psi, theta) / r
        + bz_total * sp.diff(psi, z)
    )
    surface_rules = {
        sp.diff(psi0, r): -r * detuning,
        sp.diff(u, (r, 2)): -sp.diff(u, r) / r
        + (m**2 / r**2 + k**2) * u
        + r * sp.diff(4 * sp.pi * current / cl, r)
        + 2 * 4 * sp.pi * current / cl,
    }
    assert sp.simplify(psi_dot.subs(surface_rules)) == 0

    s = sp.Symbol("s")
    compact_inside = sp.Rational(1, 2) * (
        r**-1 * sp.integrate(s**3 * (1 - s)**2, (s, 0, r))
        - r * sp.integrate(s * (1 - s)**2, (s, r, 1))
    )
    expected_compact_inside = r * (25 * r**4 - 64 * r**3 + 45 * r**2 - 5) / 120
    assert sp.simplify(compact_inside - expected_compact_inside) == 0


def test_generated_maxwell_bindings_match_independent_source_normal_forms():
    values = _target_results()
    r, theta, z, m, k, cl = sp.symbols("r theta z m k cl")
    current = sp.Function("current")(r)
    u = sp.Function("u")(r)
    chi = m * theta + k * z
    source = 4 * sp.pi * current / cl
    radial_residual = (
        sp.diff(u, r, 2)
        + sp.diff(u, r) / r
        - (m**2 / r**2 + k**2) * u
        - r * sp.diff(source, r)
        - 2 * source
    )
    expected_div_b = radial_residual * sp.sin(chi) / m
    expected_curl_b = sp.Tuple(
        0,
        -k * r * source * sp.cos(chi) / m,
        source * sp.cos(chi),
    )
    assert sp.simplify(values["divB"] - expected_div_b) == 0
    expected_br = (
        sp.diff(u, r) - 4 * sp.pi * r * current / cl
    ) * sp.sin(chi) / m
    assert sp.simplify(values["br"] - expected_br) == 0
    assert all(
        sp.simplify(actual - expected) == 0
        for actual, expected in zip(values["curlB"], expected_curl_b)
    )

    rule = sp.Function("Rule")
    derivative1 = sp.Function("Derivative1")
    lower_green = sp.Function("lowerGreen")(r)
    upper_green = sp.Function("upperGreen")(r)
    reg = sp.Function("reg")(r)
    dec = sp.Function("dec")(r)
    source = 4 * sp.pi * current / cl
    assert values["greenDerivativeRules"] == sp.Tuple(
        rule(
            derivative1(sp.Symbol("lowerGreen"), 1, r),
            r**2 * derivative1(sp.Symbol("reg"), 1, r) * source,
        ),
        rule(
            derivative1(sp.Symbol("upperGreen"), 1, r),
            -r**2 * derivative1(sp.Symbol("dec"), 1, r) * source,
        ),
    )
    assert values["greenHomogeneousRules"] == sp.Tuple(
        rule(
            derivative1(sp.Symbol("reg"), 2, r),
            -derivative1(sp.Symbol("reg"), 1, r) / r
            + reg * (m**2 / r**2 + k**2),
        ),
        rule(
            derivative1(sp.Symbol("dec"), 2, r),
            -derivative1(sp.Symbol("dec"), 1, r) / r
            + dec * (m**2 / r**2 + k**2),
        ),
    )
    assert values["surfaceRules"][0] == rule(
        derivative1(sp.Symbol("psi0"), 1, r),
        -r * (m * sp.Function("btheta0")(r) / r + k * sp.Function("bz0")(r)),
    )
    assert values["surfaceRules"][1] == rule(
        derivative1(sp.Symbol("u"), 2, r),
        -derivative1(sp.Symbol("u"), 1, r) / r
        + (m**2 / r**2 + k**2) * sp.Function("u")(r)
        + r * derivative1(sp.Symbol("source"), 1, r)
        + 2 * source,
    )
    assert values["greenWronskian"] == sp.Eq(
        reg * derivative1(sp.Symbol("dec"), 1, r)
        - derivative1(sp.Symbol("reg"), 1, r) * dec,
        -1 / r,
    )
    assert values["uGreenPrime"] == (
        derivative1(sp.Symbol("dec"), 1, r) * lower_green
        + derivative1(sp.Symbol("reg"), 1, r) * upper_green
        + r * source
    )
    second_derivative = sp.Function("Derivative2")
    expected_second = (
        second_derivative(sp.Symbol("dec"), 1, 1, r) * lower_green
        + second_derivative(sp.Symbol("reg"), 1, 1, r) * upper_green
        + r * sp.diff(source, r)
        + source
    )
    assert values["uGreenSecond"] == expected_second
    assert values["greenResidual"] == (
        expected_second
        + values["uGreenPrime"] / r
        - (k**2 + m**2 / r**2)
        * (dec * lower_green + reg * upper_green)
        - r * derivative1(sp.Symbol("source"), 1, r)
        - 2 * source
    )
    assert values["uNumeric"].func == sp.Function("NDSolveValue")
    assert values["uNumeric"].args[1] == sp.Symbol("v")
    assert values["uNumeric"].args[2] == sp.Tuple(
        sp.Symbol("x"), sp.Rational(1, 20), 14
    )
    assert values["uNumeric"].args[0][-1] == sp.Eq(
        sp.Function("v")(14), sp.Function("uGreenNum")(14)
    )
