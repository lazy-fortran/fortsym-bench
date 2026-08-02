"""Generated SymPy translation of ``corpus/proj-gvec-stability/sigma_tilde_recovery.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 7 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('pass', '0', ()),
    ('fail', '0', ()),
    ('assumptions', '{r > 0, len > 0, bz[r] > 0, btheta[r] > 0,\n  Element[{lam[r], Derivative[1][lam][r]}, Reals],\n  btheta[r]^2 + bz[r]^2 > 0, 0 < u < 1/4, 0 < v < 1}', ()),
    ('check', 'If[\n  TrueQ[FullSimplify[condition, assumptions]],\n  pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]]', ('name', 'condition')),
    ('position', '{r Cos[2 Pi (u + lam[r])],\n  r Sin[2 Pi (u + lam[r])], len v}', ('r', 'u', 'v')),
    ('basis', '{D[position[r, u, v], r], D[position[r, u, v], u],\n  D[position[r, u, v], v]}', ('r', 'u', 'v')),
    ('jac', 'basis[r, u, v][[1]] .\n  Cross[basis[r, u, v][[2]], basis[r, u, v][[3]]]', ('r', 'u', 'v')),
    ('duals', 'Module[{b = basis[r, u, v]},\n  {Cross[b[[2]], b[[3]]], Cross[b[[3]], b[[1]]],\n    Cross[b[[1]], b[[2]]]}/jac[r, u, v]]', ('r', 'u', 'v')),
    ('field', 'btheta[r] {-Sin[2 Pi (u + lam[r])],\n  Cos[2 Pi (u + lam[r])], 0} + bz[r] {0, 0, 1}', ('r', 'u', 'v')),
    ('bmag2', 'btheta[r]^2 + bz[r]^2', ()),
    ('covariantS', 'FullSimplify[basis[r, u, v][[1]] . field[r, u, v],\n  assumptions]', ()),
    ('covariantU', 'FullSimplify[basis[r, u, v][[2]] . field[r, u, v],\n  assumptions]', ()),
    ('covariantV', 'FullSimplify[basis[r, u, v][[3]] . field[r, u, v],\n  assumptions]', ()),
    ('gsu', 'FullSimplify[basis[r, u, v][[1]] . basis[r, u, v][[2]],\n  assumptions]', ()),
    ('gsv', 'FullSimplify[basis[r, u, v][[1]] . basis[r, u, v][[3]],\n  assumptions]', ()),
    ('gradS', 'duals[r, u, v][[1]]', ()),
    ('gradTheta', 'duals[r, u, v][[2]]', ()),
    ('gradZeta', 'duals[r, u, v][[3]]', ()),
    ('fluxTslope', 'FullSimplify[jac[r, u, v] (gradZeta . field[r, u, v]),\n  assumptions]', ()),
    ('sigmaFirst', 'FullSimplify[(covariantV gsu - covariantU gsv)/\n    (jac[r, u, v] Sqrt[bmag2]), assumptions]', ()),
    ('fluxPslope', 'FullSimplify[jac[r, u, v] (gradTheta . field[r, u, v]),\n  assumptions]', ()),
    ('sigmaContra', 'FullSimplify[(fluxTslope (gradS . gradTheta) -\n    fluxPslope (gradS . gradZeta))/Sqrt[bmag2], assumptions]', ()),
    ('sigmaSecond', 'FullSimplify[-(bmag2 gsu - covariantU covariantS)/\n    (fluxTslope Sqrt[bmag2]), assumptions]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-gvec-stability/sigma_tilde_recovery.wl')
