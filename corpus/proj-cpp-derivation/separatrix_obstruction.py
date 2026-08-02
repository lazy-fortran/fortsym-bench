"""Generated SymPy translation of ``corpus/proj-cpp-derivation/separatrix_obstruction.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 87 non-assignment statement(s) remain.
COMPARE = {
    'cLower': 'numeric',
    'corrTlog': 'numeric',
    'lnInvE': 'numeric',
}
_ASSIGNMENTS = [
    ('pass', '0', ()),
    ('fail', '0', ()),
    ('check', 'Module[{c = TrueQ[cond]},\n  If[c, pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]]; c]', ('name', 'cond')),
    ('Vpot', '-lam (1 + Cos[q])', ('q', 'lam')),
    ('hFast', 'p^2/2 + Vpot[q, lam]', ('q', 'p', 'lam')),
    ('Esep', '0', ()),
    ('qturn', 'ArcCos[-(E/lam) - 1]', ('E', 'lam')),
    ('Jtrap', '(1/Pi) NIntegrate[\n   Sqrt[2 (E + lam (1 + Cos[q]))], {q, 0, qturn[E, lam]},\n   Method -> "GaussKronrod", MaxRecursion -> 30]', ('E', 'lam')),
    ('Jpass', '(1/(2 Pi)) NIntegrate[\n   Sqrt[2 (E + lam (1 + Cos[q]))], {q, -Pi, Pi},\n   Method -> "GaussKronrod", MaxRecursion -> 30]', ('E', 'lam')),
    ('Ttrap', '2 NIntegrate[\n   1/Sqrt[2 (E + lam (1 + Cos[q]))], {q, 0, qturn[E, lam] (1 - 10.^-7)},\n   Method -> "GaussKronrod", MaxRecursion -> 40]', ('E', 'lam')),
    ('lam0', '1', ()),
    ('Edeep', '-3/2', ()),
    ('Enear', '-1/100', ()),
    ('Jdeep', 'Jtrap[Edeep, lam0]', ()),
    ('Jnear', 'Jtrap[Enear, lam0]', ()),
    ('JsepExact', '(1/Pi) Integrate[Sqrt[2 lam0 (1 + Cos[q])], {q, 0, Pi}]', ()),
    ('TdeepVal', 'Ttrap[Edeep, lam0]', ()),
    ('TharmDeep', '2 Pi/Sqrt[lam0]', ()),
    ('dJdlamDeep', '(Jtrap[Edeep, lam0 + 1/1000] - Jtrap[Edeep, lam0 - 1/1000])/(2/1000)', ()),
    ('deepWobble', 'eps Abs[dJdlamDeep] TdeepVal/(2 Pi)', ('eps',)),
    ('deepNetChange', 'Exp[-1/eps]', ('eps',)),
    ('Egrid', '-1/10^Range[1, 9]', ()),
    ('Tgrid', 'Ttrap[#, lam0] & /@ Egrid', ()),
    ('lnInvE', 'Log[1/Abs[N[Egrid]]]', ()),
    ('fitT', 'Fit[Transpose[{lnInvE, Tgrid}], {1, u}, u]', ()),
    ('slopeT', 'Coefficient[fitT, u]', ()),
    ('corrTlog', 'Correlation[N[lnInvE], N[Tgrid]]', ()),
    ('epsFix', '1/50', ()),
    ('adiabEstimate', 'epsFix Ttrap[E, lam0]/(2 Pi)', ('E',)),
    ('adiabGrid', 'adiabEstimate /@ Egrid', ()),
    ('ElayerEnergy', 'Exp[-2 Pi/(epsFix slopeT)]', ()),
    ('JsepOf', '(4/Pi) Sqrt[lam]', ('lam',)),
    ('dJsepdlam', 'D[JsepOf[lam], lam] /. lam -> lam0', ()),
    ('gPhase', '-(xi Log[xi] + (1 - xi) Log[1 - xi])', ('xi',)),
    ('DeltaJ', '(eps/(2 Pi)) dJsepdlam (Log[1/eps] + gPhase[xi])', ('eps', 'xi')),
    ('xiMid', '1/2', ()),
    ('epsList', '{1/20, 1/40, 1/80, 1/160}', ()),
    ('dJlist', 'DeltaJ[#, xiMid] & /@ epsList', ()),
    ('ratioToEps', 'dJlist/epsList', ()),
    ('expSmall', 'Exp[-1/(1/40)]', ()),
    ('xiScan', 'Range[1/100, 99/100, 1/100]', ()),
    ('gVals', 'gPhase /@ xiScan', ()),
    ('phaseSpread', '(Max[gVals] - Min[gVals]) (1/40)/(2 Pi) Abs[dJsepdlam]', ()),
    ('cLower', '(1/(2 Pi)) Abs[N[dJsepdlam]]', ()),
    ('minJumpOverPhase', 'Min[Abs[DeltaJ[eps, #] & /@ xiScan]]', ('eps',)),
    ('lowerBoundHolds', 'AllTrue[epsList,\n  minJumpOverPhase[#] >= cLower # Log[1/#] (1 - 1.*^-9) &]', ()),
    ('NN', '1', ()),
    ('chiTest', '100', ()),
    ('hypViolated', 'cLower eps Log[1/eps] > chiTest eps^(NN + 1)', ('eps',)),
    ('needRatio', 'chiTest eps^NN/cLower', ('eps',)),
    ('trueJump', 'DeltaJ[1/40, xiMid]', ()),
    ('projectedJump', '0', ()),
    ('projError', 'Abs[trueJump - projectedJump]', ()),
    ('crossingSteps', 'Ttrap[E, lam0]/dt', ('E', 'dt')),
    ('plainResonance', 'crossingSteps[Last[Egrid], 1/10] > crossingSteps[First[Egrid], 1/10] &&', ()),
    ('layerEdge', '-eps', ('eps',)),
    ('layerActionWidth', 'JsepExact - Jtrap[layerEdge[eps], lam0]', ('eps',)),
    ('epsLayer', '1/50', ()),
    ('w1', 'layerActionWidth[1/40]', ()),
    ('w2', 'layerActionWidth[1/80]', ()),
    ('w3', 'layerActionWidth[1/160]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-cpp-derivation/separatrix_obstruction.wl')
