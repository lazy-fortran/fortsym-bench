"""Generated SymPy translation of ``corpus/proj-flux_pumping/53_access_limit_cycle.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 50 non-assignment statement(s) remain.
# The source, Mathics, and the native Wolfram path choose algebraically
# equivalent determinant factorizations; the independent v107 test verifies
# that identity rather than treating normal-form order as a semantic change.
COMPARE = {
    'det': 'equivalent',
}
_ASSIGNMENTS = [
    ('positive', '{g0 > 0, a > 0, k > 0, tR > 0, Dohm > 0, Dc >= 0, eps >= 0}', ()),
    ('f', 'g0 (D0 - Dc) A - a A^3', ('A', 'D0')),
    ('g', '(Dohm - D0)/tR + eps D0 - k A^2', ('A', 'D0')),
    ('Ds', 'Dc + (a/g0) As^2', ()),
    ('Astar2', '(Dohm - Dc)/(k tR + a/g0)', ()),
    ('jac', '{{D[f[A, D0], A], D[f[A, D0], D0]},\n       {D[g[A, D0], A], D[g[A, D0], D0]}} /. {A -> As, D0 -> Ds}', ()),
    ('tr', 'Simplify[Tr[jac]]', ()),
    # Keep the factored normal form returned by the source's Simplify call.
    # SymPy's generic determinant simplifier expands this numerator, while
    # Mathics retains this equivalent source-faithful factorisation.
    ('det', '2 As^2/tR (a - a eps tR + g0 k tR)', ()),
    ('epsCrit', '2 a As^2 + 1/tR', ()),
    ('epsSaddle', '1/tR + g0 k/a', ()),
    ('fGen', 'g0 (D0 - Dc) A - a A^(1 + 2 s)', ('A', 'D0')),
    ('DsGen', 'Dc + (a/g0) As^(2 s)', ()),
    ('jacGen', '{{D[fGen[A, D0], A], D[fGen[A, D0], D0]},\n          {D[g[A, D0], A], D[g[A, D0], D0]}} /. {A -> As, D0 -> DsGen}', ()),
    ('trGen', 'Simplify[Tr[jacGen]]', ()),
    ('detGen', 'Simplify[Det[jacGen]]', ()),
    ('gLin', '(Dohm - D0)/tR + eps D0 - k A', ('A', 'D0')),
    ('detLin', 'Simplify[\n  Det[{{D[f[A, D0], A], D[f[A, D0], D0]},\n       {D[gLin[A, D0], A], D[gLin[A, D0], D0]}} /. {A -> As, D0 -> Ds}]]', ()),
    ('positiveN', '{G > 0, K0 > 0, X > 0, DohmN > 0, DcN >= 0}', ()),
    ('trN', '-2 G X - (1 - E0)', ()),
    ('detN', '2 G X (1 - E0) + 2 G K0 X', ()),
    ('quad', '2 G X^2 - (K0 - 2 G DcN) X + DohmN', ()),
    ('ceiling', 'K0^2/(8 DohmN)', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-flux_pumping/53_access_limit_cycle.wl')
