"""Generated SymPy translation of ``corpus/proj-cpp-derivation/info_limit.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 28 non-assignment statement(s) remain.
COMPARE = {
    'nearestAliasGap': 'numeric',
}
_ASSIGNMENTS = [
    ('pass', '0', ()),
    ('fail', '0', ()),
    ('check', 'Module[{c = TrueQ[cond]},\n  If[c, pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]]; c]', ('name', 'cond')),
    ('checkZero', 'Module[{c = TrueQ[And @@ (PossibleZeroQ /@ Flatten[{Simplify[expr]}])]},\n  If[c, pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]]; c]', ('name', 'expr')),
    ('sampledPhase', 'theta0 + j (Omega dt)', ('theta0', 'Omega', 'dt', 'j')),
    ('nearestAliasGap', 'Module[{k = Round[Om dt/(2 Pi)]}, N[Abs[Om dt - 2 Pi k]]]', ('Om', 'dt')),
    ('costRatio', '(2/jacBound)/(Pi/Omega)', ('Omega', 'jacBound')),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-cpp-derivation/info_limit.wl')
