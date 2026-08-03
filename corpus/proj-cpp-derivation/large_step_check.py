"""Generated SymPy translation of ``corpus/proj-cpp-derivation/large_step_check.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

import sympy as sp

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 43 non-assignment statement(s) remain.
COMPARE = {
    'Jred': 'numeric',
    'SqcAt': 'numeric',
    'hessFull': 'numeric',
    'sgS': 'equivalent',
    'slowThird': 'numeric',
}
_ASSIGNMENTS = [
    ('pass', '0', ()),
    ('fail', '0', ()),
    ('check', 'Module[{c = TrueQ[cond]},\n  If[c, pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]]; c]', ('name', 'cond')),
    ('checkZero', 'Module[{c = TrueQ[And @@ (PossibleZeroQ /@ Flatten[{Simplify[expr]}])]},\n  If[c, pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]]; c]', ('name', 'expr')),
    ('slope', '(Log[Abs[vals[[-1]]]] - Log[Abs[vals[[1]]]]) /\n                      (Log[eps[[-1]]] - Log[eps[[1]]])', ('vals', 'eps')),
    ('Jmat', 'ArrayFlatten[{{ConstantArray[0, {n, n}], IdentityMatrix[n]},\n                          {-IdentityMatrix[n], ConstantArray[0, {n, n}]}}]', ('n',)),
    ('R0', '3', ()),
    ('B0', '1', ()),
    ('iota0', '1', ()),
    ('r0a', '1', ()),
    ('mass', '1', ()),
    ('charge', '1', ()),
    ('cc', '1', ()),
    ('gT', 'DiagonalMatrix[{1, rr^2, (R0 + rr Cos[tth])^2}]', ('rr', 'tth')),
    ('AthF', 'B0 (rr^2/2 - rr^3 Cos[tth]/(3 R0))', ('rr', 'tth')),
    ('AphF', '-B0 iota0 (rr^2/2 - rr^4/(4 r0a^2))', ('rr', 'tth')),
    ('Acov', '{0, AthF[rr, tth], AphF[rr, tth]}', ('rr', 'tth')),
    ('sqrtg', 'Sqrt[Det[gT[rr, tth]]]', ('rr', 'tth')),
    # Spell out the three curl components.  The source uses a dynamic
    # derivative variable ({ra, ta, ph}[[j]]), which leaves SymPy's bounded
    # derivative lowering with an unevaluated placeholder.
    ('BctrF', '{D[AphF[rr, tth], tth], -D[AphF[rr, tth], rr], D[AthF[rr, tth], rr]}/sqrtg[rr, tth]', ('rr', 'tth')),
    ('BmodF', 'Sqrt[BctrF[rr, tth] . gT[rr, tth] . BctrF[rr, tth]]', ('rr', 'tth')),
    ('epsList', '{1/10, 1/20, 1/40, 1/80, 1/160}', ()),
    ('qcOf', 'charge/(cc eps)', ('eps',)),
    ('r0', '1/2', ()),
    ('th0', '7/10', ()),
    ('ph0', '1/5', ()),
    ('mu0', '1/10', ()),
    ('vpar0', '3/10', ()),
    ('HcppOf', 'Module[{gI, pc, qc = qcOf[eps]},\n  gI = Inverse[gT[r, th]];\n  pc = {p1, p2, p3} - qc Acov[r, th];\n  (1/(2 mass)) pc . gI . pc + mu0 BmodF[r, th]]', ('eps',)),
    ('pSample', '{3/100, 1/4, -2/5}', ()),
    ('zsym', '{r, th, ph, p1, p2, p3}', ()),
    ('opn', 'Max[SingularValueList[A]]', ('A',)),
    ('Hqc', '(1/(2 mass)) ({p1, p2, p3} - qc Acov[r, th]) . Inverse[gT[r, th]] .\n        ({p1, p2, p3} - qc Acov[r, th]) + mu0 BmodF[r, th]', ()),
    ('hess6', '{{D[expr, r, r], D[expr, r, th], D[expr, r, ph], D[expr, r, p1], D[expr, r, p2], D[expr, r, p3]},\n  {D[expr, th, r], D[expr, th, th], D[expr, th, ph], D[expr, th, p1], D[expr, th, p2], D[expr, th, p3]},\n  {D[expr, ph, r], D[expr, ph, th], D[expr, ph, ph], D[expr, ph, p1], D[expr, ph, p2], D[expr, ph, p3]},\n  {D[expr, p1, r], D[expr, p1, th], D[expr, p1, ph], D[expr, p1, p1], D[expr, p1, p2], D[expr, p1, p3]},\n  {D[expr, p2, r], D[expr, p2, th], D[expr, p2, ph], D[expr, p2, p1], D[expr, p2, p2], D[expr, p2, p3]},\n  {D[expr, p3, r], D[expr, p3, th], D[expr, p3, ph], D[expr, p3, p1], D[expr, p3, p2], D[expr, p3, p3]}}', ('expr',)),
    ('SqcSym', 'hess6[Hqc]', ()),
    ('SqcAt', 'N[SqcSym /. {r -> r0, th -> th0, ph -> ph0,\n   p1 -> pSample[[1]], p2 -> pSample[[2]], p3 -> pSample[[3]]}, 30]', ()),
    ('qqB', '{{SqcAt[[1, 1]], SqcAt[[1, 2]], SqcAt[[1, 3]]},\n  {SqcAt[[2, 1]], SqcAt[[2, 2]], SqcAt[[2, 3]]},\n  {SqcAt[[3, 1]], SqcAt[[3, 2]], SqcAt[[3, 3]]}}', ()),
    ('qpB', '{{SqcAt[[1, 4]], SqcAt[[1, 5]], SqcAt[[1, 6]]},\n  {SqcAt[[2, 4]], SqcAt[[2, 5]], SqcAt[[2, 6]]},\n  {SqcAt[[3, 4]], SqcAt[[3, 5]], SqcAt[[3, 6]]}}', ()),
    ('ppB', '{{SqcAt[[4, 4]], SqcAt[[4, 5]], SqcAt[[4, 6]]},\n  {SqcAt[[5, 4]], SqcAt[[5, 5]], SqcAt[[5, 6]]},\n  {SqcAt[[6, 4]], SqcAt[[6, 5]], SqcAt[[6, 6]]}}', ()),
    ('leadPow', 'Module[{ex = Exponent[#, qc] & /@ Flatten[blk],\n    co = Coefficient[#, qc, Exponent[#, qc]] & /@ Flatten[blk]},\n  Max[MapThread[If[Abs[#2] > 10^-12, #1, -Infinity] &, {ex, co}]]]', ('blk',)),
    ('qqLead', 'leadPow[qqB]', ()),
    ('qpLead', 'leadPow[qpB]', ()),
    ('ppLead', 'leadPow[ppB]', ()),
    ('hessFull', 'N[SqcAt /. qc -> qcOf[eps], 30]', ('eps',)),
    ('SfullList', 'hessFull /@ epsList', ()),
    ('J6', 'Jmat[3]', ()),
    ('LopNorms', 'opn[Inverse[J6] . #] & /@ SfullList', ()),
    ('sLfull', 'slope[LopNorms, epsList]', ()),
    ('wcOf', 'qcOf[eps] BmodF[r0, th0] / mass', ('eps',)),
    ('dtFull', '2/# & /@ LopNorms', ()),
    ('coord', '{r, th, ph}', ()),
    ('RrS', 'R0 + r Cos[th]', ()),
    ('gS', 'DiagonalMatrix[{1, r^2, RrS^2}]', ()),
    ('gIS', 'Inverse[gS]', ()),
    ('sgS', 'Sqrt[Det[gS]]', ()),
    ('AcS', '{0, AthF[r, th], AphF[r, th]}', ()),
    ('levi', 'LeviCivitaTensor[3]', ()),
    ('curl', '{D[ac[[3]], th] - D[ac[[2]], ph], D[ac[[1]], ph] - D[ac[[3]], r], D[ac[[2]], r] - D[ac[[1]], th]}/sgS', ('ac',)),
    ('cross', 'Table[(1/sgS) Sum[levi[[k, i, j]] ac[[i]] bc[[j]], {i, 3}, {j, 3}], {k, 3}]', ('ac', 'bc')),
    ('BctrS', 'curl[AcS]', ()),
    ('BcovS', 'gS . BctrS', ()),
    ('BmagS', 'Sqrt[Simplify[BctrS . gS . BctrS]]', ()),
    ('hcovS', 'BcovS/BmagS', ()),
    ('hctrS', 'BctrS/BmagS', ()),
    ('gradB', '{D[BmagS, r], D[BmagS, th], D[BmagS, ph]}', ()),
    ('kc', 'eps mass cc/charge', ()),
    ('Astar', 'AcS + kc vpar hcovS', ()),
    ('Bstar', 'curl[Astar]', ()),
    ('BstarPar', 'hcovS . Bstar', ()),
    ('vGC', '(1/BstarPar) (vpar Bstar + (eps mu0 cc/charge) cross[hcovS, gradB])', ()),
    ('vpardot', '-(mu0/mass) (hctrS . gradB)', ()),
    ('Xred', 'Join[vGC, {vpardot}]', ()),
    ('slowVars', '{r, th, ph, vpar}', ()),
    ('Jred', 'Module[{Jm},\n  Jm = Table[D[Xred[[i]], slowVars[[j]]], {i, 4}, {j, 4}];\n  N[Jm /. {r -> r0, th -> th0, ph -> ph0, vpar -> vpar0, eps -> ev}, 30]]', ('ev',)),
    ('JredLimit', 'Limit[Table[D[Xred[[i]], slowVars[[j]]], {i, 4}, {j, 4}] /.\n    {r -> r0, th -> th0, ph -> ph0, vpar -> vpar0}, eps -> 0]', ()),
    ('JredNorms', 'opn[Jred[#]] & /@ epsList', ()),
    ('invEps', '1/epsList', ()),
    ('wcCoeff', 'slope[JredNorms, epsList]', ()),
    ('dtRed', '2/# & /@ JredNorms', ()),
    ('ratio', 'MapThread[#1/#2 &, {dtRed, dtFull}]', ()),
    ('Ffun', 'a0 + a1 y + a2 y^2 + a3 y^3', ('y',)),
    ('yExactSer', 'y0 + Sum[(dt^k/k!) (yk[k] /. y -> y0), {k, 1, 4}]', ()),
    ('ysolSer', 'y0', ()),
    ('LTE', 'Simplify[Normal[Series[yExactSer - ysolSer, {dt, 0, 4}]]]', ()),
    ('lteCoeff3', 'Coefficient[LTE, dt, 3]', ()),
    ('lteCoeff1', 'Coefficient[LTE, dt, 1]', ()),
    ('lteCoeff2', 'Coefficient[LTE, dt, 2]', ()),
    ('slowThird', 'Module[{c3},\n  c3 = lteCoeff3 /. {a0 -> 1, a1 -> 1/2, a2 -> 1/3, a3 -> 1/5, y0 -> 1/4};\n  N[c3]]', ('ev',)),
    ('thirdVals', 'slowThird /@ epsList', ()),
    ('freeOfFast', 'FreeQ[lteCoeff3, qc] && FreeQ[lteCoeff3, wc] && FreeQ[lteCoeff3, eps]', ()),
    ('lteOverDt3', 'thirdVals', ()),
]

def results():
    values = evaluate_assignments(
        _ASSIGNMENTS, 'corpus/proj-cpp-derivation/large_step_check.wl'
    )

    # The source constructs the midpoint series by repeatedly substituting
    # the previous coefficients into
    #   Y = y0 + dt F((y0 + Y)/2).
    # The generic lowering cannot solve that coefficient recurrence, so its
    # placeholder ``ysolSer = y0`` makes all LTE coefficients wrong.  Rebuild
    # this small, source-faithful recurrence explicitly.
    a0, a1, a2, a3, y0, dt = sp.symbols("a0 a1 a2 a3 y0 dt")
    f = lambda y: a0 + a1 * y + a2 * y**2 + a3 * y**3
    coefficients = sp.symbols("c1:5")
    midpoint = y0 + sum(c * dt** power for power, c in enumerate(coefficients, 1))
    residual = sp.series(
        midpoint - (y0 + dt * f((y0 + midpoint) / 2)), dt, 0, 5
    ).removeO()
    solved = {}
    for power, coefficient in enumerate(coefficients, 1):
        solved[coefficient] = sp.solve(
            sp.expand(residual.subs(solved)).coeff(dt, power), coefficient
        )[0]
    midpoint = midpoint.subs(solved)

    exact = y0
    derivative = f(sp.Symbol("y"))
    y = sp.Symbol("y")
    for power in range(1, 5):
        exact += dt**power / sp.factorial(power) * derivative.subs(y, y0)
        derivative = sp.diff(derivative, y) * f(y)
    lte = sp.expand(exact - midpoint)
    slow_third = sp.N(
        lte.coeff(dt, 3).subs(
            {a0: 1, a1: sp.Rational(1, 2), a2: sp.Rational(1, 3),
             a3: sp.Rational(1, 5), y0: sp.Rational(1, 4)}
        )
    )
    values.update(
        {
            "ysolSer": midpoint,
            "LTE": lte,
            "lteCoeff1": lte.coeff(dt, 1),
            "lteCoeff2": lte.coeff(dt, 2),
            "lteCoeff3": lte.coeff(dt, 3),
            # The source maps slowThird over epsList after defining the
            # recurrence above.  Replace the generic function placeholder
            # with that source-faithful constant map.
            "thirdVals": tuple(slow_third for _ in range(5)),
            "lteOverDt3": tuple(slow_third for _ in range(5)),
        }
    )
    return values
