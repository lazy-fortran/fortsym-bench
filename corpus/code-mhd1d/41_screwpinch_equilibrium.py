"""Generated SymPy translation of ``corpus/code-mhd1d/41_screwpinch_equilibrium.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 22 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('figdir', 'FileNameJoin[{DirectoryName[$InputFileName], "figures"}]', ()),
    ('datadir', 'FileNameJoin[{DirectoryName[$InputFileName], "..", "mhd1d",\n  "test", "data"}]', ()),
    ('$Assumptions', 'r > 0 && c > 0 && B0 > 0', ()),
    ('B2', 'Bt[r]^2 + Bz[r]^2', ()),
    ('jtAmp', "-(c/(4 Pi)) Bz'[r]", ()),
    ('jzAmp', '(c/(4 Pi)) D[r Bt[r], r]/r', ()),
    ('ode1', "jtAmp == lam[r] Bt[r] + c p'[r] Bz[r]/B2", ()),
    ('ode2', "jzAmp == lam[r] Bz[r] - c p'[r] Bt[r]/B2", ()),
    ('fbResidual', "Simplify[p'[r] -\n  ((lam[r] Bt[r] + c p'[r] Bz[r]/B2) Bz[r] -\n   (lam[r] Bz[r] - c p'[r] Bt[r]/B2) Bt[r])/c]", ()),
    ('consForm', "Simplify[D[p[r] + B2/(8 Pi), r] + Bt[r]^2/(4 Pi r) /.\n  {Bz'[r] -> -(4 Pi/c) (lam[r] Bt[r] + c p'[r] Bz[r]/B2),\n   Bt'[r] -> (4 Pi/c) (lam[r] Bz[r] - c p'[r] Bt[r]/B2) - Bt[r]/r}]", ()),
    ('lundquist', '{Bt -> Function[x, B0 BesselJ[1, alphaL x]],\n  Bz -> Function[x, B0 BesselJ[0, alphaL x]]}', ()),
    ('thetaPinch', '{Bt -> Function[x, 0],\n  Bz -> Function[x, Sqrt[8 Pi (pEdge - p[x]) + BzEdge^2]]}', ()),
    ('zPinchFB', 'Simplify[fbResidual /. Bz -> Function[x, 0]]', ()),
    ('btSer', 'a1 r + a3 r^3', ()),
    ('bzSer', 'Bz0 + b2 r^2', ()),
    ('lamSer', 'lam0 + lam2 r^2', ()),
    ('pSer', 'pc + p2 r^2', ()),
    ('serRules', '{Bt -> Function[x, Evaluate[btSer /. r -> x]],\n  Bz -> Function[x, Evaluate[bzSer /. r -> x]],\n  lam -> Function[x, Evaluate[lamSer /. r -> x]],\n  p -> Function[x, Evaluate[pSer /. r -> x]]}', ()),
    ('a1Sol', 'Solve[Normal@Series[(ode2 /. Equal -> Subtract) /. serRules,\n    {r, 0, 0}] == 0, a1]', ()),
    ('cFix', '1.', ()),
    ('B0fix', '1.', ()),
    ('R0fix', '20.', ()),
    ('aFix', '25.', ()),
    ('q0Target', '1.05', ()),
    ('lam0Fix', 'cFix/(2 Pi R0fix q0Target)', ()),
    ('p0Fix', '2. 10^-3', ()),
    ('pFun', 'p0Fix (1 - (rr/aFix)^2)^2', ('rr',)),
    ('lamFun', 'lam0Fix Exp[-(rr/12.)^2]', ('rr',)),
    ('eps0', '10^-8', ()),
    ('sol', "NDSolve[{\n  bz'[rr] == -(4 Pi/cFix) (lamFun[rr] bt[rr] +\n    cFix pFun'[rr] bz[rr]/(bt[rr]^2 + bz[rr]^2)),\n  bt'[rr] == (4 Pi/cFix) (lamFun[rr] bz[rr] -\n    cFix pFun'[rr] bt[rr]/(bt[rr]^2 + bz[rr]^2)) - bt[rr]/rr,\n  bz[eps0] == B0fix, bt[eps0] == 2 Pi lam0Fix B0fix eps0/cFix},\n  {bt, bz}, {rr, eps0, aFix},\n  AccuracyGoal -> 12, PrecisionGoal -> 12, MaxSteps -> 10^6][[1]]", ()),
    ('btN', 'bt[rr] /. sol', ('rr',)),
    ('bzN', 'bz[rr] /. sol', ('rr',)),
    ('qN', 'rr bzN[rr]/(R0fix btN[rr])', ('rr',)),
    ('btD', 'Derivative[1][bt /. sol][rr]', ('rr',)),
    ('bzD', 'Derivative[1][bz /. sol][rr]', ('rr',)),
    ('scaleNum', 'p0Fix/aFix + B0fix^2/(8 Pi aFix)', ()),
    ('fmtNum', 'StringReplace[ToString[N[x], InputForm], "*^" -> "e"]', ('x',)),
    ('writeCsv', 'Module[{s = OpenWrite[file]},\n  WriteString[s, header <> "\\n"];\n  WriteString[s, StringRiffle[\n    Map[StringRiffle[Map[fmtNum, #], ","] &, rows], "\\n"] <> "\\n"];\n  Close[s]]', ('file', 'header', 'rows')),
    ('gridR', 'Table[rv, {rv, 0.25, 25., 0.25}]', ()),
    ('fixtureRows', 'Map[{#, pFun[#], lamFun[#], btN[#], bzN[#], qN[#]} &,\n  gridR]', ()),
    ('alphaFix', '0.05', ()),
    ('lundRows', 'Map[{#, alphaFix cFix/(4 Pi),\n  B0fix BesselJ[1, alphaFix #], B0fix BesselJ[0, alphaFix #]} &, gridR]', ()),
    ('figSP', 'GraphicsRow[{\n  Plot[{btN[rv], bzN[rv]}, {rv, 0.01, 25.}, PlotRange -> All,\n    Frame -> True, FrameLabel -> {"r", "B"},\n    PlotLegends -> {"B_theta", "B_z"}, ImageSize -> 300,\n    PlotLabel -> "fixture equilibrium field"],\n  Plot[qN[rv], {rv, 0.01, 25.}, PlotRange -> All, Frame -> True,\n    FrameLabel -> {"r", "q"}, ImageSize -> 300,\n    PlotLabel -> "safety factor, q(0) = 1.05"]},\n  ImageSize -> 640]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/code-mhd1d/41_screwpinch_equilibrium.wl')
