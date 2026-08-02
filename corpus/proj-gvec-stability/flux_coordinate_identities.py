"""Generated SymPy translation of ``corpus/proj-gvec-stability/flux_coordinate_identities.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 19 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('pass', '0', ()),
    ('fail', '0', ()),
    ('check', 'If[TrueQ[FullSimplify[condition]],\n  pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]]', ('name', 'condition')),
    ('position', '{r Cos[2 Pi u], r Sin[2 Pi u], len v}', ('r', 'u', 'v')),
    ('basis', '{\n  D[position[r, u, v], r],\n  D[position[r, u, v], u],\n  D[position[r, u, v], v]}', ('r', 'u', 'v')),
    ('jacobian', 'basis[r, u, v][[1]] .\n  Cross[basis[r, u, v][[2]], basis[r, u, v][[3]]]', ('r', 'u', 'v')),
    ('field', 'btheta[r] {-Sin[2 Pi u], Cos[2 Pi u], 0} +\n  bz[r] {0, 0, 1}', ('r', 'u', 'v')),
    ('toroidalFlux', 'Integrate[2 Pi rho bz[rho], {rho, 0, r},\n  Assumptions -> 0 < r]', ('r',)),
    ('poloidalFlux', 'Integrate[len btheta[rho], {rho, 0, r},\n  Assumptions -> 0 < r]', ('r',)),
    ('currentJ', '2 Pi r btheta[r]', ('r',)),
    ('currentI', 'len bz[r]', ('r',)),
    ('contravariant', 'Module[{b = basis[r, u, v], jac},\n  jac = jacobian[r, u, v];\n  {Cross[b[[2]], b[[3]]], Cross[b[[3]], b[[1]]],\n      Cross[b[[1]], b[[2]]]}/jac]', ('r', 'u', 'v')),
    ('covariantB', 'basis[r, u, v] . field[r, u, v]', ('r', 'u', 'v')),
    ('contravariantB', 'contravariant[r, u, v] . field[r, u, v]', ('r', 'u', 'v')),
    ('iota', "poloidalFlux'[r]/toroidalFlux'[r]", ('r',)),
    ('testFunction', 'f[r, u, v]', ('r', 'u', 'v')),
    ('gradTest', 'Transpose[contravariant[r, u, v]] . {\n  D[testFunction[r, u, v], r],\n  D[testFunction[r, u, v], u],\n  D[testFunction[r, u, v], v]}', ('r', 'u', 'v')),
    ('gradR', 'contravariant[r, u, v][[1]]', ('r', 'u', 'v')),
    ('currentDensity', 'Module[{x, y, z, bCart},\n  bCart = btheta[Sqrt[x^2 + y^2]] {-y, x, 0}/Sqrt[x^2 + y^2] +\n    bz[Sqrt[x^2 + y^2]] {0, 0, 1};\n  Curl[bCart, {x, y, z}]/mu0 /.\n    {x -> position[r, u, v][[1]], y -> position[r, u, v][[2]],\n      z -> position[r, u, v][[3]]}]', ('r', 'u', 'v')),
    ('contravariantCurrent', 'contravariant[r, u, v] . currentDensity[r, u, v]', ('r', 'u', 'v')),
    ('simplifyAssuming', 'FullSimplify[expr,\n  {0 < r, 0 < u < 1, 0 < v < 1, Cos[2 Pi u] != 0}]', ('expr',)),
    ('forceBalanceP', "-btheta[r] D[rho btheta[rho], rho]/(mu0 r) -\n    bz[r] bz'[r]/mu0 /. rho -> r", ('r',)),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-gvec-stability/flux_coordinate_identities.wl')
