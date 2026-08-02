"""Generated SymPy translation of ``corpus/proj-gvec-stability/mercier_from_export.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 12 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('pass', '0', ()),
    ('fail', '0', ()),
    ('assumptions', '{r > 0, len > 0, mu0 > 0, bz[r] > 0,\n  Element[{btheta[r], Derivative[1][btheta][r], Derivative[1][bz][r],\n    beta[r, u, v], Derivative[1, 0, 0][beta][r, u, v],\n    Derivative[0, 1, 0][beta][r, u, v],\n    Derivative[0, 0, 1][beta][r, u, v]}, Reals],\n  btheta[r]^2 + bz[r]^2 > 0}', ()),
    ('check', 'If[\n  TrueQ[FullSimplify[condition, assumptions]],\n  pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]]', ('name', 'condition')),
    ('position', '{r Cos[2 Pi u], r Sin[2 Pi u], len v}', ('r', 'u', 'v')),
    ('basis', '{\n  D[position[r, u, v], r],\n  D[position[r, u, v], u],\n  D[position[r, u, v], v]}', ('r', 'u', 'v')),
    ('jacobian', 'basis[r, u, v][[1]] .\n  Cross[basis[r, u, v][[2]], basis[r, u, v][[3]]]', ('r', 'u', 'v')),
    ('field', 'btheta[r] {-Sin[2 Pi u], Cos[2 Pi u], 0} +\n  bz[r] {0, 0, 1}', ('r', 'u', 'v')),
    ('metric', 'Module[{b = basis[r, u, v]},\n  Table[b[[i]] . b[[j]], {i, 3}, {j, 3}]]', ('r', 'u', 'v')),
    ('contravariantB', 'Module[{b = basis[r, u, v], jac},\n  jac = jacobian[r, u, v];\n  {Cross[b[[2]], b[[3]]], Cross[b[[3]], b[[1]]],\n      Cross[b[[1]], b[[2]]]} . field[r, u, v]/jac]', ('r', 'u', 'v')),
    ('bSupU', 'contravariantB[r, u, v][[2]]', ()),
    ('bSupV', 'contravariantB[r, u, v][[3]]', ()),
    ('g', 'metric[r, u, v]', ()),
    ('covariantU', 'g[[2, 2]] bSupU + g[[2, 3]] bSupV', ()),
    ('covariantV', 'g[[3, 2]] bSupU + g[[3, 3]] bSupV', ()),
    ('covariantS', 'g[[1, 2]] bSupU + g[[1, 3]] bSupV', ()),
    ('fieldWithBeta', 'Module[{b = basis[r, u, v], jac, gradS},\n  jac = jacobian[r, u, v];\n  gradS = Cross[b[[2]], b[[3]]]/jac;\n  field[r, u, v] + beta[r, u, v] gradS]', ('r', 'u', 'v')),
    ('curlCartesian', 'Module[{fx, fy, fz, jacInv, b, jac, grads},\n  b = basis[r, u, v];\n  jac = jacobian[r, u, v];\n  grads = {Cross[b[[2]], b[[3]]], Cross[b[[3]], b[[1]]],\n    Cross[b[[1]], b[[2]]]}/jac;\n  Sum[Cross[grads[[i]],\n    D[fieldWithBeta[rr, uu, vv], {{rr, uu, vv}[[i]]}] /.\n      {rr -> r, uu -> u, vv -> v}], {i, 3}]]', ('r', 'u', 'v')),
    ('betaU', 'D[beta[r, uu, v], uu] /. uu -> u', ()),
    ('betaV', 'D[beta[r, u, vv], vv] /. vv -> v', ()),
    ('curlFormula', 'Module[{b = basis[r, u, v], jac},\n  jac = jacobian[r, u, v];\n  (betaV - D[covariantV, r]) b[[2]]/jac +\n    (D[covariantU, r] - betaU) b[[3]]/jac]', ('r', 'u', 'v')),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-gvec-stability/mercier_from_export.wl')
