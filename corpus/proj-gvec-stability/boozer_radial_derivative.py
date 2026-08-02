"""Generated SymPy translation of ``corpus/proj-gvec-stability/boozer_radial_derivative.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 12 non-assignment statement(s) remain.
COMPARE = {
    'at': 'numeric',
}
_ASSIGNMENTS = [
    ('pass', '0', ()),
    ('fail', '0', ()),
    ('check', 'If[\n  TrueQ[Simplify[condition]],\n  pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]]', ('name', 'condition')),
    ('r0', '7/2', ()),
    ('rr', '2/5', ()),
    ('uu', '3/10', ()),
    ('vv', '7/10', ()),
    ('iota', '2/5 + r^2/3', ('r',)),
    ('la', 'r^2/7 Sin[2 Pi (u - v)]', ('r', 'u', 'v')),
    ('nu', 'r^2/5 Sin[2 Pi (u - 2 v)] + r^3/11 Sin[2 Pi (-v)]', ('r', 'u', 'v')),
    ('position', 'Module[{R = r0 + r Cos[2 Pi u], phi = 2 Pi v},\n  {R Cos[phi], R Sin[phi], r Sin[2 Pi u]}]', ('r', 'u', 'v')),
    ('thetaB', 'u + la[r, u, v] + iota[r] nu[r, u, v]', ('r', 'u', 'v')),
    ('zetaB', 'v + nu[r, u, v]', ('r', 'u', 'v')),
    ('basis', '{D[position[r, u, v], r],\n  D[position[r, u, v], u], D[position[r, u, v], v]}', ('r', 'u', 'v')),
    ('jac', 'basis[r, u, v][[1]] .\n  Cross[basis[r, u, v][[2]], basis[r, u, v][[3]]]', ('r', 'u', 'v')),
    ('duals', 'Module[{b = basis[r, u, v]},\n  {Cross[b[[2]], b[[3]]], Cross[b[[3]], b[[1]]],\n    Cross[b[[1]], b[[2]]]}/jac[r, u, v]]', ('r', 'u', 'v')),
    ('gradScalar', 'Module[{d = duals[r, u, v]},\n  D[f[r, u, v], r] d[[1]] + D[f[r, u, v], u] d[[2]] +\n    D[f[r, u, v], v] d[[3]]]', ('f', 'r', 'u', 'v')),
    ('angleJacobian', '{{D[thetaB[r, u, v], u], D[thetaB[r, u, v], v]},\n   {D[zetaB[r, u, v], u], D[zetaB[r, u, v], v]}}', ('r', 'u', 'v')),
    ('angleInverse', 'Inverse[angleJacobian[r, u, v]]', ('r', 'u', 'v')),
    ('eThetaB', 'basis[r, u, v][[2]] angleInverse[r, u, v][[1, 1]] +\n  basis[r, u, v][[3]] angleInverse[r, u, v][[2, 1]]', ('r', 'u', 'v')),
    ('eZetaB', 'basis[r, u, v][[2]] angleInverse[r, u, v][[1, 2]] +\n  basis[r, u, v][[3]] angleInverse[r, u, v][[2, 2]]', ('r', 'u', 'v')),
    ('eRhoB', 'basis[r, u, v][[1]] -\n  (D[la[r, u, v], r] + Derivative[1][iota][r] nu[r, u, v] +\n    iota[r] D[nu[r, u, v], r]) eThetaB[r, u, v] -\n  D[nu[r, u, v], r] eZetaB[r, u, v]', ('r', 'u', 'v')),
    ('at', 'N[expr /. {r -> rr, u -> uu, v -> vv}, 30]', ('expr',)),
    ('close', 'Abs[a - b] < 10^-20', ('a', 'b')),
    ('gradRho', 'at[duals[r, u, v][[1]]]', ()),
    ('gradThetaB', 'at[gradScalar[thetaB, r, u, v]]', ()),
    ('gradZetaB', 'at[gradScalar[zetaB, r, u, v]]', ()),
    ('erb', 'at[eRhoB[r, u, v]]', ()),
    ('etb', 'at[eThetaB[r, u, v]]', ()),
    ('ezb', 'at[eZetaB[r, u, v]]', ()),
    ('mixedU', 'D[nu[r, u, v], r, u]', ()),
    ('mixedV', 'D[nu[r, u, v], r, v]', ()),
    ('projectCos', 'Integrate[Integrate[\n  2 f Cos[2 Pi (m u - n v)], {u, 0, 1}], {v, 0, 1}]', ('f', 'm', 'n')),
    ('projectSin', 'Integrate[Integrate[\n  2 f Sin[2 Pi (m u - n v)], {u, 0, 1}], {v, 0, 1}]', ('f', 'm', 'n')),
    ('slopeCoefficient', 'If[m != 0,\n  projectCos[mixedU, m, n]/(2 Pi m),\n  -projectCos[mixedV, m, n]/(2 Pi n)]', ('m', 'n')),
    ('harmonics', '{{1, 2}, {0, 1}}', ()),
    ('recovered', 'Sum[slopeCoefficient[h[[1]], h[[2]]] Sin[\n    2 Pi (h[[1]] u - h[[2]] v)], {h, harmonics}]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-gvec-stability/boozer_radial_derivative.wl')
