"""Generated SymPy translation of ``corpus/proj-stellopt-talk/11_bootstrap_offset.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 18 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('failed', '0', ()),
    ('termA', 'la/Sqrt[nu]', ()),
    ('termB', 'lb/nu', ()),
    ('offset', 'termA + termB', ()),
    ('lambdabB', 'lsc + offset', ()),
    ('serT', 'Normal[Series[offset /. nu -> 1/t^2, {t, 0, 2}]]', ()),
    ('file', '"/home/ert/proj/stellopt-talk/data/rabe/coeffs.txt"', ()),
    ('line', 'First[Select[Import[file, "Lines"], StringContainsQ[#, "nautilus libneo"] &]]', ()),
    ('lamN', 'lscN + caN/Sqrt[nuv] + cbN/nuv', ('nuv',)),
    ('offs', 'Table[Abs[lamN[10.^e] - lscN], {e, {-8, -6, -4, -2, 0}}]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-stellopt-talk/11_bootstrap_offset.wl')
