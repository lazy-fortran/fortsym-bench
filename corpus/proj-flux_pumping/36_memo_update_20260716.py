"""Generated SymPy translation of ``corpus/proj-flux_pumping/36_memo_update_20260716.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 66 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('b15New', '2^(2/3) Gamma[1/6] Gamma[1/3]/(3^(5/3) Sqrt[Pi])', ()),
    ('b15Ours', '2^(1/3) Gamma[1/3]^3/(3^(7/6) Pi)', ()),
    ('b15Old', '2^(11/3) Gamma[1/3]^2/(3^(8/3) Sqrt[Pi])', ()),
    ('gammaSixth', 'Sqrt[3] Gamma[1/3]^2/(2^(1/3) Sqrt[Pi])', ()),
    ('roundTrip', 'FullSimplify[\n  Integrate[Exp[I k y] forward[k], {k, -Infinity, Infinity}]/(2 Pi),\n  Element[y, Reals]]', ()),
    ('divCyl', 'D[r br0[r, m th + n ph], r]/r +\n  D[bth0[r, m th + n ph], th] + D[bph0[r, m th + n ph], ph]', ()),
    ('divHel', 'With[{s = r^2/2},\n  (D[(rr br0[rr, hp]) /. rr -> Sqrt[2 ss], ss] /. ss -> r^2/2 /. hp -> m th + n ph) +\n  (D[m bth0[r, hp] + n bph0[r, hp], hp] /. hp -> m th + n ph)]', ()),
    ('mNum', '1', ()),
    ('nNum', '1', ()),
    ('capRNum', '5', ()),
    ('kNum', 'nNum/capRNum', ()),
    ('iotaBackgroundExpr', '-3/4 + 3 x^2/100', ()),
    ('bz0Expr', '1', ()),
    ('btheta0Expr', 'iotaBackgroundExpr x/capRNum', ()),
    ('detExpr', 'FullSimplify[mNum btheta0Expr/x + kNum bz0Expr]', ()),
    ('uExpr', 'x^3/100', ()),
    ('sourceExpr', '(8 x/3 - kNum^2 x^3/5)/100', ()),
    ('fExpr', 'FullSimplify[(D[uExpr, x] - x sourceExpr)/mNum]', ()),
    ('gExpr', 'uExpr/x', ()),
    ('hExpr', 'kNum uExpr/mNum', ()),
    ('phaseExpr', 'FullSimplify[mNum gExpr/x + kNum hExpr]', ()),
    ('fV', 'fExpr /. x -> y', ('y',)),
    ('gV', 'gExpr /. x -> y', ('y',)),
    ('hV', 'hExpr /. x -> y', ('y',)),
    ('dV', 'detExpr /. x -> y', ('y',)),
    ('pV', 'phaseExpr /. x -> y', ('y',)),
    ('b0V', 'btheta0Expr /. x -> y', ('y',)),
    ('rhoCheck', '1', ()),
    ('ampCheck', '1/500', ()),
    ('quadValue', 'iotaQuad[rhoCheck, ampCheck]', ()),
    ('traceValue', 'iotaTrace[rhoCheck, ampCheck]', ()),
    ('deltaExpr', 'FullSimplify[fExpr/detExpr]', ()),
    ('gammaExpr', 'FullSimplify[deltaExpr D[deltaExpr, x] +\n  deltaExpr^2 (1 + x D[detExpr, x]/detExpr)/(2 x)]', ()),
    ('a0Expr', 'FullSimplify[bz0Expr/(capRNum detExpr)]', ()),
    ('a1Expr', 'FullSimplify[(hExpr detExpr - bz0Expr phaseExpr)/(capRNum detExpr^2)]', ()),
    ('a2Expr', 'FullSimplify[bz0Expr phaseExpr^2/(capRNum detExpr^3) -\n  hExpr phaseExpr/(capRNum detExpr^2)]', ()),
    ('hSeriesExpr', 'FullSimplify[gammaExpr D[a0Expr, x] +\n  deltaExpr^2 D[a0Expr, {x, 2}]/2 - deltaExpr D[a1Expr, x] + a2Expr]', ()),
    ('cHelicalExpr', 'FullSimplify[-hSeriesExpr/(2 mNum a0Expr^2)]', ()),
    ('bthetaMeanExpr', 'FullSimplify[sourceExpr deltaExpr/2]', ()),
    ('cMeanExpr', 'FullSimplify[capRNum bthetaMeanExpr/(x bz0Expr)]', ()),
    ('iotaZeroQuad', 'iotaQuad[rhoCheck, 0]', ()),
    ('iotaMinusQuad', 'iotaQuad[rhoCheck, -ampCheck]', ()),
    ('quadCoefficient', '(quadValue + iotaMinusQuad - 2 iotaZeroQuad)/(2 ampCheck^2)', ()),
    ('cHelicalValue', 'N[cHelicalExpr /. x -> rhoCheck, 20]', ()),
    ('cMeanValue', 'N[cMeanExpr /. x -> rhoCheck, 20]', ()),
    ('sExp', 's0 + eps u1 Cos[phi] + eps^2 (u20 + u22 Cos[2 phi])', ()),
    ('psiExp', 'Normal@Series[Psi0F[sExp] + eps Cos[phi] QQ[sExp], {eps, 0, 2}]', ()),
    ('ord1', 'Coefficient[psiExp - Psi0F[s0], eps, 1]', ()),
    ('u1Sol', 'u1 /. First@Solve[(ord1 /. Cos[phi] -> 1) == 0, u1]', ()),
    ('ord2', 'Coefficient[psiExp - Psi0F[s0], eps, 2] /. u1 -> u1Sol //\n  TrigReduce // Expand', ()),
    ('u20Sol', 'u20 /. First@Solve[Coefficient[ord2, Cos[2 phi], 0] == 0, u20]', ()),
    ('u22Sol', 'u22 /. First@Solve[Coefficient[ord2, Cos[2 phi], 1] == 0, u22]', ()),
    ('integrand', 'm (TT[sExp] + eps tt[sExp] Cos[phi])/\n  (PP[sExp] + eps pp[sExp] Cos[phi]) /.', ()),
    ('integrandSeries', 'Normal@Series[integrand, {eps, 0, 2}]', ()),
    ('avgExp', 'Integrate[integrandSeries, {phi, 0, 2 Pi}]/(2 Pi)', ()),
    ('invAvg', 'Normal@Series[1/avgExp, {eps, 0, 2}]', ()),
    ('dIotaDerived', 'FullSimplify[Coefficient[invAvg, eps, 2]]', ()),
    ('dIotaPrinted', 'FullSimplify[\n  -(1/((PP[s0]/(m TT[s0])) TT[s0]^2)) (1/2) (pp[s0]/m) ((pp[s0] -\n        PP[s0] tt[s0]/TT[s0])/m) -\n  (1/2) (QQ[s0]/m) D[((pp[ss] - PP[ss] tt[ss]/TT[ss])/m)/\n      ((PP[ss]/(m TT[ss]))^2 TT[ss]), ss] /. ss -> s0]', ()),
    ('printedMatches', 'FullSimplify[dIotaDerived - dIotaPrinted]', ()),
    ('xOfS', 'Sqrt[2 sv]', ('sv',)),
    ('fixtureRules', '{\n    m -> mNum,\n    PP[s0] -> (detExpr /. x -> xOfS[s0v]),\n    pp[s0] -> (phaseExpr /. x -> xOfS[s0v]),\n    TT[s0] -> (bz0Expr/capRNum /. x -> xOfS[s0v]),\n    tt[s0] -> (hExpr/capRNum /. x -> xOfS[s0v]),\n    QQ[s0] -> (x fExpr /. x -> xOfS[s0v]),\n    Derivative[1][PP][s0] -> (D[detExpr, x]/x /. x -> xOfS[s0v]),\n    Derivative[1][pp][s0] -> (D[phaseExpr, x]/x /. x -> xOfS[s0v]),\n    Derivative[1][TT][s0] -> 0,\n    Derivative[1][tt][s0] -> (D[hExpr/capRNum, x]/x /. x -> xOfS[s0v]),\n    Derivative[1][QQ][s0] -> (D[x fExpr, x]/x /. x -> xOfS[s0v]),\n    Derivative[2][PP][s0] -> (D[D[detExpr, x]/x, x]/x /. x -> xOfS[s0v]),\n    Derivative[2][pp][s0] -> (D[D[phaseExpr, x]/x, x]/x /. x -> xOfS[s0v]),\n    Derivative[2][TT][s0] -> 0,\n    Derivative[2][tt][s0] -> (D[D[hExpr/capRNum, x]/x, x]/x /. x -> xOfS[s0v]),\n    Derivative[2][QQ][s0] -> (D[D[x fExpr, x]/x, x]/x /. x -> xOfS[s0v])}', ()),
    ('dIotaFixture', 'dIotaDerived /. fixtureRules', ()),
    ('fixtureValue', 'N[dIotaFixture /. s0v -> rhoCheck^2/2, 20]', ()),
    ('printedFixture', 'N[(dIotaPrinted /. fixtureRules) /. s0v -> rhoCheck^2/2, 20]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-flux_pumping/36_memo_update_20260716.wl')
