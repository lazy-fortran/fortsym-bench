"""Generated SymPy translation of ``corpus/proj-gvec-stability/mishka_global_pencil.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 24 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('pass', '0', ()),
    ('fail', '0', ()),
    ('check', 'If[TrueQ[FullSimplify[condition]],\n  pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]]', ('name', 'condition')),
    ('cubic', '{3 s^2 - 2 s^3, 3 (1 - s)^2 - 2 (1 - s)^3,\n  (s - 1) s^2, s (1 - s)^2}', ('s',)),
    ('quadratic', '{4 s (1 - s), 0,\n  2 (s - 1/2) s, 2 (s - 1/2) (s - 1)}', ('s',)),
    ('scatter', '{{1, 1}, {0, 1}, {1, 2}, {0, 2}}', ()),
    ('modes', '{0, 1, 2}', ()),
    ('axisFlags', '{1, Boole[Abs[m] > 11/10], 1,\n  Boole[Abs[m] > 11/10]}', ('m',)),
    ('axisConstraintCount', 'Total[Flatten[axisFlags /@ modes]]', ()),
    ('edgeConstraintCount', 'Length[modes]', ()),
    ('p', '{{1, 0, 0}, {0, 0, 0}, {0, 1, 0}, {0, 0, 1}}', ()),
    ('a', '{{3, 1 + I, 0, 2}, {1 - I, 5, I, 0}, {0, -I, 4, -1},\n  {2, 0, -1, 6}}', ()),
    ('b', '{{4, 1, 0, 0}, {1, 3, 0, 0}, {0, 0, 2, I/2},\n  {0, 0, -I/2, 2}}', ()),
    ('y', 'Array[yy, 3]', ()),
    ('raw', 'Array[z, {4, 4}]', ()),
    ('hermitianProjection', '(raw + ConjugateTranspose[raw])/2', ()),
    ('exactHermitian', '{{d1, u}, {Conjugate[u], d2}}', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-gvec-stability/mishka_global_pencil.wl')
