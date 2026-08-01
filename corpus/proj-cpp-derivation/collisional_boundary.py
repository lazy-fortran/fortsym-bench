"""Generated SymPy translation of ``corpus/proj-cpp-derivation/collisional_boundary.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 45 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('pass', '0', ()),
    ('fail', '0', ()),
    ('check', 'Module[{c = TrueQ[cond]},\n  If[c, pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]]; c]', ('name', 'cond')),
    ('nu', 'Symbol["nu"]', ()),
    ('Lpitch', '(1/2) D[(1 - xi^2) D[f[xi], xi], xi]', ('f', 'xi')),
    ('tauStall', '3', ()),
    ('nuEffOf', 'nuv', ('nuv',)),
    ('pStall', 'Exp[-nuEffOf[nuv] tauStall]', ('nuv',)),
    ('nuScan', 'Table[nv, {nv, 1/100, 2, 1/100}]', ()),
    ('pVals', 'pStall /@ nuScan', ()),
    ('nuAlpha', '1/10000', ()),
    ('nuHelp', '1/tauStall', ()),
    ('omegaB', '1', ()),
    ('DeltaLambda', 'Sqrt[nuv/omegaB]', ('nuv',)),
    ('dlVals', 'DeltaLambda /@ nuScan', ()),
    ('nuLog', 'Table[10^k, {k, -6, -1, 1/2}]', ()),
    ('slope', 'Module[{lx = Log[nuLog], ly = Log[DeltaLambda /@ nuLog], fit},\n  fit = Fit[Transpose[{lx, ly}], {1, t}, t]; Coefficient[fit, t]]', ()),
    ('epsT', '1/20', ()),
    ('nuEffLayer', 'nuv/epsT', ('nuv',)),
    ('epsRho', '1/40', ()),
    ('dMuPerCross', 'epsRho', ()),
    ('Dmu', 'dMuPerCross^2 nuEffLayer[nuv]', ('nuv',)),
    ('resonanceStands', '(Limit[pStall[nuv], nuv -> 0] == 1)', ()),
    ('layerSurvives', '(Simplify[Dmu[nuv]/nuEffLayer[nuv]] === epsRho^2) && epsRho^2 > 0', ()),
    ('diffAtZero', '(Dmu[0] == 0)', ()),
    ('diffNearZero', '(Dmu[nuAlpha] > 0)', ()),
    ('decoherenceHelp', '1 - pStall[nuv]', ('nuv',)),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-cpp-derivation/collisional_boundary.wl')
