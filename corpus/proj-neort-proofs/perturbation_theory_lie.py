"""Generated SymPy translation of ``corpus/proj-neort-proofs/perturbation_theory_lie.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 14 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('muScan', "Module[{sol, Bz, mu, tmax = 30, vals},\n   Bz[xx_] := 1 + alpha xx;\n   sol = NDSolve[{\n      x'[t] == vx[t], y'[t] == vy[t],\n      vx'[t] == vy[t] Bz[x[t]], vy'[t] == -vx[t] Bz[x[t]],\n      x[0] == 0, y[0] == 0, vx[0] == 1, vy[0] == 0},\n     {x, y, vx, vy}, {t, 0, tmax}, MaxSteps -> 10^6,\n     AccuracyGoal -> 10, PrecisionGoal -> 10][[1]];\n   mu[tt_] := ((vx[tt]^2 + vy[tt]^2)/(2 Bz[x[tt]])) /. sol;\n   vals = Table[mu[tt], {tt, 0, tmax, tmax/400}];\n   (Max[vals] - Min[vals])/Mean[vals]]", ('alpha',)),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-neort-proofs/perturbation_theory_lie.wl')
