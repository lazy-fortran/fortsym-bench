"""Generated SymPy translation of ``corpus/proj-cpp-derivation/midpoint_resonance.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 40 non-assignment statement(s) remain.
COMPARE = {
    'SatBad': 'numeric',
    'opGC': 'numeric',
    'pBad': 'numeric',
    'sig': 'numeric',
    'sigMin': 'numeric',
    'solvDet': 'numeric',
}
_ASSIGNMENTS = [
    ('pass', '0', ()),
    ('fail', '0', ()),
    ('check', 'Module[{c = TrueQ[cond]},\n  If[c, pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]]; c]', ('name', 'cond')),
    ('checkZero', 'Module[{c = TrueQ[And @@ (PossibleZeroQ /@ Flatten[{Simplify[expr]}])]},\n  If[c, pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]]; c]', ('name', 'expr')),
    ('J2', '{{0, 1}, {-1, 0}}', ()),
    ('Bwell', '1 + xx^2', ('xx',)),
    ('Bder', '2 xx', ('xx',)),
    ('B2der', '2', ()),
    ('mu', '1/2', ()),
    ('Bref', '1', ()),
    ('muFloor', '0', ()),
    ('Hfull', 'uu^2/2 + (1/(2 eps^2)) (Bwell[xx] qq^2 + pp^2)/Bref + muFloor', ('xx', 'qq', 'uu', 'pp', 'eps')),
    ('J4', '{{0, 0, 1, 0}, {0, 0, 0, 1}, {-1, 0, 0, 0}, {0, -1, 0, 0}}', ()),
    ('zsym', '{xx, qq, uu, pp}', ()),
    ('HessFull', 'Table[D[Hfull[xx, qq, uu, pp, eps], zsym[[i]], zsym[[j]]], {i, 4}, {j, 4}] /.\n    {xx -> x0, qq -> q0, uu -> u0, pp -> p0}', ('x0', 'q0', 'u0', 'p0', 'eps')),
    ('Lop', '(dt/2) Inverse[J4] . S', ('S', 'dt')),
    ('solvMat', 'IdentityMatrix[4] - Lop[S, dt]', ('S', 'dt')),
    ('solvDet', 'Det[N[solvMat[HessFull[x0, q0, u0, p0, eps], dt]]]', ('x0', 'q0', 'u0', 'p0', 'dt', 'eps')),
    ('epsT', '1/40', ()),
    ('OmOf', 'Sqrt[Bwell[xx]/Bref]/eps', ('xx', 'eps')),
    ('dtScan', 'Table[d, {d, 1/20, 30/20, 1/400}]', ()),
    ('passDets', 'solvDet[3/10, 1/5, 1/2, 1/5, #, epsT] & /@ dtScan', ()),
    ('perpDet', 'Det[{{1, -(dt/2) om}, {(dt/2) om, 1}}]', ('dt', 'om')),
    ('xt', '7/10', ()),
    ('qt', '1/2', ()),
    ('pt', '1/2', ()),
    ('ut', '0', ()),
    ('trapDets', 'solvDet[xt, qt, ut, pt, #, epsT] & /@ dtScan', ()),
    ('signChanges', 'Count[Most[trapDets] Rest[trapDets], _?(# < 0 &)]', ()),
    ('nZero', 'signChanges', ()),
    ('zeroIdx', 'First[Flatten[Position[Most[trapDets] Rest[trapDets], _?(# < 0 &)]]]', ()),
    ('dtLo', 'dtScan[[zeroIdx]]', ()),
    ('dtHi', 'dtScan[[zeroIdx + 1]]', ()),
    ('sig', 'Min[Abs[SingularValueList[N[solvMat[HessFull[xt, qt, ut, pt, epsT], dt]]]]]', ('dt',)),
    ('badDt', 'dt /. Last[Quiet[NMinimize[{sig[dt], dtLo <= dt <= dtHi}, dt][[2]]]]', ()),
    ('SatBad', 'N[solvMat[HessFull[xt, qt, ut, pt, epsT], badDt]]', ()),
    ('sigMin', 'Min[Abs[SingularValueList[N[solvMat[HessFull[xt, qt, ut, pt, epsT], dt]]]]]', ('dt',)),
    ('Amp0', '1/2', ()),
    ('phiScan', 'Table[ph, {ph, 0, 2 Pi, 2 Pi/400}]', ()),
    ('dtFix', '12/10', ()),
    ('phaseDets', '(solvDet[xt, Amp0 Cos[#], ut, Amp0 Sin[#], dtFix, epsT] &) /@ phiScan', ()),
    ('phaseCross', 'Count[Most[phaseDets] Rest[phaseDets], _?(# < 0 &)]', ()),
    ('pBad', 'N[phaseCross/Length[phiScan]]', ()),
    ('lossRate', 'pBad/dt', ('dt',)),
    ('HessGC', '{{mu D[Bwell[x], x, x], 0}, {0, 1}} /. x -> 0', ()),
    ('JinvHessGC', 'Inverse[J2] . HessGC', ()),
    ('opGC', 'Max[SingularValueList[N[HessGC]]]', ()),
    ('dtGCmax', '2/opGC', ()),
    ('gcTrappedOK', 'Module[{ok = True, x0t = 7/10, dt},\n  Do[\n   Module[{u0 = uu0, sol, res},\n    sol = Quiet@FindRoot[\n       gcResidual[{xp, up}, {x0t, u0}, dtGCmax/2] == {0, 0},\n       {{xp, x0t}, {up, u0}}, MaxIterations -> 100];\n    res = gcResidual[{xp, up} /. sol, {x0t, u0}, dtGCmax/2];\n    If[Max[Abs[res]] > 1.*^-9, ok = False]],\n   {uu0, {0, 1/100, -1/100, 1/10}}];                                             \n  ok]', ()),
    ('gcNoResonance', 'Module[{flags},\n  flags = Table[\n    Module[{sol, res},\n     sol = Quiet@FindRoot[gcResidual[{xp, up}, {7/10, 0}, dt] == {0, 0},\n        {{xp, 7/10}, {up, 0}}, MaxIterations -> 100];\n     res = gcResidual[{xp, up} /. sol, {7/10, 0}, dt];\n     Max[Abs[res]] < 1.*^-8],\n    {dt, dtGCmax/20, 0.95 dtGCmax, dtGCmax/20}];\n  AllTrue[flags, TrueQ]]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-cpp-derivation/midpoint_resonance.wl')
