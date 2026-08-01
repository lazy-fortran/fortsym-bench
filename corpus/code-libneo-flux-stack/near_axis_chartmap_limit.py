"""Generated SymPy translation of ``corpus/code-libneo-flux-stack/near_axis_chartmap_limit.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 26 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('Rr', 'r0[ze] + rho (r1c[ze] Cos[th] + r1s[ze] Sin[th])', ()),
    ('Zz', 'z0[ze] + rho (z1c[ze] Cos[th] + z1s[ze] Sin[th])', ()),
    ('ph', 'p0[ze] + rho (p1c[ze] Cos[th] + p1s[ze] Sin[th])', ()),
    ('xvec', '{Rr Cos[ph], Rr Sin[ph], Zz}', ()),
    ('eRho', 'D[xvec, rho]', ()),
    ('eThe', 'D[xvec, th]', ()),
    ('eZet', 'D[xvec, ze]', ()),
    ('aRho', 'Simplify[eRho /. rho -> 0]', ()),
    ('aThe', 'Simplify[eThe /. rho -> 0]', ()),
    ('aZet', 'Simplify[eZet /. rho -> 0]', ()),
    ('gTT', 'Simplify[eThe . eThe]', ()),
    ('gRR', 'Simplify[eRho . eRho]', ()),
    ('Jpolar', 'Det[Transpose[{eRho, eThe, eZet}]]', ()),
    ('sub', '{rho Cos[th] -> Xv, rho Sin[th] -> Yv, rho^2 -> Xv^2 + Yv^2,\n   rho^2 Cos[2 th] -> Xv^2 - Yv^2, rho^2 Sin[2 th] -> 2 Xv Yv}', ()),
    ('RrC', 'r0[ze] + (r1c[ze] Xv + r1s[ze] Yv)', ()),
    ('ZzC', 'z0[ze] + (z1c[ze] Xv + z1s[ze] Yv)', ()),
    ('phC', 'p0[ze] + (p1c[ze] Xv + p1s[ze] Yv)', ()),
    ('xC', '{RrC Cos[phC], RrC Sin[phC], ZzC}', ()),
    ('eX', 'D[xC, Xv] /. {Xv -> 0, Yv -> 0}', ()),
    ('eY', 'D[xC, Yv] /. {Xv -> 0, Yv -> 0}', ()),
    ('eZc', 'D[xC, ze] /. {Xv -> 0, Yv -> 0}', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/code-libneo-flux-stack/near_axis_chartmap_limit.wl')
