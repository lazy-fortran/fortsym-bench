"""Generated SymPy translation of ``corpus/code-closure1d/45_isomorphism_map.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 18 non-assignment statement(s) remain.
COMPARE = {
    'fmtNum': 'numeric',
}
_ASSIGNMENTS = [
    ('datadir', 'FileNameJoin[{DirectoryName[$InputFileName], "..", "kin1d",\n  "test", "data"}]', ()),
    ('mhdData', 'FileNameJoin[{DirectoryName[$InputFileName], "..", "mhd1d",\n  "test", "data"}]', ()),
    ('$Assumptions', 'r > 0 && R0 > 0 && m > 0', ()),
    ('Ifun', 'r Bt0[r]', ()),
    ('Gfun', 'R0 Bz0[r]', ()),
    ('iotaDef', 'R0 Bt0[r]/(r Bz0[r])', ()),
    ('NN', '-n/m', ()),
    ('kAx', 'n/R0', ()),
    ('Dfun', 'm Bt0[r]/r + kAx Bz0[r]', ()),
    ('iotaEff', 'iotaDef - NN', ()),
    ('Geff', 'Gfun + NN Ifun', ()),
    ('Ieff', 'Ifun', ()),
    ('nuGeom', '(Gfun + iotaDef Ifun)/iotaEff', ()),
    ('psitP', 'r Bz0[r]', ()),
    ('psipP', 'iotaEff psitP', ()),
    ('Psi0P', '-r Dfun', ()),
    ('readCsv', 'Map[ToExpression[StringReplace[#, "e" -> "*10^"]] &,\n  Map[StringSplit[#, ","] &,\n    Select[ReadList[file, String], !StringStartsQ[#, "#"] &]], {2}]', ('file',)),
    ('fix', 'readCsv[FileNameJoin[{mhdData, "helical_forcefree.csv"}]]', ()),
    ('aFix', '0.08', ()),
    ('kFix', '-1/20.', ()),
    ('R0fix', '20.', ()),
    ('H0fix', '1.', ()),
    ('mFix', '1', ()),
    ('gg', '1 + kFix^2 r^2', ('r',)),
    ('rowAt', 'First[Select[fix, Abs[#[[1]] - rv] < 10^-9 &]]', ('rv',)),
    ('psi1D', 'Module[{i},\n  i = First[FirstPosition[fix[[All, 1]], x_ /; Abs[x - rv] < 10^-9]];\n  If[i == 1 || i == Length[fix],\n    (fix[[Min[i + 1, Length[fix]], 3]] - fix[[Max[i - 1, 1], 3]])/\n      (fix[[Min[i + 1, Length[fix]], 1]] - fix[[Max[i - 1, 1], 1]]),\n    (fix[[i + 1, 3]] - fix[[i - 1, 3]])/(fix[[i + 1, 1]] - fix[[i - 1, 1]])]]', ('rv',)),
    ('Bmod', 'Module[{row, p0v, p1v, bt0v, bz0v, h1, br1, bt1, bz1},\n  row = rowAt[rv]; p0v = row[[2]]; p1v = row[[3]];\n  bt0v = row[[4]]; bz0v = row[[5]];\n  h1 = -aFix p1v Cos[u];\n  br1 = -(p1v/rv) Sin[u];\n  bt1 = -(psi1D[rv] Cos[u] + kFix rv h1)/gg[rv];\n  bz1 = (h1 - kFix rv psi1D[rv] Cos[u])/gg[rv];\n  Sqrt[(bt0v + bt1)^2 + (bz0v + bz1)^2 + br1^2]]', ('rv', 'u')),
    ('epsEff', 'Module[{bs},\n  bs = Table[Bmod[rv, u], {u, 0., 2 Pi, 2 Pi/720}];\n  (Max[bs] - Min[bs])/(Max[bs] + Min[bs])]', ('rv',)),
    ('fTrap', 'Module[{bs, bmax, h, h2avg, integrand},\n  bs = Table[Bmod[rv, u], {u, 0., 2 Pi - 10^-12, 2 Pi/720}];\n  bmax = Max[bs]; h = bs/bmax; h2avg = Mean[h^2];\n  integrand[lam_?NumericQ] := lam/Mean[Sqrt[Clip[1 - lam h, {0., 1.}]]];\n  1 - (3/4) h2avg NIntegrate[integrand[lam], {lam, 0, 1},\n    AccuracyGoal -> 8, PrecisionGoal -> 8, MaxRecursion -> 15]]', ('rv',)),
    ('rProbe', '10.', ()),
    ('epsP', 'epsEff[rProbe]', ()),
    ('ftInt', 'fTrap[rProbe]', ()),
    ('ftEst', '1.462 Sqrt[epsP]', ()),
    ('fTrapScaled', 'Module[{bs, bmax, h, h2avg, integrand, b0},\n  b0 = Mean[Table[Bmod[rv, u], {u, 0., 2 Pi - 10^-12, 2 Pi/720}]];\n  bs = Table[b0 + s (Bmod[rv, u] - b0),\n    {u, 0., 2 Pi - 10^-12, 2 Pi/720}];\n  bmax = Max[bs]; h = bs/bmax; h2avg = Mean[h^2];\n  integrand[lam_?NumericQ] := lam/Mean[Sqrt[Clip[1 - lam h, {0., 1.}]]];\n  1 - (3/4) h2avg NIntegrate[integrand[lam], {lam, 0, 1},\n    AccuracyGoal -> 8, PrecisionGoal -> 8, MaxRecursion -> 15]]', ('rv', 's')),
    ('ratio', 'fTrapScaled[rProbe, 2.]/fTrap[rProbe]', ()),
    ('fmtNum', 'StringReplace[ToString[N[x], InputForm], "*^" -> "e"]', ('x',)),
    ('writeCsv', 'Module[{s = OpenWrite[file]},\n  WriteString[s, header <> "\\n"];\n  WriteString[s, StringRiffle[\n    Map[StringRiffle[Map[fmtNum, #], ","] &, rows], "\\n"] <> "\\n"];\n  Close[s]]', ('file', 'header', 'rows')),
    ('gridOut', 'Range[2., 24., 2.]', ()),
    ('outRows', 'Map[Module[{row, iotav, iotaeffv, Gv, Iv, epsv, ftv},\n   row = rowAt[#];\n   iotav = R0fix row[[4]]/(# row[[5]]);\n   iotaeffv = iotav - 1;\n   Gv = R0fix row[[5]]; Iv = # row[[4]];\n   epsv = epsEff[#]; ftv = fTrap[#];\n   {#, iotav, iotaeffv, Gv + Iv, Gv + iotav Iv, epsv, ftv}] &, gridOut]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/code-closure1d/45_isomorphism_map.wl')
