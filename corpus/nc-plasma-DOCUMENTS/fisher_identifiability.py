"""Generated SymPy translation of ``corpus/nc-plasma-DOCUMENTS/fisher_identifiability.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 5 non-assignment statement(s) remain.
COMPARE = {
    'fisher': 'numeric',
}
_ASSIGNMENTS = [
    ('root', 'DirectoryName[DirectoryName[DirectoryName[$InputFileName]]]', ()),
    ('results', 'FileNameJoin[{root, "03_prestudies", "results"}]', ()),
    ('width', 'Exp[ell + alpha t]', ()),
    ('field', 'Tanh[(z - z0 - u t)/width]', ()),
    ('parameters', '{z0, u, ell, alpha}', ()),
    ('gradient', 'FullSimplify[D[field, #] & /@ parameters]', ()),
    ('truth', '{z0 -> 0.12, u -> 0.42, ell -> 0.0, alpha -> -0.24}', ()),
    ('times', 'Subdivide[-0.85, 0.85, 55]', ()),
    ('fisher', 'Module[{positions, rows, matrix, eigenvalues, condition},\n  positions = separation {-1.5, -0.5, 0.5, 1.5};\n  rows = Flatten[Table[N[gradient /. truth /. {z -> zz, t -> tt}],\n                       {zz, positions}, {tt, times}], 1];\n  matrix = Transpose[rows].rows;\n  eigenvalues = N[Eigenvalues[matrix]];\n  condition = If[Min[Abs[eigenvalues]] < 10^-12, -1.0,\n                 Max[Abs[eigenvalues]]/Min[Abs[eigenvalues]]];\n  <|"separation_over_L0" -> separation,\n    "rank" -> MatrixRank[matrix, Tolerance -> 10^-10],\n    "condition_number" -> condition,\n    "eigenvalues" -> eigenvalues|>\n  ]', ('separation',)),
    ('checks', 'fisher /@ {0.0, 0.05, 0.25, 0.75, 1.5}', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/nc-plasma-DOCUMENTS/fisher_identifiability.wl')
