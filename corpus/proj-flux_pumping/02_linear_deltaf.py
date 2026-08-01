"""Generated SymPy translation of ``corpus/proj-flux_pumping/02_linear_deltaf.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 10 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('f0', 'n[r] (me/(2 Pi T[r]))^(3/2) Exp[-(w - ee Phi0[r])/T[r]]', ('r', 'w')),
    ('df0dr', 'D[f0[r, w], r]', ()),
    ('A1', "n'[r]/n[r] + ee Phi0'[r]/T[r] - 3/2 T'[r]/T[r]", ()),
    ('A2', "T'[r]/T[r]", ()),
    ('rhsForces', 'f0[r, w] (A1 + (me v^2/(2 T[r])) A2) /. w -> me v^2/2 + ee Phi0[r]', ()),
    ('vErm', '-(I c kperp/B0) Phim', ('Phim',)),
    ('PhimA', 'I hrm Phi0p/kpar', ()),
    ('vE0', 'c Phi0p/B0', ()),
    ('CA', 'CAsym /. First@Solve[\n  I (kpar vpar + kperp vE0) CAsym == -(hrm/kpar) (kpar vpar + kperp vE0),\n  CAsym]', ()),
    ('EperpmMA', '-I kperp PhimMA', ()),
    ('lhsMA', '-vErm[PhimMA] (df0dr /. w -> me v^2/2 + ee Phi0[r])', ()),
    ('rhsMemo', '(c f0[r, me v^2/2 + ee Phi0[r]] EperpmMA/B0) (A1 + (me v^2/(2 T[r])) A2)', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-flux_pumping/02_linear_deltaf.wl')
