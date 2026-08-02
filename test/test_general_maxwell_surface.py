import sympy as sp


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
