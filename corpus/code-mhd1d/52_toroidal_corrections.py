"""Generated SymPy translation of ``corpus/code-mhd1d/52_toroidal_corrections.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 57 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('starLab', '(Derivative[2, 0][psiF][RR, ZZ] -\n    Derivative[1, 0][psiF][RR, ZZ]/RR +\n    Derivative[0, 2][psiF][RR, ZZ]) /.\n  {RR -> R0 + rr Cos[ww], ZZ -> rr Sin[ww]}', ()),
    ('polarF', 'psiF[R0 + a Cos[b], a Sin[b]]', ('a', 'b')),
    ('starPolar', 'D[polarF[rr, ww], {rr, 2}] + D[polarF[rr, ww], rr]/rr +\n  D[polarF[rr, ww], {ww, 2}]/rr^2 -\n  (1/(R0 + rr Cos[ww])) (Cos[ww] D[polarF[rr, ww], rr] -\n     Sin[ww] D[polarF[rr, ww], ww]/rr)', ()),
    ('psiField', 'psi0[rr] + lam chi[rr] Cos[ww]', ()),
    ('gsScaled', 'D[psiField, {rr, 2}] + D[psiField, rr]/rr +\n  D[psiField, {ww, 2}]/rr^2 -\n  (lam/(1 + lam rr Cos[ww])) (Cos[ww] D[psiField, rr] -\n     Sin[ww] D[psiField, ww]/rr) +\n  4 Pi (1 + lam rr Cos[ww])^2 ptil[psiField] + ff[psiField]', ()),
    ('gsSeries', 'Normal[Series[gsScaled, {lam, 0, 1}]]', ()),
    ('meanProj', 'Simplify[Integrate[gsSeries, {ww, 0, 2 Pi}]/(2 Pi)]', ()),
    ('cosProj', 'Simplify[Integrate[gsSeries Cos[ww], {ww, 0, 2 Pi}]/Pi]', ()),
    ('meanExpect', "psi0''[rr] + psi0'[rr]/rr + 4 Pi ptil[psi0[rr]] + ff[psi0[rr]]", ()),
    ('cosExpect', "lam (chi''[rr] + chi'[rr]/rr - chi[rr]/rr^2 - psi0'[rr] +\n    8 Pi rr ptil[psi0[rr]] +\n    (4 Pi ptil'[psi0[rr]] + ff'[psi0[rr]]) chi[rr])", ()),
    ('qsrc', "-(psi0''[x] + psi0'[x]/x)", ('x',)),
    ('kcoef', "D[qsrc[x], x]/psi0'[x]", ('x',)),
    ('lOp', 'D[f[x], {x, 2}] + D[f[x], x]/x - f[x]/x^2 + kcoef[x] f[x]', ('f', 'x')),
    ('chiShift', "-delta[x] psi0'[x]", ('x',)),
    ('deltaPrime', '-(ib[x] - 8 Pi ip[x])/(R0 x bth[x]^2)', ('x',)),
    ('liOf', '2 ib[x]/(x^2 bth[x]^2)', ('x',)),
    ('betaPOf', '-8 Pi ip[x]/(x^2 bth[x]^2)', ('x',)),
    ('bthFlat', 'Ba x/aMinor', ('x',)),
    ('pFlat', 'p0 (1 - x^2/aMinor^2)', ('x',)),
    ('ppFlat', 'D[pFlat[x], x]', ('x',)),
    ('ibFlat', 'Integrate[bthFlat[s]^2 s, {s, 0, x}]', ('x',)),
    ('ipFlat', 'Integrate[s^2 ppFlat[s], {s, 0, x}]', ('x',)),
    ('liFlat', 'Simplify[2 ibFlat[rr]/(rr^2 bthFlat[rr]^2)]', ()),
    ('betaPFlat', 'Simplify[-8 Pi ipFlat[rr]/(rr^2 bthFlat[rr]^2)]', ()),
    ('deltaFlat', '(aMinor^2 - x^2) (betaPFlat + 1/4)/(2 R0)', ('x',)),
    ('rGeom', '1/lam + lam d2 + rr Cos[ww]', ()),
    ('qKernel', '(1 + lam d2p Cos[ww]) (1/lam)/rGeom', ()),
    ('qAverage', 'Simplify[Integrate[Normal[Series[qKernel, {lam, 0, 2}]],\n    {ww, 0, 2 Pi}]/(2 Pi)]', ()),
    ('gFactorOf', "x^2/(2 R0^2) - dfun[x]/R0 - x dfun'[x]/(2 R0)", ('dfun', 'x')),
    ('gFactor', 'gFactorOf[delta, x]', ('x',)),
    ('deltaBeta', 'betaOff (aMinor^2 - x^2)/(2 R0)', ('x',)),
    ('harm', 'psiHat[rr] Cos[mm ww - phiAng]', ()),
    ('torPart', '-(1/R0) (Cos[ww] D[harm, rr] - Sin[ww] D[harm, ww]/rr)', ()),
    ('sidebandExpect', "-(1/(2 R0)) (\n    (psiHat'[rr] - mm psiHat[rr]/rr) Cos[(mm + 1) ww - phiAng] +\n    (psiHat'[rr] + mm psiHat[rr]/rr) Cos[(mm - 1) ww - phiAng])", ()),
    ('pressDrive', '4 Pi R0^2 (2 (rr/R0) Cos[ww]) pflux2[psi0[rr]] psiHat[rr] *\n  Cos[ww - phiAng]', ()),
    ('pressUp', 'Simplify[\n  Integrate[pressDrive Cos[2 ww - phiAng], {ww, 0, 2 Pi}]/Pi]', ()),
    ('pressDown', 'Simplify[\n  Integrate[pressDrive, {ww, 0, 2 Pi}]/(2 Pi Cos[phiAng])]', ()),
    ('kapRatio', 'm (1 - n qq)/(m - n qq)', ('m', 'qq', 'n')),
    ('deltaWT', '3 Pi^2 (R0 B0^2/mu0) (r1/R0)^4 xi0^2 (13/144 - bp^2)', ('bp',)),
    ('deltaModel', 'gscale x^2/R0', ('x',)),
    ('gScaled', 'Simplify[gFactorOf[deltaModel, rr] /. R0 -> rr/eps]', ()),
    ('rootDir', 'DirectoryName[DirectoryName[$InputFileName]]', ()),
    ('scan', 'Import[FileNameJoin[{rootDir, "runs", "mhd1d",\n   "toroidal_sensitivity", "results", "summary.json"}], "RawJSON"]', ()),
    ('rows', 'scan["results"]', ()),
    ('pickA', 'SelectFirst[rows,\n  #["set"] == "A_forcefree_betap_scan" && #["q0_requested"] == q0 &&\n    #["beta_p_offset"] == 0. &]', ('q0',)),
    ('pickB', 'SelectFirst[rows,\n  #["set"] == "B_epsilon_scan" && #["q0_requested"] == q0 &&\n    #["beta_p_offset"] == 0. && Abs[#["epsilon_edge"] - ee] < 10^-9 &]', ('q0', 'ee')),
    ('pickC', 'SelectFirst[rows,\n  #["set"] == "C_aug_scaled" && #["r_edge_cm"] == aa &&\n    #["beta_p_offset"] == bp &]', ('aa', 'bp')),
    ('convRatio', 'pickB[1.1, 0.05]["relative_gain_change"]/\n  pickB[1.1, 0.02]["relative_gain_change"]', ()),
    ('sb2Ratio', 'pickB[1.1, 0.05]["sideband2_over_psi1"]/\n  pickB[1.1, 0.02]["sideband2_over_psi1"]', ()),
    ('access', 'Import[FileNameJoin[{rootDir, "runs", "mhd1d",\n   "toroidal_sensitivity", "results", "bussac_access.json"}], "RawJSON"]', ()),
    ('diiid', 'access["cases"][[1]]', ()),
    ('augCase', 'access["cases"][[2]]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/code-mhd1d/52_toroidal_corrections.wl')
