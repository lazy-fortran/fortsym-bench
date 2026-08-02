"""Generated SymPy translation of ``corpus/proj-gvec-stability/solovev_axisymmetric_marginal.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 36 non-assignment statement(s) remain.
COMPARE = {
    'boundaryRows': 'numeric',
    'gradOnBoundary': 'numeric',
    'profileRows': 'numeric',
    'scalarRows': 'numeric',
}
_ASSIGNMENTS = [
    ('pass', '0', ()),
    ('fail', '0', ()),
    ('check', 'If[TrueQ[condition],\n  pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]]', ('name', 'condition')),
    ('zeroQ', 'SameQ[Together[expr], 0]', ('expr',)),
    ('zeroTrigQ', 'SameQ[Simplify[TrigReduce[expr]], 0]', ('expr',)),
    ('$Assumptions', 'e > 0 && a > 0 && r0 > a && psio > 0 && q0 > 0 &&', ()),
    ('psifac', 'psio/(a r0)^2', ()),
    ('pfac', '2 psio^2 (e^2 + 1)/(a r0 e)^2', ()),
    ('psi', 'psio - psifac ((R Z/e)^2 + (R^2 - r0^2)^2/4)', ('R', 'Z')),
    ('deltaStar', 'R D[D[psi[R, Z], R]/R, R] + D[psi[R, Z], {Z, 2}]', ()),
    ('mu0pPrime', 'pfac/psio', ()),
    ('psiRR', 'D[psi[R, Z], {R, 2}] /. {R -> r0, Z -> 0}', ()),
    ('psiZZ', 'D[psi[R, Z], {Z, 2}] /. {R -> r0, Z -> 0}', ()),
    ('qAxis', 'f0/(r0 Sqrt[psiRR psiZZ]) // Simplify', ()),
    ('rSq', 'r0^2 + 2 a r0 sig Cos[w]', ()),
    ('rW', 'Sqrt[rSq]', ()),
    ('zW', 'e a r0 sig Sin[w]/rW', ()),
    ('dlSq', 'D[rW, w]^2 + D[zW, w]^2 // Simplify', ()),
    ('gradPsiSq', '(D[psi[R, Z], R]^2 + D[psi[R, Z], Z]^2) /.', ()),
    ('integrandSq', 'dlSq/(rSq gradPsiSq) // Simplify', ()),
    ('eV', '8/5', ()),
    ('aV', '33/100', ()),
    ('r0V', '1', ()),
    ('f0V', '1', ()),
    ('q0V', '19/10', ()),
    ('values', '{e -> eV, a -> aV, r0 -> r0V, f0 -> f0V,\n   psio -> eV f0V aV^2/(2 q0V r0V)}', ()),
    ('intSqValues', 'Simplify[integrandSq /. values]', ()),
    ('gradOnBoundary', 'Table[\n   N[(rSq gradPsiSq /. values) /. {sig -> 1, w -> wS}, 20],\n   {wS, Range[0, 2 Pi, Pi/36]}]', ()),
    ('qEdge', 'q0V bigQ[1]', ()),
    ('psioV', 'psio /. values', ()),
    ('phiLine', "NDSolveValue[\n   {phi'[u] == 4 Pi psioV q0V bigQ[u] u, phi[0] == 0}, phi, {u, 0, 1},\n   WorkingPrecision -> 25, PrecisionGoal -> 15, AccuracyGoal -> 20,\n   MaxStepSize -> 1/64]", ()),
    ('jacobianRZ', 'Simplify[(D[rW, sig] D[zW, w] - D[rW, w] D[zW, sig]) /.\n    values]', ()),
    ('sGrid', 'Table[j/128, {j, 0, 128}]', ()),
    ('sValues', 'sOf /@ sGrid', ()),
    ('mMax', '36', ()),
    ('boundaryR', '(rW /. values /. sig -> 1) /. w -> wN', ('wN',)),
    ('boundaryZ', '(zW /. values /. sig -> 1) /. w -> wN', ('wN',)),
    ('periodicIntegral', 'NIntegrate[expr, {wN, 0, 2 Pi},\n   Method -> "Trapezoidal", WorkingPrecision -> 30,\n   PrecisionGoal -> 22, MaxRecursion -> 16]', ('expr',)),
    ('fourierR', 'Join[{periodicIntegral[boundaryR[wN]]/(2 Pi)},\n   Table[periodicIntegral[boundaryR[wN] Cos[m wN]]/Pi, {m, 1, mMax}]]', ()),
    ('fourierZ', 'Table[periodicIntegral[boundaryZ[wN] Sin[m wN]]/Pi,\n   {m, 1, mMax}]', ()),
    ('seriesR', 'fourierR[[1]] +\n   Sum[fourierR[[m + 1]] Cos[m wN], {m, 1, mMax}]', ('wN',)),
    ('seriesZ', 'Sum[fourierZ[[m]] Sin[m wN], {m, 1, mMax}]', ('wN',)),
    ('truncation', 'Max[Table[\n    Max[Abs[seriesR[wS] - boundaryR[wS]],\n     Abs[seriesZ[wS] - boundaryZ[wS]]],\n    {wS, Range[0.1, 2 Pi, 0.1]}]]', ()),
    ('psioTimesQ0', 'eV f0V aV^2/(2 r0V)', ()),
    ('pfacTimesQ0Sq', '2 psioTimesQ0^2 (eV^2 + 1)/(aV r0V eV)^2', ()),
    ('phiEdge', 'phiLine[1]', ()),
    ('dataDirectory', 'FileNameJoin[{DirectoryName[$InputFileName],\n    "..", "validation", "data"}]', ()),
    ('profileRows', 'Table[N[{sGrid[[j]], sGrid[[j]]^2, sValues[[j]],\n     bigQ[sGrid[[j]]], 1 - sGrid[[j]]^2}], {j, Length[sGrid]}]', ()),
    ('profilePath', 'FileNameJoin[{dataDirectory,\n    "solovev_profile_manifest.csv"}]', ()),
    ('boundaryRows', 'Table[\n   {m, N[fourierR[[m + 1]]], N[If[m == 0, 0, fourierZ[[m]]]]},\n   {m, 0, mMax}]', ()),
    ('boundaryPath', 'FileNameJoin[{dataDirectory,\n    "solovev_boundary_manifest.csv"}]', ()),
    ('scalarRows', '{\n   {"e", N[eV]}, {"a", N[aV]}, {"r0", N[r0V]}, {"f0", N[f0V]},\n   {"psio_times_q0", N[psioTimesQ0]},\n   {"pfac_times_q0sq", N[pfacTimesQ0Sq]},\n   {"phi_edge", N[phiEdge]},\n   {"q_edge_over_q0", N[bigQ[1]]}}', ()),
    ('scalarPath', 'FileNameJoin[{dataDirectory,\n    "solovev_scalars_manifest.csv"}]', ()),
    ('reProfile', 'Import[profilePath, "CSV"]', ()),
    ('reBack', 'reProfile[[2 ;;, 4]]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-gvec-stability/solovev_axisymmetric_marginal.wl')
