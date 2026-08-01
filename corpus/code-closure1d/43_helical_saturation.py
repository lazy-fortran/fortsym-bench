"""Generated SymPy translation of ``corpus/code-closure1d/43_helical_saturation.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 16 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('figdir', 'FileNameJoin[{DirectoryName[$InputFileName], "figures"}]', ()),
    ('datadir', 'FileNameJoin[{DirectoryName[$InputFileName], "..", "mhd1d",\n  "test", "data"}]', ()),
    ('aFix', '0.08', ()),
    ('bFix', '0.01', ()),
    ('kFix', '-1/20.', ()),
    ('H0fix', '1.', ()),
    ('rEdge', '25.', ()),
    ('eps0', '10^-6', ()),
    ('g', '1 + kFix^2 r^2', ('r',)),
    ('Hfun', 'H0fix - aFix s - bFix s^2/2', ('s',)),
    ('Hp', '-aFix - bFix s', ('s',)),
    ('Hpp', '-bFix', ('s',)),
    ('Ssrc', 'Hfun[s] (2 kFix + g[r] Hp[s])/g[r]^2', ('s', 'r')),
    ('S1', '(Hp[s] (2 kFix + g[r] Hp[s]) + g[r] Hfun[s] Hpp[s])/g[r]^2', ('s', 'r')),
    ('S2', '(Hpp[s] (2 kFix + g[r] Hp[s]) + 2 g[r] Hp[s] Hpp[s])/g[r]^2', ('s', 'r')),
    ('feedTbl', 'Map[ToExpression[StringReplace[#, "e" -> "*10^"]] &,\n  Map[StringSplit[#, ","] &,\n    Select[ReadList[FileNameJoin[{datadir, "helical_feedback.csv"}],\n      String], !StringStartsQ[#, "#"] &]], {2}]', ()),
    ('feedCheck', 'Max[Table[Abs[(row[[3]]^2/4) S2[row[[2]], row[[1]]] -\n    row[[4]]], {row, feedTbl}]]', ()),
    ('meanRhs', '-(s0p (1 - kFix^2 r^2)/(r g[r]) + g[r] (Ssrc[s0, r] + src))', ('s0', 's0p', 'r', 'src')),
    ('solveMean', "NDSolve[{\n    s0''[rr] == meanRhs[s0[rr], s0'[rr], rr, srcFun[rr]],\n    s0[eps0] == 0, s0'[eps0] == 0}, s0, {rr, eps0, rEdge},\n  AccuracyGoal -> 12, PrecisionGoal -> 12][[1]]", ('srcFun',)),
    ('solveHarm', "Module[{sh, sc},\n  sh = NDSolve[{\n     s1''[rr] == -(s1'[rr] (1 - kFix^2 rr^2)/(rr g[rr]) +\n       (-g[rr]/rr^2 + g[rr] S1[(s0[rr] /. m0), rr]) s1[rr]),\n     s1[eps0] == eps0, s1'[eps0] == 1.}, s1, {rr, eps0, rEdge},\n    AccuracyGoal -> 12, PrecisionGoal -> 12][[1]];\n  sc = psib/(s1[rEdge] /. sh);\n  {sh, sc}]", ('m0', 'psib')),
    ('saturate', 'Module[\n  {m0, sh, sc, srcOld, srcNew, m0new, diff, it, gridS, vals},\n  m0 = solveMean[Function[rr, 0.]];\n  srcOld = Function[rr, 0.];\n  diff = 1.; it = 0;\n  While[diff > 10^-10 && it < maxit,\n    {sh, sc} = solveHarm[m0, psib];\n    gridS = Table[rv, {rv, eps0, rEdge, (rEdge - eps0)/400.}];\n    vals = Table[(1 - theta) srcOld[rv] +\n      theta (sc (s1[rv] /. sh))^2/4 S2[(s0[rv] /. m0), rv],\n      {rv, gridS}];\n    srcNew = Interpolation[Transpose[{gridS, vals}]];\n    m0new = solveMean[srcNew];\n    diff = Max[Table[Abs[(s0[rv] /. m0new) - (s0[rv] /. m0)],\n      {rv, 1., 24., 1.}]];\n    m0 = m0new; srcOld = srcNew;\n    it++];\n  {m0, sh, sc, diff, it}]', ('psib', 'theta', 'maxit')),
    ('qh', 'Module[{s0v, s0d, h},\n  s0v = s0[rv] /. m0; s0d = Derivative[1][s0 /. m0][rv];\n  h = Hfun[s0v];\n  rv ((h - kFix rv s0d)/g[rv])/((1/Abs[kFix]) *\n    (-(s0d + kFix rv h)/g[rv]))]', ('m0', 'rv')),
    ('drives', '{0.08, 0.32, 1.28, 2.56, 5.12}', ()),
    ('thetas', '{0.5, 0.5, 0.3, 0.15, 0.1}', ()),
    ('maxits', '{60, 60, 150, 300, 400}', ()),
    ('m0Undriven', 'solveMean[Function[rr, 0.]]', ()),
    ('resTbl', 'Table[Module[{m0, sh, sc, diff, it, dq},\n   {m0, sh, sc, diff, it} =\n     saturate[drives[[i]], thetas[[i]], maxits[[i]]];\n   dq = qh[m0, 1.] - qh[m0Undriven, 1.];\n   {drives[[i]], dq, diff, it}], {i, Length[drives]}]', ()),
    ('exponents', 'Table[\n  Log[Abs[resTbl[[i + 1, 2]]]/Abs[resTbl[[i, 2]]]]/\n  Log[drives[[i + 1]]/drives[[i]]], {i, Length[drives] - 1}]', ()),
    ('naive', 'saturate[5.12, 1.0, 40]', ()),
    ('figSat', 'GraphicsRow[{\n  ListLogLogPlot[Map[{#[[1]], Abs[#[[2]]]} &, resTbl],\n    Joined -> True, PlotMarkers -> Automatic, Frame -> True,\n    FrameLabel -> {"\\[Psi]b", "|\\[CapitalDelta]q_h(1)|"},\n    PlotLabel -> "mean response vs drive (slope 2 = quadratic)",\n    ImageSize -> 300],\n  Plot[{qh[m0Undriven, rv], qh[m0S, rv]}, {rv, 0.5, 24.},\n    PlotRange -> All, Frame -> True,\n    FrameLabel -> {"r", "q_h"},\n    PlotLegends -> {"undriven", "saturated, \\[Psi]b = 5.12"},\n    PlotLabel -> "saturated mean helical safety factor",\n    ImageSize -> 320]},\n  ImageSize -> 660]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/code-closure1d/43_helical_saturation.wl')
