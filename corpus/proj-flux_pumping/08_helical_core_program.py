"""Generated SymPy translation of ``corpus/proj-flux_pumping/08_helical_core_program.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments
import sympy as sp

# NOT TRANSLATED: 35 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('figdir', 'FileNameJoin[{DirectoryName[$InputFileName], "figures"}]', ()),
    ('eps', 'LeviCivitaTensor[3]', ()),
    ('xiCon', '{xir[r, th, ph], 0, 0}', ()),
    ('B0con', '{0, B0t[r], B0p[r]}', ()),
    ('sg', 'r', ()),
    ('xiXB0cov', 'Table[sg Sum[eps[[k, i, j]] xiCon[[i]] B0con[[j]], {i, 3}, {j, 3}],\n  {k, 3}]', ()),
    ('x', '{r, th, ph}', ()),
    ('dBrCon', 'Sum[eps[[1, j, k]] D[xiXB0cov[[k]], x[[j]]], {j, 3}, {k, 3}]/sg', ()),
    ('dBrHarm', 'Simplify[dBrCon /. xir -> Function[{r, th, ph},\n  xim Exp[I (m th + n ph)]]]', ()),
    ('xiHarm', 'xim Exp[I (m th + n ph)]', ()),
    ('kparB0', 'm B0t[r] + n B0p[r]', ()),
    ('SS', 'm th + n ph', ()),
    ('rOfRho', 'rho - eD DelA[rho] Cos[s + al[rho]]', ('rho', 's')),
    ('sgNewSym', 'rOfRho[rhov, sv] D[rOfRho[rhov, sv], rhov]', ()),
    ('sgJph', 'rho jm[rho] Cos[SS + be[rho]]', ()),
    ('sgJth', '-(n/m) sgJph', ()),
    ('rhoOfR', 'r + eD DelA[r] Cos[SS + al[r]]', ()),
    ('jphNewSym', 'rhov jm[rhov] Cos[sv + be[rhov]]/sgNewSym', ()),
    # Keep the derivatives at the physical radius after the rho(r, S)
    # substitution.  Expanding this first-order Series result explicitly is
    # source-faithful and avoids leaving SymPy Subs(Derivative(..., rhov),
    # rhov -> r) wrappers in the exported expression.
    ('jphOld', 'eD (-DelA[r] D[be[r], r] Cos[s0 + al[r]] jm[r] Sin[s0 + be[r]] +\n  DelA[r] D[jm[r], r] Cos[s0 + al[r]] Cos[s0 + be[r]] +\n  DelA[r] Cos[s0 + al[r]] Cos[s0 + be[r]] jm[r]/r -\n  Cos[s0 + be[r]] jm[r] (DelA[r] D[al[r], r] Sin[s0 + al[r]] -\n    D[DelA[r], r] Cos[s0 + al[r]])) + Cos[s0 + be[r]] jm[r]', ()),
    ('javg', 'Integrate[jphOld, {s0, 0, 2 Pi}]/(2 Pi) /. eD -> 1', ()),
    ('javgClaim', '(1/(2 r)) D[r jm[r] DelA[r] Cos[al[r] - be[r]], r]', ()),
    ('q0b', '1.02', ()),
    ('aj', '50.', ()),
    ('r1', '12.', ()),
    ('wcd', '6.', ()),
    ('acd', '0.10', ()),
    ('encBase', 'rr^2/(2 (1 + (rr/aj)^2))', ('rr',)),
    ('encCD', 'acd (wcd^2/2) (1 - Exp[-(rr/wcd)^2])', ('rr',)),
    ('jBase', '1./(1 + (rr/aj)^2)^2', ('rr',)),
    ('jCD', 'jBase[rr] + acd Exp[-(rr/wcd)^2]', ('rr',)),
    ('qOfBase', 'q0b (1 + (rr/aj)^2)', ('rr',)),
    ('qOfCD', 'q0b rr^2/(encBase[rr] + encCD[rr])/2', ('rr',)),
    ('qcl', '1.005', ()),
    ('rx', 'rr /. FindRoot[qOfCD[rr] - qcl, {rr, 8., 0.5, 30.}]', ()),
    ('encTot', 'If[rr < rx, q0b rr^2/(2 qcl), encBase[rr] + encCD[rr]]', ('rr',)),
    ('qClamped', 'q0b rr^2/(2 encTot[rr])', ('rr',)),
    ('jClamped', 'If[rr < rx, q0b/qcl, jCD[rr]]', ('rr',)),
    ('djFP', 'jClamped[rr] - jCD[rr]', ('rr',)),
    ('figQ', 'GraphicsRow[{\n  Plot[{qOfBase[rr], qOfCD[rr], qClamped[rr], 1}, {rr, 0.5, 30},\n    PlotStyle -> {{ColorData[97, 1]}, {ColorData[97, 2]},\n      {ColorData[97, 3], Thick}, {Gray, Dashed}},\n    Frame -> True, FrameLabel -> {"r [cm]", "q"},\n    PlotLegends -> Placed[{"base (hybrid)", "with central CD",\n      "with CD + helical current", "q = 1"}, {0.35, 0.72}],\n    PlotRange -> {0.9, 1.45}],\n  Plot[{jCD[rr], jClamped[rr], djFP[rr]}, {rr, 0.01, 30},\n    PlotStyle -> {{ColorData[97, 2]}, {ColorData[97, 3], Thick},\n      {ColorData[97, 4], Dashed}},\n    Frame -> True, FrameLabel -> {"r [cm]",\n      "\\!\\(\\*SubscriptBox[\\(j\\), \\(z\\)]\\) [arb.]"},\n    PlotLegends -> Placed[{"with CD", "clamped",\n      "helical redistribution"}, {0.62, 0.4}]]}, ImageSize -> 800]', ()),
    ('gProf', '2 (encTot[rr] - encBase[rr] - encCD[rr])/rr', ('rr',)),
    ('figR', 'Plot[{gProf[rr], djFP[rr]}, {rr, 0.01, 30},\n  PlotStyle -> {{ColorData[97, 1]}, {ColorData[97, 4], Thick}},\n  Frame -> True, FrameLabel -> {"r [cm]", "arb. units"},\n  PlotLegends -> Placed[{\n    "g = \\!\\(\\*SubscriptBox[\\(j\\), \\(m\\)]\\)\\[CapitalDelta]cos(\\[Alpha]-\\[Beta]) (helical amplitude)",\n    "\\!\\(\\*OverscriptBox[SuperscriptBox[\\(j\\), \\(\\[CurlyPhi]\\)], \\(_\\)]\\) redistribution"}, {0.68, 0.25}],\n  PlotLabel -> "generalized redistribution javg = (2r)^-1 d/dr[r g]",\n  PlotRange -> All, ImageSize -> 460]', ()),
    ('fp', 'Solve[{(qsrc - q0) + kap D2 == 0, gam1 (1 - q0) - gam2 D2 == 0},\n  {q0, D2}] // First', ()),
    ('jac', 'D[{((qsrc - q0) + kap D2)/tau, 2 gam1 (1 - q0) D2 - 2 gam2 D2^2},\n  {{q0, D2}}] /. fp // Simplify', ()),
    ('evs', 'Eigenvalues[jac /. {qsrc -> 0.9, kap -> 1, gam1 -> 50, gam2 -> 5,\n  tau -> 1}]', ()),
    ('sol', "NDSolve[{q0'[t] == ((0.9 - q0[t]) + 1 D2[t]),\n  D2'[t] == 2 50 (1 - q0[t]) D2[t] - 2 5 D2[t]^2,\n  q0[0] == 1.02, D2[0] == 10^-4}, {q0, D2}, {t, 0, 30}][[1]]", ()),
    ('solOff', "NDSolve[{q0'[t] == (0.9 - q0[t]), q0[0] == 1.02}, q0, {t, 0, 30}][[1]]", ()),
    ('figP', 'GraphicsRow[{\n  Plot[{q0[t] /. sol, q0[t] /. solOff, 1}, {t, 0, 30},\n    PlotStyle -> {{ColorData[97, 1], Thick}, {ColorData[97, 2], Dashed},\n      {Gray, Dotted}},\n    Frame -> True, FrameLabel -> {"t/\\[Tau]", "\\!\\(\\*SubscriptBox[\\(q\\), \\(0\\)]\\)"},\n    PlotLegends -> Placed[{"with (1,1) feedback", "no feedback", "q = 1"},\n      {0.62, 0.35}], PlotRange -> {0.85, 1.05}],\n  StreamPlot[{((0.9 - qq) + dd), 2 50 (1 - qq) dd - 2 5 dd^2},\n    {qq, 0.88, 1.03}, {dd, 0, 0.12},\n    FrameLabel -> {"\\!\\(\\*SubscriptBox[\\(q\\), \\(0\\)]\\)",\n      "mode intensity \\!\\(\\*SuperscriptBox[\\(\\[CapitalDelta]\\), \\(2\\)]\\) [arb.]"},\n    StreamStyle -> Gray,\n    Epilog -> {Red, PointSize[0.02],\n      Point[{q0 /. fp, D2 /. fp} /. {qsrc -> 0.9, kap -> 1, gam1 -> 50,\n        gam2 -> 5}]}]}, ImageSize -> 800]', ()),
    ('clight', '2.99792458 10^10', ()),
    ('ee', '4.80320425 10^-10', ()),
    ('me', '9.1093837 10^-28', ()),
    ('erg', '1.602176634 10^-12', ()),
    ('Te', '3 10^3 erg', ()),
    ('ne', '6 10^13', ()),
    ('B0', '2 10^4', ()),
    ('Rmaj', '170.', ()),
    ('rc', '10.', ()),
    ('lnL', '16.', ()),
    ('vTe', 'Sqrt[Te/me]', ()),
    ('qp', '0.002', ()),
    ('kp', 'qp/(1^2 Rmaj)', ()),
    ('Ln', '100.', ()),
    ('nep', 'ne/Ln', ()),
    ('nuE', '2.91 10^-6 ne lnL (Te/erg)^(-3/2)', ()),
    ('wEex', '5 10^2', ()),
    ('ZDel', '(I nuE - wEex)/(Sqrt[2] vTe kp rc)', ()),
    ('IoverH', 'Sqrt[2 Pi] ee nep vTe/kp', ()),
    ('hA', 'kp (rc/2) xi fMA', ('xi', 'fMA')),
    ('jmAvail', 'IoverH hA[xi, fMA]/rc', ('xi', 'fMA')),
    ('j0AUG', '150. 2.99792458 10^9', ()),
    ('jmNeed', '0.1 j0AUG', ()),
    ('fMAneed', 'fMA /. FindRoot[jmAvail[xi, fMA] - jmNeed, {fMA, 0.01, 0., 1.}]', ('xi',)),
    ('figE', 'ContourPlot[\n  Log10[jmAvail[xi, 10^lfMA]/jmNeed], {xi, 0.2, 5}, {lfMA, -4, 0},\n  Contours -> Range[-3, 3], ContourShading -> Automatic,\n  ColorFunction -> "TemperatureMap",\n  FrameLabel -> {"corrugation \\[Xi] [cm]",\n    "log10 misalignment fraction \\!\\(\\*SubscriptBox[\\(f\\), \\(MA\\)]\\)"},\n  PlotLegends -> BarLegend[Automatic,\n    LegendLabel -> "log10(available/needed)"],\n  Epilog -> {Black, Thick,\n    Line[Table[{xi, Log10[fMAneed[xi]]}, {xi, 0.2, 5, 0.2}]],\n    Text[Style["marginal clamping", 11, Bold], {3.2, Log10[fMAneed[3.2]] + 0.25}]},\n  ImageSize -> 480]', ()),
]

def results():
    values = evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-flux_pumping/08_helical_core_program.wl')
    # The source is a bounded 2x2 symbolic Solve.  Preserve its Wolfram Rule
    # result when the assignment evaluator cannot serialize that one result.
    q0, D2, gam1, gam2, kap, qsrc = sp.symbols(
        'q0 D2 gam1 gam2 kap qsrc'
    )
    denominator = gam1 * kap + gam2
    rule = sp.Function('Rule')
    values.setdefault(
        'fp',
        sp.Tuple(
            rule(q0, qsrc + gam1 * kap * (1 - qsrc) / denominator),
            rule(D2, gam1 * (1 - qsrc) / denominator),
        ),
    )
    if 'jphOld' in values:
        values['jphOld'] = sp.expand(values['jphOld'])
    return values
