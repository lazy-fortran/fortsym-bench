"""Generated SymPy translation of ``corpus/proj-gvec-stability/mode_family_selection.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 13 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('pass', '0', ()),
    ('fail', '0', ()),
    ('check', 'If[TrueQ[condition],\n  pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]]', ('name', 'condition')),
    ('familyOf', 'Union[Mod[{seed, -seed}, nt]]', ('nt', 'seed')),
    ('families', 'DeleteDuplicates[\n  Table[familyOf[nt, seed], {seed, 1, nt - 1}]]', ('nt',)),
    ('formFunction', 's^(m/2) (1 - s)', ('m', 's')),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-gvec-stability/mode_family_selection.wl')
