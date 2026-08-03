from __future__ import annotations

import importlib.util
from pathlib import Path

import sympy as sp


_SOURCE = (
    Path(__file__).parents[1]
    / "corpus/proj-flux_pumping/34_memo_maxwell_20260714.py"
)


def _translated_values():
    spec = importlib.util.spec_from_file_location("memo_maxwell_34_v107", _SOURCE)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module.results()


def test_memo34_jr_chain_preserves_the_helical_partial_derivative():
    values = _translated_values()
    rho, theta, phi, m, n = sp.symbols("rho theta phi m n")
    alpha = m * theta + n * phi
    derivative1 = sp.Function("Derivative1")
    expected = (
        m * sp.Function("jtheta")(rho, alpha) * derivative1(
            sp.Symbol("radius"), 2, rho, alpha
        )
        + n * sp.Function("jphi")(rho, alpha) * derivative1(
            sp.Symbol("radius"), 2, rho, alpha
        )
    )

    assert values["jrChain"] == expected

    phase = sp.Symbol("phase")
    radius = rho * (1 + rho * sp.cos(phase))
    fixture = values["jrChain"].xreplace(
        {
            sp.Function("jtheta")(rho, alpha): rho**2 + sp.sin(alpha),
            sp.Function("jphi")(rho, alpha): sp.cos(alpha) - rho,
            derivative1(sp.Symbol("radius"), 2, rho, alpha):
                sp.diff(radius, phase).subs(phase, alpha),
        }
    )
    independent = (m * (rho**2 + sp.sin(alpha))
                   + n * (sp.cos(alpha) - rho)) * sp.diff(
                       radius, phase
                   ).subs(phase, alpha)
    sample = {m: 2, n: 1, rho: sp.Rational(1, 2),
              theta: sp.pi / 5, phi: sp.pi / 7}
    assert sp.simplify(fixture.subs(sample) - independent.subs(sample)) == 0
