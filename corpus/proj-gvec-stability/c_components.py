"""Generated SymPy translation of ``corpus/proj-gvec-stability/c_components.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 6 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('pass', '0', ()),
    ('fail', '0', ()),
    ('assumptions', '{r > 0, len > 0, bz[r] > 0, btheta[r] > 0,\n  btheta[r]^2 + bz[r]^2 > 0, 0 < u < 1/4, 0 < v < 1}', ()),
    ('check', 'If[\n  TrueQ[FullSimplify[condition, assumptions]],\n  pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]]', ('name', 'condition')),
    ('position', '{r Cos[2 Pi u], r Sin[2 Pi u], len v}', ('r', 'u', 'v')),
    ('basis', '{D[position[r, u, v], r], D[position[r, u, v], u],\n  D[position[r, u, v], v]}', ('r', 'u', 'v')),
    ('jac', 'basis[r, u, v][[1]] .\n  Cross[basis[r, u, v][[2]], basis[r, u, v][[3]]]', ('r', 'u', 'v')),
    ('duals', 'Module[{b = basis[r, u, v]},\n  {Cross[b[[2]], b[[3]]], Cross[b[[3]], b[[1]]],\n    Cross[b[[1]], b[[2]]]}/jac[r, u, v]]', ('r', 'u', 'v')),
    ('field', 'btheta[r] {-Sin[2 Pi u], Cos[2 Pi u], 0} +\n  bz[r] {0, 0, 1}', ('r', 'u', 'v')),
    ('bmag', 'Sqrt[btheta[r]^2 + bz[r]^2]', ()),
    ('current', 'Module[{x, y, z, bCart},\n  bCart = btheta[Sqrt[x^2 + y^2]] {-y, x, 0}/Sqrt[x^2 + y^2] +\n    bz[Sqrt[x^2 + y^2]] {0, 0, 1};\n  Curl[bCart, {x, y, z}] /.\n    {x -> position[r, u, v][[1]], y -> position[r, u, v][[2]],\n      z -> position[r, u, v][[3]]}]', ('r', 'u', 'v')),
    ('displacement', 'xs[rr, uu, vv] duals[rr, uu, vv][[1]]/\n    (duals[rr, uu, vv][[1]] . duals[rr, uu, vv][[1]]) +\n  xu[rr, uu, vv] basis[rr, uu, vv][[2]] +\n  xv[rr, uu, vv] basis[rr, uu, vv][[3]]', ('rr', 'uu', 'vv')),
    ('cVector', 'Sum[Cross[duals[r, u, v][[i]],\n    D[Cross[displacement[rr, uu, vv], field[rr, uu, vv]],\n      {{rr, uu, vv}[[i]]}] /. {rr -> r, uu -> u, vv -> v}], {i, 3}] +\n  Cross[current[r, u, v], duals[r, u, v][[1]]] xs[r, u, v]/\n    (duals[r, u, v][[1]] . duals[r, u, v][[1]])', ()),
    ('gradS', 'duals[r, u, v][[1]]', ()),
    ('gradSmag', '1', ()),
    ('e1', 'gradS', ()),
    ('e3', 'field[r, u, v]/bmag', ()),
    ('e2', 'Cross[e1, e3]', ()),
    ('sqg', 'jac[r, u, v]', ()),
    ('fluxT', '2 Pi rr bz[rr]', ('rr',)),
    ('fluxP', 'len btheta[rr]', ('rr',)),
    ('currentI', 'len bz[rr]', ('rr',)),
    ('currentJ', '2 Pi rr btheta[rr]', ('rr',)),
    ('eta', 'fluxT[rr] xu[rr, uu, vv] - fluxP[rr] xv[rr, uu, vv]', ('rr', 'uu', 'vv')),
    ('bGrad', '(fluxP[r] (D[f /. u -> uu, uu] /. uu -> u) +\n    fluxT[r] (D[f /. v -> vv, vv] /. vv -> v))/sqg', ('f',)),
    ('pressureSlope', '-(btheta[r] (D[s btheta[s], s] /. s -> r)/r) -\n  bz[r] Derivative[1][bz][r]', ()),
    ('jDotB', 'FullSimplify[current[r, u, v] . field[r, u, v], assumptions]', ()),
    ('cOneFormula', 'bGrad[xs[r, u, v]]/gradSmag', ()),
    ('cTwoFormula', "-(gradSmag/(bmag sqg)) (sqg bGrad[eta[r, u, v]] -\n    (fluxT[r] fluxP'[r] - fluxT'[r] fluxP[r]) xs[r, u, v] +\n    jDotB sqg xs[r, u, v]/gradSmag^2)", ()),
    ('cThreeFormula', "(1/(bmag sqg)) (currentJ[r] (D[eta[r, u, vv], vv] /.\n      vv -> v) - currentI[r] (D[eta[r, uu, v], uu] /. uu -> u) +\n    (fluxT[r] currentI[r] + fluxP[r] currentJ[r]) (-(D[xs[rr, u, v],\n      rr] /. rr -> r)) -\n    (currentJ[r] fluxP'[r] + currentI[r] fluxT'[r]) xs[r, u, v] -\n    pressureSlope sqg xs[r, u, v])", ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-gvec-stability/c_components.wl')
