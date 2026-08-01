"""Generated SymPy translation of ``corpus/proj-stellopt-talk/14_gauss_newton.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 11 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('failed', '0', ()),
    ('vars', '{x1, x2}', ()),
    ('r', '{x1 - 1, x2 - 2, x1 x2 - 3}', ()),
    ('jac', 'D[r, {vars}]', ()),
    ('g', 'Transpose[jac] . jac', ()),
    ('f', 'r . r/2', ()),
    ('hessF', 'D[f, {vars, 2}]', ()),
    ('secondOrder', 'Sum[r[[i]] D[r[[i]], {vars, 2}], {i, Length[r]}]', ()),
    ('dx', 'Simplify[-Inverse[g] . Transpose[jac] . r]', ()),
    ('dvec', '{d1, d2}', ()),
    ('statSol', 'Solve[Thread[Transpose[jac] . (r + jac . dvec) == {0, 0}], dvec]', ()),
    ('dstar', 'Simplify[dvec /. First[statSol]]', ()),
    ('a', '{{1, 2}, {3, 4}, {5, 6}}', ()),
    ('b', '{1, 1, 1}', ()),
    ('rLin', 'a . x - b', ('x',)),
    ('gLin', 'Transpose[a] . a', ()),
    ('gnStep', 'x - Inverse[gLin] . Transpose[a] . rLin[x]', ('x',)),
    ('xls', 'Inverse[gLin] . Transpose[a] . b', ()),
    ('x0', '{7, -5}', ()),
    ('x1n', 'gnStep[x0]', ()),
    ('xsym', 'gnStep[{s1, s2}]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-stellopt-talk/14_gauss_newton.wl')
