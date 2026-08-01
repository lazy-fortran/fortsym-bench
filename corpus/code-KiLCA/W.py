"""Generated SymPy translation of ``corpus/code-KiLCA/W.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 1 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('AF', 'I*(omega - omegaL) - kp^2*(vT^2/nu), Null, BF[a_, b_] := vT^2*(a + I*(kp/nu))*(b + I*(kp/nu)), Null, CF[a_, b_] := (1/2)*vT^2*(a^2 + b^2) - I*(kp/nu)*vT^2*(a + b) + kp^2*(vT^2/nu^2), Null, W[m_, n_] := (-Sqrt[2*Pi])*(vT/AF)*D[D[Exp[CF[a, b] + BF[a, b]]*Button[Hypergeometric1F1, Inherited, BaseStyle -> "Link", ButtonData -> "paclet:ref/Hypergeometric1F1"][1, 1 - AF/nu, -BF[a, b]], {a, m}], {b, n}] /. {a -> 0, b -> 0}', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/code-KiLCA/W.wl')
