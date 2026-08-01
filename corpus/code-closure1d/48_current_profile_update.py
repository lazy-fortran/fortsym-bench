"""Generated SymPy translation of ``corpus/code-closure1d/48_current_profile_update.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 14 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('$Assumptions', 'r > 0 && Element[{u, k}, Reals] && c > 0', ()),
    ('gradH', '{D[f, r], D[f, u]/r, k D[f, u]}', ('f',)),
    ('g', '1 + k^2 r^2', ('r',)),
    ('Bhel', '{D[psi[r, u], u]/r,\n  -(D[psi[r, u], r] + k r Hf[psi[r, u]])/g[r],\n  (Hf[psi[r, u]] - k r D[psi[r, u], r])/g[r]}', ()),
    ('jHel', '(c/(4 Pi)) curlH[Bhel]', ()),
    ('jdotB', 'Simplify[Together[jHel . Bhel]]', ()),
    ('gradPsi2', 'D[psi[r, u], r]^2/g[r] + D[psi[r, u], u]^2/r^2', ()),
    ('gsOperator', '(D[psi[r, u], {u, 2}] (1 + k^2 r^2)/r^2 +\n   D[psi[r, u], r] (1 - k^2 r^2)/(r (1 + k^2 r^2)) +\n   D[psi[r, u], {r, 2}])/1', ()),
    ('remainder', "Simplify[Together[(4 Pi/c) jdotB -\n   Hf'[psi[r, u]] gradPsi2 + Hf[psi[r, u]] gsOperator/g[r]]]", ()),
    ('Ssrc', "Hf[psi[r, u]] (2 k + g[r] Hf'[psi[r, u]])/g[r]^2 +\n  4 Pi PF'[psi[r, u]]", ()),
    ('onShell', "(c/(4 Pi)) (Hf'[psi[r, u]] (gradPsi2 +\n    Hf[psi[r, u]]^2/g[r]) + 4 Pi Hf[psi[r, u]] PF'[psi[r, u]])", ()),
    ('ffRules', '{Hf -> Function[s, H0 - a s], PF -> Function[s, p0c]}', ()),
    ('resFF', 'Simplify[(curlH[Bhel] + a Bhel) /. ffRules]', ()),
    ('gsShellFF', 'Solve[((gsOperator/g[r]) /. ffRules) +\n    (Ssrc /. ffRules) == 0, D[psi[r, u], {r, 2}]][[1]]', ()),
    ('axiRules', '{psi -> Function[{rr, uu}, ps0[rr]], k -> 0}', ()),
    ('jdotBaxi', 'Simplify[jdotB /. axiRules]', ()),
    ('readCsv', 'Map[ToExpression[StringReplace[#, "e" -> "*10^"]] &,\n  Map[StringSplit[#, ","] &,\n    Select[ReadList[file, String], !StringStartsQ[#, "#"] &]], {2}]', ('file',)),
    ('fixTbl', 'readCsv[FileNameJoin[{DirectoryName[$InputFileName], "..",\n   "mhd1d", "test", "data", "helical_forcefree.csv"}]]', ()),
    ('aFix', '0.08', ()),
    ('kFix', '-1/20.', ()),
    ('H0fix', '1.', ()),
    ('gF', '1 + kFix^2 r^2', ('r',)),
    ('psi0pOf', 'Module[{n = Length[fixTbl]},\n  Which[i == 1, (fixTbl[[2, 2]] - fixTbl[[1, 2]])/\n     (fixTbl[[2, 1]] - fixTbl[[1, 1]]),\n   i == n, (fixTbl[[n, 2]] - fixTbl[[n - 1, 2]])/\n     (fixTbl[[n, 1]] - fixTbl[[n - 1, 1]]),\n   True, (fixTbl[[i + 1, 2]] - fixTbl[[i - 1, 2]])/\n     (fixTbl[[i + 1, 1]] - fixTbl[[i - 1, 1]])]]', ('i',)),
    ('roundTrip', 'Table[Module[{rv, p0v, hv, p0p, jb, hpBack},\n   rv = fixTbl[[i, 1]]; p0v = fixTbl[[i, 2]];\n   hv = H0fix - aFix p0v; p0p = psi0pOf[i];\n   jb = (-aFix) (p0p^2 + hv^2)/gF[rv];\n   hpBack = jb/((p0p^2 + hv^2)/gF[rv]);\n   Abs[hpBack + aFix]], {i, 10, Length[fixTbl] - 10, 10}]', ()),
    ('nConv', '10^6', ()),
    ('tConv', '1.602176634 10^-12', ()),
    ('sigConv', '8.9875517923 10^9', ()),
    ('sigmaSI1keV', '1/(2.584035 10^-8)', ()),
    ('sigmaCGS1keV', 'sigConv sigmaSI1keV', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/code-closure1d/48_current_profile_update.wl')
