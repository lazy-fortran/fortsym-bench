"""Generated SymPy translation of ``corpus/code-paper_magnetic/levicivita.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 11 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('ELevi', '{{0, 1/J}, {-J^(-1), 0}}', ()),
    ('nu', '{{nuxx, nuxy}, {nuyx, nuyy}}', ()),
    ('Jmat', 'D[{R*Cos[φ], R*Sin[φ], Z}, {{Z, R, φ}}]', ()),
    ('Jinv', 'FullSimplify[D[{z, Sqrt[x^2 + y^2], ArcTan[y/x]}, {{x, y, z}}]]', ()),
    ('Jxyz', 'FullSimplify[Inverse[Jinv]]', ()),
    ('nuzrp', '{{nuzz, nuzr, 0}, {nurz, nurr, 0}, {0, 0, nupp*(x^2 + y^2)}}', ()),
    ('nuxyz', '{{0, 0, 0}, {0, 0, 0}, {0, 0, 0}}', ()),
    ('muzrp', '{{20, 8/10, 0}, {-8/10, 40, 0}, {0, 0, 50/(x^2 + y^2)}}', ()),
    ('muzrp2', '{{muzz, muzr, 0}, {murz, murr, 0}, {0, 0, mupp/(x^2 + y^2)}}', ()),
    ('muxyz', '{{0, 0, 0}, {0, 0, 0}, {0, 0, 0}}', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/code-paper_magnetic/levicivita.wl')
