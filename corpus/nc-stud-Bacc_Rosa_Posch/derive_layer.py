"""Generated SymPy translation of ``corpus/nc-stud-Bacc_Rosa_Posch/derive_layer.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 13 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('out', 'OpenWrite["tex/symbolic-results.tex"]', ()),
    ('writeTex', 'WriteString[\n    out,\n    "\\\\newcommand{\\\\" <> name <> "}{" <> ToString[TeXForm[expr]] <> "}\\n"\n]', ('name', 'expr')),
    ('writeLine', 'WriteString[out, text <> "\\n"]', ('text',)),
    ('thetaRule', 'Derivative[1][thetaB][t] -> omegaB', ()),
    ('phiRule', 'Derivative[1][phiSlow][t] -> q omegaB deltaTP + OmegaT', ()),
    ('phase', 'm2 thetaB[t] + n phiSlow[t]', ()),
    ('omegaRes', 'FullSimplify[D[phase, t] /. {thetaRule, phiRule}]', ()),
    ('omegaToy', 'alpha + beta eta + gamma eta^2', ('eta',)),
    ('roots', 'FullSimplify[eta /. Solve[omegaToy[eta] == 0, eta]]', ()),
    ('jacobianWeights', 'FullSimplify[1/Abs[D[omegaToy[eta], eta] /. eta -> #] & /@ roots]', ()),
    ('interiorEquation', 'I a (eta - eta0) g[eta] - nu Derivative[2][g][eta] == S[eta]', ()),
    ('scaledInterior', 'FullSimplify[\n    interiorEquation /. {\n        eta -> eta0 + delta x,\n        Derivative[2][g][eta] -> Derivative[2][G][x]/delta^2,\n        g[eta] -> G[x],\n        S[eta] -> S0\n    } /. delta -> (nu/a)^(1/3),\n    Assumptions -> {a > 0, nu > 0}\n]', ()),
    ('k', 'Sqrt[I OmegaE/nu]', ()),
    ('gBoundary', '1/(I OmegaE) (1 - Cosh[k (1 - eta)]/Cosh[k])', ('eta',)),
    ('aBoundary', 'FullSimplify[\n    Integrate[gBoundary[eta], {eta, 0, 1}],\n    Assumptions -> {OmegaE > 0, nu > 0}\n]', ()),
    ('realSmallNuBoundary', 'Sqrt[nu]/(Sqrt[2] OmegaE^(3/2))', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/nc-stud-Bacc_Rosa_Posch/derive_layer.wl')
