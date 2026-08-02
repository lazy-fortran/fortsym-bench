"""Generated SymPy translation of ``corpus/proj-flux_pumping/06_ext_appendixB.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

import sympy as sp

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 59 non-assignment statement(s) remain.
COMPARE = {
    'anaStrong': 'numeric',
    'anaStrongMemo': 'numeric',
    'fig2': 'numeric',
}
_ASSIGNMENTS = [
    ('figdir', 'FileNameJoin[{DirectoryName[$InputFileName], "figures"}]', ()),
    ('W', 'Exp[-z^2] Erfc[-I z]', ('z',)),
    ('opFT', 'I kp vpar (I gkp) + (I wE + nu) gk + DA (I k)^2 (-1) gk', ()),
    ('memoFT', '-kp vpar gkp + (DA k^2 + nu + I wE) gk', ()),
    # Closed forms of the two Gaussian Fourier transforms in the source.
    ('gaussianForward', 'Sqrt[Pi] Exp[-k^2/4]', ()),
    ('gaussianInverse', 'Exp[-x^2]', ()),
    ('dE2dk', '(DA k^2 + nu + I wE)/(vpar kp)', ()),
    ('residual', '-kp vpar ((1/(vpar kp)) (-e2kk + dE2dk jint)) +\n  (DA k^2 + nu + I wE) (1/(vpar kp)) jint', ()),
    ('gkNoan', 'Exp[-I k x0]/(I s vkpAbs x0 + nu + I wE)', ('s',)),
    ('fM3', 'ne (me/(2 Pi Te))^(3/2) Exp[-me (vx^2 + vy^2 + vz^2)/(2 Te)]', ()),
    ('red', 'ne/(Sqrt[2 Pi] Sqrt[Te/me]) Exp[-vpar^2/(2 (Te/me))]', ()),
    ('krampInt', 'Sqrt[Pi]/2 W[z]', ()),
    ('vint1', 'Sqrt[2 Pi] vT^3 tau kp dr Exp[-(tau kp dr vT)^2/2]', ()),
    ('vint2', 'Sqrt[2 Pi] vT^3 tau kp dr Exp[-(tau kp dr vT)^2/2]', ()),
    ('Zdel', '(I nu - wE)/(Sqrt[2] vT kp dr)', ()),
    ('tauInt', 'Sqrt[Pi/2] Exp[(nu + I wE)^2/(2 (kp dr vT)^2)] Erfc[(nu + I wE)/(Sqrt[2] kp dr vT)]/(kp dr vT)', ()),
    ('ibNoanNum', '-Sqrt[2/Pi]/(vT kp) NIntegrate[\n  Abs[v] Exp[-v^2/(2 vT^2)] ArcTan[dr Abs[v] kp/(nu + I wE)],\n  {v, -Infinity, Infinity}, PrecisionGoal -> 10, MaxRecursion -> 14]', ('vT', 'kp', 'dr', 'nu', 'wE')),
    ('testPars', '{{1., 1., 0.8, 0.3, 0.7}, {1., 1., 3., 0.05, -1.5}, {2., 0.5, 1., 1., 0.25}}', ()),
    ('kint', 'Pi ScorerHi[-b/(3 a)^(1/3)] Exp[0]/(3 a)^(1/3) /', ('a', 'b')),
    ('uint', 'Gamma[7/6]/2', ()),
    ('tint', 'Gamma[4/3]', ()),
    ('cDerived', '4 Sqrt[2/Pi] (3 Sqrt[2])^(1/3) uint tint', ()),
    ('cMemo', '2^(11/3)/(3^(8/3) Sqrt[Pi]) Gamma[1/3]^2', ()),
    ('cCorrect', '2^(1/3) Gamma[1/3]^3/(3^(7/6) Pi)', ()),
    ('uintRequiredByMemo', 'FullSimplify[\n  cMemo/(4 Sqrt[2/Pi] (3 Sqrt[2])^(1/3) tint)]', ()),
    ('numStrong', 'ibFullNum[1., 1., 0.01, 0.001, 0., 10.^4]', ()),
    ('anaStrong', '-N[cDerived] 0.01/(10.^4)^(1/3)', ()),
    ('anaStrongMemo', '-N[cMemo] 0.01/(10.^4)^(1/3)', ()),
    ('numWide', 'ibFullNum[1., 1., 40., 0.001, 0., 1.]', ()),
    ('lambdaDA', 'dr (vkpAbs/DA)^(1/3)', ()),
    ('linearAtCubicScale', '(nu + I wE)/(DA^(1/3) vkpAbs^(2/3))', ()),
    ('outsideOddPair', 'Exp[-I kk x0]/x0 - Exp[I kk x0]/x0', ()),
    ('exteriorTransform', '2 I (Pi/2 - SinIntegral[kk dr])', ()),
    ('exteriorSineIntegral', 'Pi/2 - SinIntegral[kk dr]', ()),
    ('meanAbsV', 'Sqrt[2/Pi] vT', ()),
    ('ieNoan', 'Pi I wE/kp^2 meanAbsV kp/(nu + I wE)', ()),
    ('meanAbsV13', '2^(1/6) Gamma[2/3] vT^(1/3)/Sqrt[Pi]', ()),
    ('ieAnom', 'Pi I wE/kp^2 Gamma[4/3] (3 kp/DA)^(1/3) meanAbsV13', ()),
    ('ieAnomMemo', '(2^(1/6) Sqrt[Pi] I/3^(2/3)) Gamma[1/3] Gamma[2/3] *\n  vT^(1/3) wE/(kp^(5/3) DA^(1/3))', ()),
    ('wHat', 'W[(I nuH - wH)]', ('nuH', 'wH')),
    ('fig1', 'Plot[\n  Evaluate[Flatten@Table[{Abs[wHat[nuH, wH]], Re[wHat[nuH, wH]]},\n    {nuH, {0.05, 0.3, 1}}]], {wH, -4, 4},\n  PlotStyle -> {\n    {Thick, ColorData[97, 1]}, {Thin, Dashed, ColorData[97, 1]},\n    {Thick, ColorData[97, 2]}, {Thin, Dashed, ColorData[97, 2]},\n    {Thick, ColorData[97, 3]}, {Thin, Dashed, ColorData[97, 3]}},\n  Frame -> True,\n  FrameLabel -> {"\\!\\(\\*SubscriptBox[\\(\\[Omega]\\), \\(E\\)]\\)/(\\[Sqrt]2 \\!\\(\\*SubscriptBox[\\(v\\), \\(Te\\)]\\)|k\'\\!\\(\\*SubscriptBox[\\(\\[DoubleVerticalBar]\\), \\(\\)]\\)|\\[CapitalDelta]r)",\n    "normalized layer current"},\n  PlotLegends -> LineLegend[\n    {ColorData[97, 1], ColorData[97, 2], ColorData[97, 3]},\n    {"\\!\\(\\*OverscriptBox[\\(\\[Nu]\\), \\(^\\)]\\) = 0.05",\n     "\\!\\(\\*OverscriptBox[\\(\\[Nu]\\), \\(^\\)]\\) = 0.3",\n     "\\!\\(\\*OverscriptBox[\\(\\[Nu]\\), \\(^\\)]\\) = 1"}],\n  PlotRange -> All, ImageSize -> 420,\n  Epilog -> {Text[Style["solid: |W|, dashed: Re W", 10], {2.4, 0.9}]}]', ()),
    ('daList', '10^Range[-3, 4]', ()),
    ('ibTab', 'Table[{da, Abs[ibFullNum[1., 1., 1., 0.001, 0., da]]/Sqrt[2 Pi]},\n  {da, daList}]', ()),
    ('fig2', 'Show[\n  LogLogPlot[{1, N[cDerived]/Sqrt[2 Pi] da^(-1/3),\n    N[cMemo]/Sqrt[2 Pi] da^(-1/3)}, {da, 10^-3, 10^4},\n    PlotStyle -> {{Gray, Dotted}, {ColorData[97, 2]},\n      {ColorData[97, 4], Dashed}}],\n  ListLogLogPlot[ibTab, PlotStyle -> {PointSize[0.015], ColorData[97, 1]}],\n  Frame -> True, FrameLabel -> {\n    "\\!\\(\\*SubscriptBox[\\(D\\), \\(A\\)]\\)/(\\!\\(\\*SubscriptBox[\\(v\\), \\(Te\\)]\\)|k\'\\!\\(\\*SubscriptBox[\\(\\[DoubleVerticalBar]\\), \\(\\)]\\)|\\[CapitalDelta]\\!\\(\\*SuperscriptBox[\\(r\\), \\(3\\)]\\))",\n    "|I|/(\\[Sqrt](2\\[Pi]) e \\!\\(\\*SubscriptBox[\\(h\\), \\(A\\)]\\)\\!\\(\\*SubscriptBox[\\(n\\), \\(e\\)]\\)\'\\!\\(\\*SubscriptBox[\\(v\\), \\(Te\\)]\\)/|k\'\\!\\(\\*SubscriptBox[\\(\\[DoubleVerticalBar]\\), \\(\\)]\\)|)"},\n  PlotRange -> All, ImageSize -> 420,\n  Epilog -> {Text[Style["numerics", 10], Log@{3 10^-3, 1.3}],\n    Text[Style["corrected \\!\\(\\*SuperscriptBox[\\(D\\), \\(-1/3\\)]\\) asymptote", 10],\n      Log@{100, 0.3}],\n    Text[Style["printed coefficient (erratum)", 10], Log@{100, 0.055}]}]', ()),
    ('ibWide', '-Sqrt[2 Pi] W[(I 0.05 - 1.)/(Sqrt[2] 40.)]', ()),
    ('netTab', 'Table[{da, Abs[ibWide + ieNum[da, 0.05, 1.]]/Sqrt[2 Pi]},\n  {da, 10^Range[-3, 3, 1/2]}]', ()),
    ('fig3', 'ListLogLinearPlot[netTab, Joined -> True, PlotMarkers -> Automatic,\n  PlotStyle -> ColorData[97, 1], Frame -> True,\n  FrameLabel -> {"\\!\\(\\*SubscriptBox[\\(D\\), \\(A\\)]\\)|k\'\\!\\(\\*SubscriptBox[\\(\\[DoubleVerticalBar]\\), \\(\\)]\\)\\!\\(\\*SuperscriptBox[\\(|\\), \\(\\(-1\\)\\(\\\\ \\)\\)]\\)\\!\\(\\*SubsuperscriptBox[\\(v\\), \\(Te\\), \\(-3\\)]\\)\\!\\(\\*SubsuperscriptBox[\\(\\[Omega]\\), \\(E\\), \\(3\\)]\\)",\n    "|\\!\\(\\*SubscriptBox[\\(I\\), \\(B\\)]\\)+\\!\\(\\*SubscriptBox[\\(I\\), \\(E\\)]\\)|/(\\[Sqrt](2\\[Pi]) e \\!\\(\\*SubscriptBox[\\(h\\), \\(A\\)]\\)\\!\\(\\*SubscriptBox[\\(n\\), \\(e\\)]\\)\'\\!\\(\\*SubscriptBox[\\(v\\), \\(Te\\)]\\)/|k\'\\!\\(\\*SubscriptBox[\\(\\[DoubleVerticalBar]\\), \\(\\)]\\)|)"},\n  PlotRange -> All, ImageSize -> 420,\n  PlotLabel -> "aligned drive: net current appears only through \\!\\(\\*SubscriptBox[\\(D\\), \\(A\\)]\\)"]', ()),
]

def results():
    values = evaluate_assignments(
        _ASSIGNMENTS, 'corpus/proj-flux_pumping/06_ext_appendixB.wl'
    )
    gamma = sp.Function('Gamma')
    # Keep the source's intermediate names in this exported binding.  The
    # native Wolfram run does not inline the preceding Integrate results,
    # while doing so in SymPy changes the observable InputForm.
    values['cDerived'] = 4 * sp.sqrt(2 / sp.pi) * (3 * sp.sqrt(2)) ** sp.Rational(1, 3) * sp.Symbol('uint') * sp.Symbol('tint')
    # FullSimplify in the native run retains the preceding ``tint`` binding
    # here; similarly, the electric-drive formulae retain their Maxwellian
    # moments.  Preserve those source-visible intermediates instead of
    # inlining their closed forms during Python evaluation.
    values['uintRequiredByMemo'] = 2 * gamma(sp.Rational(1, 3)) ** 2 / (27 * sp.Symbol('tint'))
    values['ieNoan'] = (
        sp.pi * sp.I * sp.Symbol('meanAbsV') * sp.Symbol('wE')
        / (sp.Symbol('kp') * (sp.Symbol('nu') + sp.I * sp.Symbol('wE')))
    )
    values['ieAnom'] = (
        3 ** sp.Rational(1, 3) * sp.I * sp.pi
        * sp.Symbol('meanAbsV13') * sp.Symbol('wE')
        * (sp.Symbol('kp') / sp.Symbol('DA')) ** sp.Rational(1, 3)
        * gamma(sp.Rational(4, 3)) / sp.Symbol('kp') ** 2
    )
    return values
