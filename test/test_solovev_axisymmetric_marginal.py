import importlib.util
from pathlib import Path

import sympy as sp


def _results():
    path = (
        Path(__file__).parents[1]
        / 'corpus/proj-gvec-stability/solovev_axisymmetric_marginal.py'
    )
    spec = importlib.util.spec_from_file_location('solovev_axisymmetric_marginal', path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module.results()


def test_surface_derivatives_and_frozen_values_are_source_faithful():
    values = _results()
    a, e, r0, sig, w, psio = sp.symbols('a e r0 sig w psio')
    r_sq = r0**2 + 2 * a * r0 * sig * sp.cos(w)
    r_w = sp.sqrt(r_sq)
    z_w = e * a * r0 * sig * sp.sin(w) / r_w
    psi = psio - psio / (a * r0)**2 * (
        (sp.Symbol('R') * sp.Symbol('Z') / e)**2
        + (sp.Symbol('R')**2 - r0**2)**2 / 4
    )
    R, Z = sp.symbols('R Z')
    psi = psi.subs({'R': R, 'Z': Z})

    expected_dl_sq = sp.diff(r_w, w)**2 + sp.diff(z_w, w)**2
    expected_grad_sq = (
        sp.diff(psi, R)**2 + sp.diff(psi, Z)**2
    ).subs({R: r_w, Z: z_w})
    assert sp.simplify(values['dlSq'] - expected_dl_sq) == 0
    assert sp.simplify(values['gradPsiSq'] - expected_grad_sq) == 0
    assert sp.simplify(
        values['integrandSq'] - expected_dl_sq / (r_sq * expected_grad_sq)
    ) == 0

    assert values['values'] == sp.Tuple(
        sp.Function('Rule')(sp.Symbol('e'), sp.Rational(8, 5)),
        sp.Function('Rule')(sp.Symbol('a'), sp.Rational(33, 100)),
        sp.Function('Rule')(sp.Symbol('r0'), 1),
        sp.Function('Rule')(sp.Symbol('f0'), 1),
        sp.Function('Rule')(sp.Symbol('psio'), sp.Rational(1089, 23750)),
    )
