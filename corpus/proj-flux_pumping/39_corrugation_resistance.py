"""Generated SymPy translation of ``corpus/proj-flux_pumping/39_corrugation_resistance.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments
import sympy as sp

# NOT TRANSLATED: 38 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('figdir', 'FileNameJoin[{DirectoryName[$InputFileName], "figures"}]', ()),
    ('$Assumptions', 'r > 0 && rho > 0 &&', ()),
    ('chiOf', 'm th + k z', ('th', 'z')),
    ('Bfield', '{\n  eps p[r] Sin[chiOf[th, z]],\n  Bth[r] + eps t[r] Cos[chiOf[th, z]],\n  B0 + eps w[r] Cos[chiOf[th, z]]}', ('r', 'th', 'z')),
    ('gradCyl', '{D[f, r], D[f, th]/r, D[f, z]}', ('f', 'r', 'th', 'z')),
    ('divB', 'Simplify[divCyl[Bfield[r, th, z], r, th, z]]', ()),
    ('divConstraint', "p'[r] + p[r]/r - m t[r]/r - k w[r]", ()),
    ('tRule', "{t -> Function[x, (x p'[x] + p[x] - k x w[x])/m]}", ()),
    ('Bvec', 'Bfield[r, th, z] /. tRule', ()),
    ('Bmag', 'Sqrt[Bvec . Bvec]', ()),
    ('lhsId', 'divCyl[g[r, th, z] Bvec/Bmag, r, th, z]', ()),
    ('rhsId', 'Bmag (Bvec/Bmag) . gradCyl[g[r, th, z]/Bmag, r, th, z]', ()),
    ('rhoLabel', 'r + eps Delta[r] Cos[chiOf[th, z] + alpha]', ('r', 'th', 'z')),
    ('tangency', 'Simplify[Coefficient[Normal@Series[\n  Bfield[r, th, z] . gradCyl[rhoLabel[r, th, z], r, th, z],\n  {eps, 0, 1}], eps]]', ()),
    ('detuning', 'm Bth[r]/r + k B0', ()),
    ('pRule', '{p -> Function[x, Delta[x] (m Bth[x]/x + k B0)]}', ()),
    ('ord', '2', ()),
    ('rOf', 'rho - eps Delta[rho] Cos[chi] +\n  eps^2 (rr2[rho] + rr2c[rho] Cos[2 chi])', ('rho', 'chi')),
    ('jacJ', 'Normal@Series[\n  rOf[rho, chi] D[rOf[rho, chi], rho], {eps, 0, ord}]', ('rho', 'chi')),
    ('avg', 'Normal@Series[\n  Integrate[Normal@Series[X jacJ[rho, chi], {eps, 0, ord}],\n    {chi, 0, 2 Pi}]/\n  Integrate[jacJ[rho, chi], {chi, 0, 2 Pi}], {eps, 0, ord}]', ('X',)),
    ('onSurf', '{r -> rOf[rho, chi], th -> chi/m, z -> 0}', ()),
    ('BgradChi', 'Normal@Series[\n  ((m Bvec[[2]]/r + k Bvec[[3]]) /. pRule /. alpha -> 0) /.\n    {Cos[chiOf[th, z]] -> Cos[chi], Sin[chiOf[th, z]] -> Sin[chi]} /.\n    onSurf, {eps, 0, ord}]', ()),
    ('Xtest', 'eps (x1[rho] Cos[chi + b1] + x2[rho] Cos[2 chi + b2])', ()),
    ('evalOn', 'Normal@Series[\n  (X /. {Cos[chiOf[th, z]] -> Cos[chi], Sin[chiOf[th, z]] -> Sin[chi]}) /.\n    onSurf, {eps, 0, ord}]', ('X',)),
    ('BzOn', 'evalOn[Bvec[[3]]]', ()),
    ('B2On', 'evalOn[Bvec . Bvec]', ()),
    ('CCsol', 'EA avg[BzOn]/avg[B2On]', ()),
    ('Fcons', 'Normal@Series[avg[BzOn]^2/avg[B2On], {eps, 0, ord}]', ()),
    ('Fnaive', 'avg[BzOn^2/B2On]', ()),
    ('F0', 'B0^2/(B0^2 + Bth[rho]^2)', ()),
    ('tilt0', '{Delta -> Function[x, 0], Bth -> Function[x, 0],\n  rr2 -> Function[x, 0], rr2c -> Function[x, 0]}', ()),
    ('tComposite', "(rho p'[rho] + p[rho] - k rho w[rho])/m", ()),
    ('FconsTilt', 'Simplify[Coefficient[Fcons /. tilt0, eps, 2]]', ()),
    ('FnaiveTilt', 'Simplify[Coefficient[Fnaive /. tilt0, eps, 2]]', ()),
    ('diffNC', 'Simplify[Coefficient[Fnaive - Fcons, eps, 2]]', ()),
    ('csSquare', 'Simplify[Coefficient[\n  avg[(BzOn - avg[BzOn] B2On/avg[B2On])^2/B2On], eps, 2]]', ()),
    ('numPoint', "Module[{rnd = BlockRandom[SeedRandom[seed];\n    RandomReal[{-1, 1}, 8]]},\n  {p[rho] -> rnd[[1]], p'[rho] -> rnd[[2]], w[rho] -> rnd[[3]],\n   w'[rho] -> rnd[[4]], Delta[rho] -> rnd[[5]], Delta'[rho] -> rnd[[6]],\n   Bth[rho] -> .3 rnd[[7]], Bth'[rho] -> .1 rnd[[8]],\n   rr2[rho] -> 0, rr2c[rho] -> 0, rr2'[rho] -> 0, rr2c'[rho] -> 0,\n   rho -> 7., B0 -> 1., m -> 1., k -> -.05}]", ('seed',)),
    ('c2', 'Coefficient[Fcons, eps, 2]', ()),
    ('xs', 'r Cos[th]', ()),
    ('ys', 'r Sin[th]', ()),
    ('rs', 'Sqrt[(xs - d Cos[k z])^2 + (ys + d Sin[k z])^2]', ()),
    ('BxS', '-Bth[rs] (ys + d Sin[k z])/rs + B0 D[d Cos[k z], z]', ()),
    ('ByS', 'Bth[rs] (xs - d Cos[k z])/rs + B0 D[-d Sin[k z], z]', ()),
    ('BrS', 'Simplify[BxS Cos[th] + ByS Sin[th]]', ()),
    ('BtS', 'Simplify[-BxS Sin[th] + ByS Cos[th]]', ()),
    ('pShift', 'Simplify[TrigReduce[Coefficient[\n  Normal@Series[BrS, {d, 0, 1}], d]] /.\n  {Sin[th + k z] -> Sin[chi1], Cos[th + k z] -> Cos[chi1]},\n  r > 0]', ()),
    ('tShift', 'Simplify[TrigReduce[Coefficient[\n  Normal@Series[BtS, {d, 0, 1}], d]] /.\n  {Sin[th + k z] -> Sin[chi1], Cos[th + k z] -> Cos[chi1]},\n  r > 0]', ()),
    ('R0fix', '20.', ()),
    ('B0fix', '1.', ()),
    ('d0fix', '0.5', ()),
    ('mfix', '1.', ()),
    ('kfix', '-1/R0fix', ()),
    ('qProf', '1.05 + 0.9 (rr/25.)^2', ('rr',)),
    ('BthProf', 'rr B0fix/(R0fix qProf[rr])', ('rr',)),
    ('DeltaProf', 'd0fix Exp[-(rr/8.)^4]', ('rr',)),
    ('detProf', 'mfix BthProf[rr]/rr + kfix B0fix', ('rr',)),
    ('pProf', 'DeltaProf[rr] detProf[rr]', ('rr',)),
    ('wProf', '0.', ('rr',)),
    ('fixRules', "{p[rho] -> pProf[rv], p'[rho] -> pProf'[rv],\n  p''[rho] -> pProf''[rv],\n  w[rho] -> wProf[rv], w'[rho] -> 0., w''[rho] -> 0.,\n  Delta[rho] -> DeltaProf[rv], Delta'[rho] -> DeltaProf'[rv],\n  Delta''[rho] -> DeltaProf''[rv],\n  Bth[rho] -> BthProf[rv], Bth'[rho] -> BthProf'[rv],\n  Bth''[rho] -> BthProf''[rv],\n  rr2[rho] -> 0., rr2c[rho] -> 0., rr2'[rho] -> 0., rr2c'[rho] -> 0.,\n  rr2''[rho] -> 0., rr2c''[rho] -> 0.,\n  rho -> rv, B0 -> B0fix, m -> mfix, k -> kfix, EA -> 1.}", ('rv',)),
    ('sample', 'Table[{rv, deficitOf[rv]}, {rv, 1., 24., 1.}]', ()),
    ('flipRadius', 'SelectFirst[Partition[sample, 2, 1],\n  #[[1, 2]] < 0 && #[[2, 2]] > 0 &][[1, 1]]', ()),
    ('deltaI', '2 Pi NIntegrate[s deficitOf[s], {s, 10^-3, rv},\n  AccuracyGoal -> 8, PrecisionGoal -> 8]', ('rv',)),
    ('I0', '2 Pi NIntegrate[s F0Of[s], {s, 10^-3, rv},\n  AccuracyGoal -> 8, PrecisionGoal -> 8]', ('rv',)),
    ('ratioOn', 'Normal@Series[B2On/BzOn, {eps, 0, ord}]', ()),
    ('ratioVar', 'Simplify[Coefficient[\n  avg[(ratioOn - avg[ratioOn])^2], eps, 2]]', ()),
    ('figData', 'Table[{rv, -deficitOf[rv]}, {rv, .5, 25., .25}]', ()),
    ('figIota', 'Table[{rv, -deltaI[rv]/I0[rv]}, {rv, 1., 25., 1.}]', ()),
    ('figCR', 'GraphicsRow[{\n  ListLinePlot[figData, PlotRange -> All, Frame -> True,\n    FrameLabel -> {"r", "-\\[Delta]F"},\n    PlotLabel -> "mean-current deficit at fixed loop voltage",\n    ImageSize -> 300],\n  ListLinePlot[figIota, PlotRange -> All, Frame -> True,\n    FrameLabel -> {"r", "-\\[Delta]\\[Iota]/\\[Iota]"},\n    PlotLabel -> "transform deficit (q0 rises)", ImageSize -> 300]},\n  ImageSize -> 640]', ()),
]

def results():
    values = evaluate_assignments(
        _ASSIGNMENTS, 'corpus/proj-flux_pumping/39_corrugation_resistance.wl'
    )

    # These source-level rules are exact, but the generic lowering cannot
    # serialize derivative syntax or Wolfram replacement rules. Preserve the
    # bindings explicitly so downstream consumers retain the same ledger.
    r, rho, th, z, chi = sp.symbols('r rho th z chi')
    eps, m, k = sp.symbols('eps m k')
    p = sp.Function('p')
    t = sp.Function('t')
    w = sp.Function('w')
    derivative1 = sp.Function('Derivative1')
    Delta = sp.Function('Delta')
    rr2 = sp.Function('rr2')
    rr2c = sp.Function('rr2c')
    values['divConstraint'] = (
        derivative1(sp.Symbol('p'), 1, r)
        + p(r) / r
        - m * t(r) / r
        - k * w(r)
    )
    values['tComposite'] = (
        rho * derivative1(sp.Symbol('p'), 1, rho) + p(rho)
        - k * rho * w(rho)
    ) / m
    rule = sp.Function('Rule')
    values['onSurf'] = sp.Tuple(
        rule(
            r,
            rho - eps * Delta(rho) * sp.cos(chi)
            + eps**2 * (rr2(rho) + rr2c(rho) * sp.cos(2 * chi)),
        ),
        rule(th, chi / m),
        rule(z, 0),
    )
    return values
