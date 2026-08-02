"""Generated SymPy translation of ``corpus/proj-flux_pumping/02_linear_deltaf.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 10 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('f0', 'n[r] (me/(2 Pi T[r]))^(3/2) Exp[-(w - ee Phi0[r])/T[r]]', ('r', 'w')),
    # Keep the fixed-w derivative in the source's explicit form.  The shared
    # translator cannot lower Wolfram prime notation (n'[r], T'[r], ...),
    # while the native backend serializes these source derivatives as
    # Derivative1 heads.
    ('df0dr', '''-me*Derivative1[T, 1, r]*Exp[-(w - ee*Phi0[r])/T[r]]*n[r]*(me*1/2/Pi/T[r])^(1/2)*3/4/Pi/T[r]^2 +
Derivative1[n, 1, r]*Exp[-(w - ee*Phi0[r])/T[r]]*(me*1/2/Pi/T[r])^(3/2) +
Exp[-(w - ee*Phi0[r])/T[r]]*n[r]*(me*1/2/Pi/T[r])^(3/2)*(ee*Derivative1[Phi0, 1, r]/T[r] +
  Derivative1[T, 1, r]*(w - ee*Phi0[r])/T[r]^2)''', ()),
    ('A1', 'ee*Derivative1[Phi0, 1, r]/T[r] - Derivative1[T, 1, r]*3/2/T[r] + Derivative1[n, 1, r]/n[r]', ()),
    ('A2', 'Derivative1[T, 1, r]/T[r]', ()),
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
