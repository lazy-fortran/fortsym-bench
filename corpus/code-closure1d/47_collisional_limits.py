"""Generated SymPy translation of ``corpus/code-closure1d/47_collisional_limits.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 17 non-assignment statement(s) remain.
COMPARE = {
    'fmtNum': 'numeric',
}
_ASSIGNMENTS = [
    ('datadir', 'FileNameJoin[{DirectoryName[$InputFileName], "..", "kin1d",\n  "test", "data"}]', ()),
    ('L31', '(1 + 0.15/(Z^1.2 - 0.71)) X - 0.22/(Z^1.2 - 0.71) X^2 +\n  0.01/(Z^1.2 - 0.71) X^3 + 0.06/(Z^1.2 - 0.71) X^4', ('X', 'Z')),
    ('ft31', 'ft/(1 +\n  0.67 (1 - 0.7 ft) Sqrt[nue]/(0.56 + 0.44 Z) +\n  (0.52 + 0.086 Sqrt[nue]) (1 + 0.87 ft) nue/(1 + 1.13 Sqrt[Z - 1]))', ('ft', 'nue', 'Z')),
    ('F32ee', '(0.1 + 0.6 Z)/(Z (0.77 + 0.63 (1 + (Z - 1)^1.1))) *\n   (X - X^4) +\n  0.7/(1 + 0.2 Z) (X^2 - X^4 - 1.2 (X^3 - X^4)) +\n  1.3/(1 + 0.5 Z) X^4', ('X', 'Z')),
    ('ft32ee', 'ft/(1 +\n  0.23 (1 - 0.96 ft) Sqrt[nue]/Sqrt[Z] +\n  0.13 (1 - 0.38 ft) nue/Z^2 *\n   (Sqrt[1 + 2 Sqrt[Z - 1]] +\n    ft^2 Sqrt[(0.075 + 0.25 (Z - 1)^2) nue]))', ('ft', 'nue', 'Z')),
    ('F32ei', '-(0.4 + 1.93 Z)/(Z (0.8 + 0.6 Z)) (X - X^4) +\n  5.5/(1.5 + 2 Z) (X^2 - X^4 - 0.8 (X^3 - X^4)) -\n  1.3/(1 + 0.5 Z) X^4', ('X', 'Z')),
    ('ft32ei', 'ft/(1 +\n  0.87 (1 + 0.39 ft) Sqrt[nue]/(1 + 2.95 (Z - 1)^2) +\n  1.53 (1 - 0.37 ft) nue (2 + 0.375 (Z - 1)))', ('ft', 'nue', 'Z')),
    ('L32', 'F32ee[ft32ee[ft, nue, Z], Z] +\n  F32ei[ft32ei[ft, nue, Z], Z]', ('ft', 'nue', 'Z')),
    ('sigRatio', '1 - (1 + 0.21/Z) X + 0.54/Z X^2 - 0.33/Z X^3', ('X', 'Z')),
    ('ft33', 'ft/(1 +\n  0.25 (1 - 0.7 ft) Sqrt[nue] (1 + 0.45 Sqrt[Z - 1]) +\n  0.61 (1 - 0.41 ft) nue/Sqrt[Z])', ('ft', 'nue', 'Z')),
    ('alpha0R', '-(0.62 + 0.055 (Z - 1))/(0.53 + 0.17 (Z - 1)) *\n  (1 - ft)/(1 - (0.31 - 0.065 (Z - 1)) ft - 0.25 ft^2)', ('ft', 'Z')),
    ('alphaR', '((alpha0R[ft, Z] + 0.7 Z Sqrt[ft] Sqrt[nui])/(1 + 0.18 Sqrt[nui]) -\n   0.002 nui^2 ft^6)/(1 + 0.004 nui^2 ft^6)', ('ft', 'nui', 'Z')),
    ('readCsv', 'Map[ToExpression[StringReplace[#, "e" -> "*10^"]] &,\n  Map[StringSplit[#, ","] &,\n    Select[ReadList[file, String], !StringStartsQ[#, "#"] &]], {2}]', ('file',)),
    ('refTbl', 'readCsv[FileNameJoin[{datadir, "redl_reference.csv"}]]', ()),
    ('driftErr', 'Max[Map[Module[{ftv = #[[1]], nuv = #[[2]], zv = #[[3]]},\n   Max[Abs[{L31[ft31[ftv, nuv, zv], zv], L32[ftv, nuv, zv],\n      sigRatio[ft33[ftv, nuv, zv], zv], alphaR[ftv, nuv, zv]} -\n     #[[4 ;; 7]]]]] &, refTbl]]', ()),
    ('nuBig', '10.^8', ()),
    ('nS', '7', ()),
    ('bzS', 'Array[bz, nS]', ()),
    ('bS', 'Array[bmag, nS]', ()),
    ('wS', 'Array[w, nS]', ()),
    ('avg', 'Sum[wS[[i]] x[[i]], {i, nS}]/Sum[wS[[i]], {i, nS}]', ('x',)),
    ('Csol', 'ea avg[bzS]/avg[bS^2]', ()),
    ('isoTbl', 'readCsv[FileNameJoin[{datadir, "isomap_fixture.csv"}]]', ()),
    ('ftFix', 'Max[isoTbl[[All, 7]]]', ()),
    ('sigCorr', '1 - sigRatio[ft33[ftFix, 0.5, 1.], 1.]', ()),
    ('ftGrid', 'Range[0.05, 0.9, 0.05]', ()),
    ('nuGrid', '10.^Range[-2., 3., 0.5]', ()),
    ('lnLeF', '31.3 - Log[Sqrt[ne]/TeEV]', ('ne', 'TeEV')),
    ('lnLiiF', '30 - Log[Zi^3 Sqrt[ni]/TiEV^(3/2)]', ('ni', 'TiEV', 'Zi')),
    ('nuRatioPure', '(4.90/6.921) lnLiiF[ne, TeEV, 1]/lnLeF[ne, TeEV]', ('ne', 'TeEV')),
    ('ratioAUG', 'nuRatioPure[0.98 10^20, 5130.]', ()),
    ('row10', 'First[Select[isoTbl, Abs[#[[1]] - 10.] < 10^-9 &]]', ()),
    ('nuEOf', '0.5 Abs[(row[[5]]/row[[3]])/(row10[[5]]/row10[[3]])]', ('row',)),
    ('fmtNum', 'StringReplace[ToString[N[x], InputForm], "*^" -> "e"]', ('x',)),
    ('writeCsv', 'Module[{s = OpenWrite[file]},\n  WriteString[s, header <> "\\n"];\n  WriteString[s, StringRiffle[\n    Map[StringRiffle[Map[fmtNum, #], ","] &, rows], "\\n"] <> "\\n"];\n  Close[s]]', ('file', 'header', 'rows')),
    ('profRows', 'Map[Module[{ftv = #[[7]], nuev = nuEOf[#],\n    nuiv = ratioAUG nuEOf[#]},\n   {#[[1]], ftv, nuev, nuiv,\n    L31[ft31[ftv, nuev, 1.], 1.],\n    L32[ftv, nuev, 1.],\n    sigRatio[ft33[ftv, nuev, 1.], 1.],\n    alphaR[ftv, nuiv, 1.]}] &, isoTbl]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/code-closure1d/47_collisional_limits.wl')
