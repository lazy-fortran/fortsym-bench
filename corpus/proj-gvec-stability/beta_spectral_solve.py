"""Generated SymPy translation of ``corpus/proj-gvec-stability/beta_spectral_solve.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 5 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('pass', '0', ()),
    ('fail', '0', ()),
    ('assumptions', '{r > 0, len > 0, mu0 > 0, bz[r] > 0, mm > 0, nn > 0,\n  Element[{btheta[r], Derivative[1][btheta][r], Derivative[1][bz][r],\n    beta[r, u, v]}, Reals], btheta[r]^2 + bz[r]^2 > 0}', ()),
    ('check', 'If[\n  TrueQ[FullSimplify[condition, assumptions]],\n  pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]]', ('name', 'condition')),
    ('conj', 'expr /. Complex[a_, b_] :> Complex[a, -b]', ('expr',)),
    ('position', '{r Cos[2 Pi u], r Sin[2 Pi u], len v}', ('r', 'u', 'v')),
    ('basis', '{D[position[r, u, v], r], D[position[r, u, v], u],\n  D[position[r, u, v], v]}', ('r', 'u', 'v')),
    ('jacobian', 'basis[r, u, v][[1]] .\n  Cross[basis[r, u, v][[2]], basis[r, u, v][[3]]]', ('r', 'u', 'v')),
    ('field', 'btheta[r] {-Sin[2 Pi u], Cos[2 Pi u], 0} +\n  bz[r] {0, 0, 1}', ('r', 'u', 'v')),
    ('fieldWithBeta', 'Module[{b = basis[r, u, v], jac},\n  jac = jacobian[r, u, v];\n  field[r, u, v] + beta[r, u, v] Cross[b[[2]], b[[3]]]/jac]', ('r', 'u', 'v')),
    ('curlCartesian', 'Module[{b, jac, grads},\n  b = basis[r, u, v]; jac = jacobian[r, u, v];\n  grads = {Cross[b[[2]], b[[3]]], Cross[b[[3]], b[[1]]],\n    Cross[b[[1]], b[[2]]]}/jac;\n  Sum[Cross[grads[[i]],\n    D[fieldWithBeta[rr, uu, vv], {{rr, uu, vv}[[i]]}] /.\n      {rr -> r, uu -> u, vv -> v}], {i, 3}]]', ('r', 'u', 'v')),
    ('covariantU', '2 Pi r btheta[r]', ()),
    ('covariantV', 'len bz[r]', ()),
    ('contravariantU', 'btheta[r]/(2 Pi r)', ()),
    ('contravariantV', 'bz[r]/len', ()),
    ('betaU', 'D[beta[r, uu, v], uu] /. uu -> u', ()),
    ('betaV', 'D[beta[r, u, vv], vv] /. vv -> v', ()),
    ('forceS', 'Cross[curlCartesian[r, u, v], fieldWithBeta[r, u, v]] .\n  basis[r, u, v][[1]]', ()),
    ('fluxP', 'len btheta[r]', ()),
    ('fluxT', '2 Pi r bz[r]', ()),
    ('harmonic', 'Cos[2 Pi (mm u - nn v)]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-gvec-stability/beta_spectral_solve.wl')
