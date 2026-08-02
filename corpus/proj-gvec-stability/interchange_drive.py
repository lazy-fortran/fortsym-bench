"""Generated SymPy translation of ``corpus/proj-gvec-stability/interchange_drive.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 6 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('pass', '0', ()),
    ('fail', '0', ()),
    ('assumptions', '{r > 0, len > 0, mu0 > 0, bz[r] > 0,\n  Element[{btheta[r], Derivative[1][btheta][r], Derivative[1][bz][r],\n    Derivative[2][btheta][r], Derivative[2][bz][r]}, Reals],\n  btheta[r]^2 + bz[r]^2 > 0}', ()),
    ('check', 'If[\n  TrueQ[FullSimplify[condition, assumptions]],\n  pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]]', ('name', 'condition')),
    ('position', '{r Cos[2 Pi u], r Sin[2 Pi u], len v}', ('r', 'u', 'v')),
    ('basis', '{D[position[r, u, v], r], D[position[r, u, v], u],\n  D[position[r, u, v], v]}', ('r', 'u', 'v')),
    ('jacobian', 'basis[r, u, v][[1]] .\n  Cross[basis[r, u, v][[2]], basis[r, u, v][[3]]]', ('r', 'u', 'v')),
    ('field', 'btheta[r] {-Sin[2 Pi u], Cos[2 Pi u], 0} +\n  bz[r] {0, 0, 1}', ('r', 'u', 'v')),
    ('gradS', 'Cross[basis[r, u, v][[2]], basis[r, u, v][[3]]]/\n  jacobian[r, u, v]', ('r', 'u', 'v')),
    ('current', 'Module[{x, y, z, bCart},\n  bCart = btheta[Sqrt[x^2 + y^2]] {-y, x, 0}/Sqrt[x^2 + y^2] +\n    bz[Sqrt[x^2 + y^2]] {0, 0, 1};\n  Curl[bCart, {x, y, z}]/mu0 /.\n    {x -> position[r, u, v][[1]], y -> position[r, u, v][[2]],\n      z -> position[r, u, v][[3]]}]', ('r', 'u', 'v')),
    ('bGradGradS', 'Module[{x, y, z, gradSCart, bCart},\n  gradSCart = {x, y, 0}/Sqrt[x^2 + y^2];\n  bCart = btheta[Sqrt[x^2 + y^2]] {-y, x, 0}/Sqrt[x^2 + y^2] +\n    bz[Sqrt[x^2 + y^2]] {0, 0, 1};\n  (bCart . {D[#, x], D[#, y], D[#, z]} & /@ gradSCart) /.\n    {x -> position[r, u, v][[1]], y -> position[r, u, v][[2]],\n      z -> position[r, u, v][[3]]}]', ('r', 'u', 'v')),
    ('simp', 'FullSimplify[expr,\n  Join[assumptions, {0 < u < 1/4, 0 < v < 1}]]', ('expr',)),
    ('gradSsquared', 'simp[gradS[r, u, v] . gradS[r, u, v]]', ()),
    ('driveA', 'simp[2/gradSsquared^2 *\n  Cross[current[r, u, v], gradS[r, u, v]] . bGradGradS[r, u, v]]', ()),
    ('pressureSlope', '-(btheta[r] D[s btheta[s], s]/(mu0 r) /. s -> r) -\n  bz[r] Derivative[1][bz][r]/mu0', ()),
    ('jSquared', 'simp[current[r, u, v] . current[r, u, v]]', ()),
    ('jDotB', 'simp[current[r, u, v] . field[r, u, v]]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-gvec-stability/interchange_drive.wl')
