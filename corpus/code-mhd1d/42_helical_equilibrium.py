"""Generated SymPy translation of ``corpus/code-mhd1d/42_helical_equilibrium.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 48 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('figdir', 'FileNameJoin[{DirectoryName[$InputFileName], "figures"}]', ()),
    ('datadir', 'FileNameJoin[{DirectoryName[$InputFileName], "..", "mhd1d",\n  "test", "data"}]', ()),
    ('$Assumptions', 'r > 0 && Element[{u, k}, Reals]', ()),
    ('gradH', '{D[f, r], D[f, u]/r, k D[f, u]}', ('f',)),
    ('Bhel', '{D[psi[r, u], u]/r,\n  -(D[psi[r, u], r] + k r HH[r, u])/(1 + k^2 r^2),\n  (HH[r, u] - k r D[psi[r, u], r])/(1 + k^2 r^2)}', ()),
    ('fS', 'aa Sqrt[ss] iotS[ss]/R0', ()),
    ('jHel', '(c/(4 Pi)) curlH[Bhel]', ()),
    ('forceRes', 'Together[Cross[jHel, Bhel]/c - gradH[p[r, u]]]', ()),
    ('killing', 'Simplify[forceRes[[3]] - k r forceRes[[2]]]', ()),
    ('jacPsiH', '(D[psi[r, u], u] D[HH[r, u], r] -\n  D[psi[r, u], r] D[HH[r, u], u])/(4 Pi r)', ()),
    ('fluxRules', '{HH -> Function[{rr, uu}, Hf[psi[rr, uu]]],\n  p -> Function[{rr, uu}, PF[psi[rr, uu]]]}', ()),
    ('resFlux', 'Together[forceRes /. fluxRules]', ()),
    ('lambdaGS', 'Cancel[Together[resFlux[[1]]/D[psi[r, u], r]]]', ()),
    ('gsEq', 'Simplify[-4 Pi lambdaGS]', ()),
    ('axiLimit', 'Simplify[gsEq /. {psi -> Function[{rr, uu}, ps0[rr]],\n  k -> 0}]', ()),
    ('truncPsi', '{psi -> Function[{rr, uu}, ps0[rr] + eps ps1[rr] Cos[uu]]}', ()),
    ('gsTrunc', 'Normal@Series[gsEq /. truncPsi, {eps, 0, 2}]', ()),
    ('meanEq', 'Simplify[Integrate[gsTrunc, {u, 0, 2 Pi}]/(2 Pi)]', ()),
    ('harmEq', 'Simplify[Integrate[gsTrunc Cos[u], {u, 0, 2 Pi}]/Pi]', ()),
    ('mean0', 'Simplify[Coefficient[meanEq, eps, 0]]', ()),
    ('mean2', 'Simplify[Coefficient[meanEq, eps, 2]]', ()),
    ('harm1', 'Simplify[Coefficient[harmEq, eps, 1]]', ()),
    ('Ssrc', "Hf[s] (2 k + (1 + k^2 r^2) Hf'[s])/(1 + k^2 r^2)^2 +\n  4 Pi PF'[s]", ('s',)),
    ('srcSecond', 'Simplify[mean2 -\n  ((ps1[r]^2/4) D[Ssrc[s], {s, 2}] /. s -> ps0[r])]', ()),
    ('harmFF', 'Simplify[harm1 /. {Hf -> Function[s, h0 - a s],\n  PF -> Function[s, pc0]}]', ()),
    ('ffSol', 'Quiet[DSolve[harmFF == 0, ps1, r]]', ()),
    ('fmtNum', 'StringReplace[ToString[N[x], InputForm], "*^" -> "e"]', ('x',)),
    ('writeCsv', 'Module[{s = OpenWrite[file]},\n  WriteString[s, header <> "\\n"];\n  WriteString[s, StringRiffle[\n    Map[StringRiffle[Map[fmtNum, #], ","] &, rows], "\\n"] <> "\\n"];\n  Close[s]]', ('file', 'header', 'rows')),
    ('gridR', 'Table[rv, {rv, 0.25, 25., 0.25}]', ()),
    ('eps0', '10^-6', ()),
    ('rEdge', '25.', ()),
    ('psi1Edge', '0.02', ()),
    ('aFix', '0.08', ()),
    ('kFix', '-1/20.', ()),
    ('H0fix', '1.', ()),
    ('odeExpr', "expr /. {\n  ps0''[r] -> s0''[rr], ps0'[r] -> s0'[rr], ps0[r] -> s0[rr], r -> rr}", ('expr', 's0', 'rr')),
    ('mean0FF', 'mean0 /. {Hf -> Function[s, H0fix - aFix s],\n  PF -> Function[s, pc0], k -> kFix}', ()),
    ('sol0', "NDSolve[{odeExpr[mean0FF, s0, rr] == 0, s0[eps0] == 0,\n   s0'[eps0] == 0}, s0, {rr, eps0, rEdge},\n  AccuracyGoal -> 12, PrecisionGoal -> 12][[1]]", ()),
    ('harmFFfix', 'harmFF /. {h0 -> H0fix, a -> aFix, k -> kFix}', ()),
    ('harmOde', "expr /. {\n  Derivative[2][ps1][r] -> s1''[rr], Derivative[1][ps1][r] -> s1'[rr],\n  ps1[r] -> s1[rr],\n  ps0''[r] -> Derivative[2][s0 /. sol0][rr], ps0'[r] -> s0D[rr],\n  ps0[r] -> s0N[rr], r -> rr}", ('expr', 'rr')),
    ('shoot', "NDSolve[{harmOde[harmFFfix, rr] == 0, s1[eps0] == eps0,\n   s1'[eps0] == 1.}, s1, {rr, eps0, rEdge},\n  AccuracyGoal -> 12, PrecisionGoal -> 12][[1]]", ()),
    ('scaleShoot', 'psi1Edge/(s1[rEdge] /. shoot)', ()),
    ('bt0', '-(s0D[rv] + kFix rv (H0fix - aFix s0N[rv]))/\n  (1 + kFix^2 rv^2)', ('rv',)),
    ('bz0', '((H0fix - aFix s0N[rv]) - kFix rv s0D[rv])/\n  (1 + kFix^2 rv^2)', ('rv',)),
    ('helRows', 'Map[{#, s0N[#], s1N[#], bt0[#], bz0[#]} &, gridR]', ()),
    ('bFix', '0.01', ()),
    ('HfB', 'Function[s, H0fix - aFix s - bFix s^2/2]', ()),
    ('mean0B', 'mean0 /. {Hf -> HfB, PF -> Function[s, pc0], k -> kFix}', ()),
    ('sol0B', "NDSolve[{odeExpr[mean0B, s0, rr] == 0, s0[eps0] == 0,\n   s0'[eps0] == 0}, s0, {rr, eps0, rEdge},\n  AccuracyGoal -> 12, PrecisionGoal -> 12][[1]]", ()),
    ('harm1B', 'Simplify[harm1 /. {Hf -> HfB, PF -> Function[s, pc0],\n  k -> kFix}]', ()),
    ('harmOdeB', "harm1B /. {\n  Derivative[2][ps1][r] -> s1''[rr], Derivative[1][ps1][r] -> s1'[rr],\n  ps1[r] -> s1[rr],\n  ps0''[r] -> Derivative[2][s0 /. sol0B][rr], ps0'[r] -> s0BD[rr],\n  ps0[r] -> s0BN[rr], r -> rr}", ('rr',)),
    ('shootB', "NDSolve[{harmOdeB[rr] == 0, s1[eps0] == eps0, s1'[eps0] == 1.},\n  s1, {rr, eps0, rEdge},\n  AccuracyGoal -> 12, PrecisionGoal -> 12][[1]]", ()),
    ('scaleB', 'psi1Edge/(s1[rEdge] /. shootB)', ()),
    ('feedFun', "Function[{rv, p0v, p1v},\n  Evaluate[Simplify[(ps1[r]^2/4) D[\n      HfB[s] (2 k + (1 + k^2 r^2) HfB'[s])/(1 + k^2 r^2)^2, {s, 2}] /.\n    {s -> ps0[r], k -> kFix}] /.\n    {ps1[r] -> p1v, ps0[r] -> p0v, r -> rv}]]", ()),
    ('feedRows', 'Map[{#, s0BN[#], s1BN[#], feedFun[#, s0BN[#], s1BN[#]]} &,\n  gridR]', ()),
    ('figHel', 'GraphicsRow[{\n  Plot[{s0N[rv], 100 s1N[rv]}, {rv, 0.01, 25.}, PlotRange -> All,\n    Frame -> True, FrameLabel -> {"r", "\\[Psi]"},\n    PlotLegends -> {"\\[Psi]0", "100 \\[Psi]1"}, ImageSize -> 300,\n    PlotLabel -> "force-free helical equilibrium"],\n  ListLinePlot[feedRows[[All, {1, 4}]], PlotRange -> All, Frame -> True,\n    FrameLabel -> {"r", "mean feedback"}, ImageSize -> 300,\n    PlotLabel -> "nonlinear-H harmonic-on-mean source"]},\n  ImageSize -> 640]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/code-mhd1d/42_helical_equilibrium.wl')
