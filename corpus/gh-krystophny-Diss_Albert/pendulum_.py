"""Generated SymPy translation of ``corpus/gh-krystophny-Diss_Albert/pendulum_.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 16 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('$Assumptions', '{Element[k, Reals], Element[x, Reals]}', ()),
    ('H', 'p^2/(2*m) + U0*Sin[x/2]^2', ()),
    ('J1', 'FullSimplify[Integrate[Sqrt[k - Sin[x/2]^2], {x, 0, 2*Pi}], Assumptions -> k > 1]/(2*Pi)', ()),
    ('J2', '2*(Sqrt[k]/Pi)*EllipticE[1/k]', ()),
    ('J2', '4*(Sqrt[H/U0]/Pi)*EllipticE[U0/H]', ()),
    ('x0', 'ArcCos[1 - 2*k^2]', ()),
    ('J1', 'FullSimplify[Integrate[Sqrt[k - Sin[x/2]^2], {x, -x0, x0}, Assumptions -> {k < 1, k > 0}]]/Pi', ()),
    ('J2', '(4/Pi)*(EllipticE[k] - (1 - k)*EllipticK[k])', ()),
    ('tau', 'FullSimplify[Integrate[1/Sqrt[k - Sin[x/2]^2], x, Assumptions -> {k < 1, k > 0}]]', ()),
    ('J', 'Sqrt[m*U0]*(8/Pi)*(EllipticE[H/(2.*U0)] - (1 - H/(2.*U0))*EllipticK[H/(2.*U0)])', ('H',)),
    ('tht', '(2*EllipticF[x/2, 1/k^2])/k', ('k', 'x')),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/gh-krystophny-Diss_Albert/pendulum_.wl')
