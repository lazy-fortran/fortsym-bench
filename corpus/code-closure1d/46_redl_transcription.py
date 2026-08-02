"""Generated SymPy translation of ``corpus/code-closure1d/46_redl_transcription.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 26 non-assignment statement(s) remain.
COMPARE = {
    'fmtNum': 'numeric',
}
_ASSIGNMENTS = [
    ('datadir', 'FileNameJoin[{DirectoryName[$InputFileName], "..", "kin1d",\n  "test", "data"}]', ()),
    ('$Assumptions', '0 <= ft <= 1 && nue >= 0 && nui >= 0 && Z >= 1', ()),
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
    ('alpha0S', '-1.17 (1 - ft)/(1 - 0.22 ft - 0.19 ft^2)', ('ft',)),
    ('alphaS', '((alpha0S[ft] + 0.25 (1 - ft^2) Sqrt[nui])/(1 + 0.5 Sqrt[nui]) +\n   0.315 nui^2 ft^6)/(1 + 0.15 nui^2 ft^6)', ('ft', 'nui')),
    ('NofZ', '0.58 + 0.74/(0.76 + Z)', ('Z',)),
    ('lnLe', '31.3 - Log[Sqrt[ne]/TeEV]', ('ne', 'TeEV')),
    ('lnLii', '30 - Log[Zi^3 Sqrt[ni]/TiEV^(3/2)]', ('ni', 'TiEV', 'Zi')),
    ('sigSptz', '1.9012 10^4 TeEV^(3/2)/(Z NofZ[Z] lnL)', ('TeEV', 'Z', 'lnL')),
    ('nuStarE', '6.921 10^-18 qs RR ne Z lnL/(TeEV^2 eps^(3/2))', ('qs', 'RR', 'ne', 'Z', 'lnL', 'TeEV', 'eps')),
    ('nuStarI', '4.90 10^-18 qs RR ni Zi^4 lnL/(TiEV^2 eps^(3/2))', ('qs', 'RR', 'ni', 'Zi', 'lnL', 'TiEV', 'eps')),
    ('jparB', 'sneo EparB - Ipsi (p L31v dlnn + pe (L31v + L32v) dlnTe +\n    (L31v + L31v alphav) pisum dlnTi)', ('sneo', 'EparB', 'Ipsi', 'p', 'pe', 'pisum', 'L31v', 'L32v', 'alphav', 'dlnn', 'dlnTe', 'dlnTi')),
    ('etaSpitzer1keV', '1/sigSptz[1000., 1., lnLe[5. 10^19, 1000.]]', ()),
    ('TeAUG', 'TeEV /. FindRoot[1/sigSptz[TeEV, 1., lnLe[0.98 10^20, TeEV]] ==\n    2.41 10^-9, {TeEV, 4000.}]', ()),
    ('nuEAug', 'nuStarE[21., 1.716, 0.98 10^20, 1.,\n  lnLe[0.98 10^20, TeAUG], TeAUG, 0.1]', ()),
    ('fmtNum', 'StringReplace[ToString[N[x], InputForm], "*^" -> "e"]', ('x',)),
    ('writeCsv', 'Module[{s = OpenWrite[file]},\n  WriteString[s, header <> "\\n"];\n  WriteString[s, StringRiffle[\n    Map[StringRiffle[Map[fmtNum, #], ","] &, rows], "\\n"] <> "\\n"];\n  Close[s]]', ('file', 'header', 'rows')),
    ('samples', 'Flatten[Table[{ftv, nuv, zv},\n  {ftv, {0.05, 0.2, 0.5, 0.8}}, {nuv, {0.01, 0.3, 3.}},\n  {zv, {1., 1.8}}], 2]', ()),
    ('refRows', 'Map[Module[{ftv = #[[1]], nuv = #[[2]], zv = #[[3]]},\n   {ftv, nuv, zv,\n    L31[ft31[ftv, nuv, zv], zv],\n    L32[ftv, nuv, zv],\n    sigRatio[ft33[ftv, nuv, zv], zv],\n    alphaR[ftv, nuv, zv]}] &, samples]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/code-closure1d/46_redl_transcription.wl')
