"""Generated SymPy translation of ``corpus/proj-cpp-derivation/gc_drift.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 39 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('$Assumptions', 'R0 > 0 && r > 0 && r < R0 && B0 > 0 && iota0 > 0 && r0a > 0 &&', ()),
    ('pass', '0', ()),
    ('fail', '0', ()),
    ('check', 'Module[{cc = TrueQ[Simplify[cond]]},\n  If[cc, pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]]; cc]', ('name', 'cond')),
    ('checkZero', 'Module[{cc = TrueQ[And @@ (PossibleZeroQ /@ Flatten[{Simplify[expr]}])]},\n  If[cc, pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]]; cc]', ('name', 'expr')),
    ('zeroExprQ', 'And @@ (PossibleZeroQ /@ Flatten[{Simplify[expr]}])', ('expr',)),
    ('coord', '{r, th, ph}', ()),
    ('Rr', 'R0 + r Cos[th]', ()),
    ('gTok', 'DiagonalMatrix[{1, r^2, Rr^2}]', ()),
    ('gInv', 'Inverse[gTok]', ()),
    ('sqrtg', 'Sqrt[Det[gTok]]', ()),
    ('Ath', 'B0 (r^2/2 - r^3 Cos[th]/(3 R0))', ()),
    ('Aph', '-B0 iota0 (r^2/2 - r^4/(4 r0a^2))', ()),
    ('Acov', '{0, Ath, Aph}', ()),
    ('levi', 'LeviCivitaTensor[3]', ()),
    ('curl', 'Table[(1/sqrtg) Sum[levi[[i, j, k]] D[acov[[k]], coord[[j]]], {j, 3}, {k, 3}], {i, 3}]', ('acov',)),
    ('cross', 'Table[(1/sqrtg) Sum[levi[[k, i, j]] acov[[i]] bcov[[j]], {i, 3}, {j, 3}], {k, 3}]', ('acov', 'bcov')),
    ('Bctr', 'curl[Acov]', ()),
    ('Bcov', 'gTok . Bctr', ()),
    ('Bmag2', 'Simplify[Bctr . gTok . Bctr]', ()),
    ('Bmod', 'Sqrt[Bmag2]', ()),
    ('hcov', 'Bcov/Bmod', ()),
    ('hctr', 'Bctr/Bmod', ()),
    ('Wcl', '(D[Aph, r])^2/Rr^2 + (D[Ath, r])^2/r^2', ()),
    ('wStrict', 'm vpar hcov', ()),
    ('vStrict', 'Simplify[(1/m) gInv . wStrict]', ()),
    ('vparStrict', 'Simplify[hcov . vStrict]', ()),
    ('vPerpStrict', 'Simplify[vStrict - vparStrict hctr]', ()),
    ('kc', 'eps m c/q', ()),
    ('Astar', 'Acov + kc vpar hcov', ()),
    ('Bstar', 'curl[Astar]', ()),
    ('curlh', 'curl[hcov]', ()),
    ('BstarPar', 'Simplify[hcov . Bstar]', ()),
    ('gradBmod', 'Table[D[Bmod, coord[[k]]], {k, 3}]', ()),
    ('vGradB', 'Simplify[(eps mu c/q)/Bmod cross[hcov, gradBmod]]', ()),
    ('vParallelPart', 'vpar Bstar/BstarPar', ()),
    ('vCurv', 'Simplify[eps Coefficient[Series[vParallelPart, {eps, 0, 1}] // Normal, eps, 1]]', ()),
    ('vGC', '(1/BstarPar) (vpar Bstar + (eps mu c/q) cross[hcov, gradBmod])', ()),
    ('streaming', 'vpar hctr', ()),
    ('vGC0', 'Simplify[(vGC /. eps -> 0)]', ()),
    ('vGCser', 'Series[vGC, {eps, 0, 1}] // Normal', ()),
    ('firstCoeff', 'Table[Coefficient[vGCser[[k]], eps, 1], {k, 3}]', ()),
    ('driftCoeff', 'Table[Coefficient[(vGradB + vCurv)[[k]], eps, 1], {k, 3}]', ()),
    ('remainder', 'vGC - (streaming + vGradB + vCurv)', ()),
    ('remEps1', 'Table[Coefficient[Series[remainder[[k]], {eps, 0, 1}] // Normal, eps, 1], {k, 3}]', ()),
    ('remEps0', 'Table[Normal[Series[remainder[[k]], {eps, 0, 0}]] /. eps -> 0, {k, 3}]', ()),
    ('vPerpGC', 'vGC - (hcov . vGC) hctr', ()),
    ('vPerpGC0', 'Simplify[(vPerpGC /. eps -> 0)]', ()),
    ('chr', 'Table[(1/2) Sum[gInv[[i, l]] (D[gTok[[l, j]], coord[[k]]]\n        + D[gTok[[l, k]], coord[[j]]] - D[gTok[[j, k]], coord[[l]]]), {l, 3}],\n   {i, 3}, {j, 3}, {k, 3}]', ()),
    ('nablaH', 'Table[D[hcov[[j]], coord[[i]]] - Sum[chr[[l, i, j]] hcov[[l]], {l, 3}], {i, 3}, {j, 3}]', ()),
    ('kappaCov', 'Table[Sum[hctr[[i]] nablaH[[i, j]], {i, 3}], {j, 3}]', ()),
    ('vGradBalt', '(eps mu c/q)/Bmod cross[hcov, gradBmod]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-cpp-derivation/gc_drift.wl')
