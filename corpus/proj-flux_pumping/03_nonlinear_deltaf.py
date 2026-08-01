"""Generated SymPy translation of ``corpus/proj-flux_pumping/03_nonlinear_deltaf.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 8 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('rhomSol', 'rhomvar /. First@Solve[hrm + I kpar rhomvar == 0, rhomvar]', ()),
    ('PhimA', 'I hrm Phi0p/kpar', ()),
    ('CA', 'I hrm/kpar', ()),
    ('rhomMemo', '-I hrm/kpar', ()),
    ('CAMemo', '-I hrm/kpar', ()),
    ('S', 'm th + n ph', ()),
    ('op', 'vpar kpar + kperp vE0', ()),
    ('lhs', 'ComplexExpand[Re[I op fm Exp[I S]], TargetFunctions -> {Re, Im}]', ()),
    ('rhs', 'ComplexExpand[Re[op I fm Exp[I S]], TargetFunctions -> {Re, Im}]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-flux_pumping/03_nonlinear_deltaf.wl')
