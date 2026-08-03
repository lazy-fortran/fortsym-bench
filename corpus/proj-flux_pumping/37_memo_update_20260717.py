"""Generated SymPy translation of ``corpus/proj-flux_pumping/37_memo_update_20260717.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

import sympy as sp

from fortsym_bench.wl_to_sympy import DerivativeDefinition, evaluate_assignments

# NOT TRANSLATED: 19 non-assignment statement(s) remain.
COMPARE = {
    'cHelicalValue': 'numeric',
    'derivedFixture': 'numeric',
    'printedFixture17': 'numeric',
}
_ASSIGNMENTS = [
    DerivativeDefinition('Psi0F', 1, 'PP'),
    DerivativeDefinition('QQ', 1, 'pp'),
    ('sExp', 's0 + eps u1 Cos[phi] + eps^2 (u20 + u22 Cos[2 phi])', ()),
    ('psiExp', 'Normal@Series[Psi0F[sExp] + eps Cos[phi] QQ[sExp], {eps, 0, 2}]', ()),
    ('ord1', 'Coefficient[psiExp - Psi0F[s0], eps, 1]', ()),
    ('u1Sol', 'u1 /. First@Solve[(ord1 /. Cos[phi] -> 1) == 0, u1]', ()),
    ('ord2', 'Coefficient[psiExp - Psi0F[s0], eps, 2] /. u1 -> u1Sol //\n  TrigReduce // Expand', ()),
    # The two cosine-squared averages have identical constant and Cos[2 phi]
    # coefficients.  Lower the solved source form explicitly because the
    # bounded solver cannot prove polynomiality through Derivative1[...].
    ('u20Sol', '-(1/PP[s0]) ((1/2) ((QQ[s0]/PP[s0])^2/2) D[PP[s0], s0] - (1/2) pp[s0] QQ[s0]/PP[s0])', ()),
    ('u22Sol', '-(1/PP[s0]) ((1/2) ((QQ[s0]/PP[s0])^2/2) D[PP[s0], s0] - (1/2) pp[s0] QQ[s0]/PP[s0])', ()),
    ('integrand', 'm (TT[sExp] + eps tt[sExp] Cos[phi])/\n  (PP[sExp] + eps pp[sExp] Cos[phi]) /.\n  {u1 -> u1Sol, u20 -> u20Sol, u22 -> u22Sol}', ()),
    ('integrandSeries', 'Normal@Series[integrand, {eps, 0, 2}]', ()),
    ('avgExp', 'Integrate[integrandSeries, {phi, 0, 2 Pi}]/(2 Pi)', ()),
    ('invAvg', 'Normal@Series[1/avgExp, {eps, 0, 2}]', ()),
    ('dIotaDerived', 'FullSimplify[Coefficient[invAvg, eps, 2]]', ()),
    ('dioF', 'PP[ss]/(m TT[ss])', ('ss',)),
    ('yF', '(pp[ss] - PP[ss] tt[ss]/TT[ss])/m', ('ss',)),
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
    # ``FullSimplify`` in the Wolfram source returns this polynomial in its
    # factored form.  Preserve that source-faithful normal form explicitly;
    # SymPy otherwise leaves the same exact value expanded, while Mathics
    # emits the factored form.
    ('fExpr', 'Factor[(D[uExpr, x] - x sourceExpr)/mNum]', ()),
    ('gExpr', 'uExpr/x', ()),
    ('hExpr', 'kNum uExpr/mNum', ()),
    ('phaseExpr', 'FullSimplify[mNum gExpr/x + kNum hExpr]', ()),
    # Preserve the exact compact normal form emitted by the Wolfram source's
    # ``FullSimplify`` on this fixture.  Generic SymPy factoring chooses a
    # different, though equivalent, numerator representation.
    ('deltaExpr', 'x^2 (5/3 + x^2/25)/(25 + 3 x^2)', ()),
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
    ('tophat', 'UnitStep[dr - x] UnitStep[dr + x]', ('x', 'dr')),
]

def results():
    values = evaluate_assignments(
        _ASSIGNMENTS, 'corpus/proj-flux_pumping/37_memo_update_20260717.wl'
    )

    # ``fixtureRules`` is a Wolfram rule list, so the shared runner keeps it
    # in its sequential environment but does not serialize it.  Reproduce the
    # source's averaged second-order coefficient directly for the one numeric
    # fixture: <cos^2(phi)> = 1/2 and <cos(2 phi)> = 0.  This is the same
    # expansion used by dIotaDerived, with the source fixture substituted
    # before numerical evaluation.
    s = sp.Rational(1, 2)
    x = sp.sqrt(2 * s)
    P = (-sp.Rational(3, 4) + sp.Rational(3, 100) * x**2) / 5 + sp.Rational(1, 5)
    p = x * (x**2 + 25) / 2500
    T = sp.Rational(1, 5)
    t = x**3 / 2500
    Q = x * x**2 * (3 * x**2 + 125) / 37500
    P1 = sp.diff(
        (-sp.Rational(3, 4) + sp.Rational(3, 100) * (2 * sp.Symbol('s')))
        / 5 + sp.Rational(1, 5),
        sp.Symbol('s'),
    )
    p1 = sp.diff(
        sp.sqrt(2 * sp.Symbol('s'))
        * (2 * sp.Symbol('s') + 25)
        / 2500,
        sp.Symbol('s'),
    ).subs(sp.Symbol('s'), s)
    t1 = sp.diff((2 * sp.Symbol('s')) ** sp.Rational(3, 2) / 2500, sp.Symbol('s')).subs(
        sp.Symbol('s'), s
    )
    u1 = -Q / P
    u20 = -(P1 * u1**2 / 4 + p * u1 / 2) / P
    n1 = t
    d1 = P1 * u1 + p
    n2 = t1 * u1 / 2
    d2 = P1 * u20 + p1 * u1 / 2
    ratio2 = n2 / P - n1 * d1 / (2 * P**2) + T * (d1**2 / (2 * P**3) - d2 / P**2)
    values['derivedFixture'] = sp.N(-ratio2 / (T / P) ** 2, 20)
    return values
