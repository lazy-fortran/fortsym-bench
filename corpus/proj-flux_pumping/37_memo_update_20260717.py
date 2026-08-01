"""Generated SymPy translation of ``corpus/proj-flux_pumping/37_memo_update_20260717.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 25 non-assignment statement(s) remain.
_ASSIGNMENTS = [
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
    ('dIotaPrinted17', 'FullSimplify[\n  -(1/(dioF[s0] TT[s0]^2)) (1/2) (pp[s0]/m) yF[s0] -\n  (dioF[s0]/TT[s0]) (1/2) (QQ[s0]/m) (D[yF[ss]/(dioF[ss]^2 TT[ss]), ss] /.\n     ss -> s0) -\n  (1/(2 dioF[s0] TT[s0]^2)) (1/2) (QQ[s0]/m)^2 (D[1/dioF[ss], {ss, 2}] /.\n     ss -> s0)]', ()),
    ('printedDiff17', 'FullSimplify[dIotaDerived - dIotaPrinted17]', ()),
    ('g0pp', 'D[m TT[ss]/PP[ss], {ss, 2}] /. ss -> s0', ()),
    ('g0p', 'D[m TT[ss]/PP[ss], ss] /. ss -> s0', ()),
    ('term3printed', '-(1/(2 dioF[s0] TT[s0]^2)) (1/2) (QQ[s0]/m)^2 g0pp', ()),
    ('term3correct', '-(1/(2 TT[s0]^2)) (1/2) (QQ[s0]/m)^2 g0pp', ()),
    ('missingShift', '-dioF[s0]^2 u20Sol g0p', ()),
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
    ('deltaExpr', 'FullSimplify[fExpr/detExpr]', ()),
    ('gammaExpr', 'FullSimplify[deltaExpr D[deltaExpr, x] +\n  deltaExpr^2 (1 + x D[detExpr, x]/detExpr)/(2 x)]', ()),
    ('a0Expr', 'FullSimplify[bz0Expr/(capRNum detExpr)]', ()),
    ('a1Expr', 'FullSimplify[(hExpr detExpr - bz0Expr phaseExpr)/(capRNum detExpr^2)]', ()),
    ('a2Expr', 'FullSimplify[bz0Expr phaseExpr^2/(capRNum detExpr^3) -\n  hExpr phaseExpr/(capRNum detExpr^2)]', ()),
    ('hSeriesExpr', 'FullSimplify[gammaExpr D[a0Expr, x] +\n  deltaExpr^2 D[a0Expr, {x, 2}]/2 - deltaExpr D[a1Expr, x] + a2Expr]', ()),
    ('cHelicalExpr', 'FullSimplify[-hSeriesExpr/(2 mNum a0Expr^2)]', ()),
    ('rhoCheck', '1', ()),
    ('cHelicalValue', 'N[cHelicalExpr /. x -> rhoCheck, 20]', ()),
    ('xOfS', 'Sqrt[2 sv]', ('sv',)),
    ('fixtureRules', '{\n    m -> mNum,\n    PP[s0] -> (detExpr /. x -> xOfS[s0v]),\n    pp[s0] -> (phaseExpr /. x -> xOfS[s0v]),\n    TT[s0] -> (bz0Expr/capRNum /. x -> xOfS[s0v]),\n    tt[s0] -> (hExpr/capRNum /. x -> xOfS[s0v]),\n    QQ[s0] -> (x fExpr /. x -> xOfS[s0v]),\n    Derivative[1][PP][s0] -> (D[detExpr, x]/x /. x -> xOfS[s0v]),\n    Derivative[1][pp][s0] -> (D[phaseExpr, x]/x /. x -> xOfS[s0v]),\n    Derivative[1][TT][s0] -> 0,\n    Derivative[1][tt][s0] -> (D[hExpr/capRNum, x]/x /. x -> xOfS[s0v]),\n    Derivative[1][QQ][s0] -> (D[x fExpr, x]/x /. x -> xOfS[s0v]),\n    Derivative[2][PP][s0] -> (D[D[detExpr, x]/x, x]/x /. x -> xOfS[s0v]),\n    Derivative[2][pp][s0] -> (D[D[phaseExpr, x]/x, x]/x /. x -> xOfS[s0v]),\n    Derivative[2][TT][s0] -> 0,\n    Derivative[2][tt][s0] -> (D[D[hExpr/capRNum, x]/x, x]/x /. x -> xOfS[s0v]),\n    Derivative[2][QQ][s0] -> (D[D[x fExpr, x]/x, x]/x /. x -> xOfS[s0v])}', ()),
    ('printedFixture17', 'N[(dIotaPrinted17 /. fixtureRules) /. s0v -> rhoCheck^2/2, 20]', ()),
    ('derivedFixture', 'N[(dIotaDerived /. fixtureRules) /. s0v -> rhoCheck^2/2, 20]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-flux_pumping/37_memo_update_20260717.wl')
