"""Generated SymPy translation of ``corpus/code-KiLCA/formulas.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 14 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('m', '20', ()),
    ('m', '5', ()),
    ('n', '0', ()),
    ('Int', 'Assuming[{V > 0, a > 0, kp > 0, nu > 0, EE > 0}, Integrate[w1^m*w2^n*Exp[-w2^2/2/V^2 + I*(kp/nu)*(w1 - w2) - (1/4/a)*(w1 - w2*EE + I*b)^2], {w1, -Infinity, Infinity}, {w2, -Infinity, Infinity}]]/Sqrt[4*Pi*a]', ()),
    ('Int', 'Simplify[Int /. {b -> 2*kp*(V^2/nu)*(1 - EE), a -> (V^2/2)*(1 - EE^2)}]', ()),
    ('m', '5', ()),
    ('n', '0', ()),
    ('BB', 'V^2*(2*I*kp*(alpha/nu) + alpha*beta)', ('alpha', 'beta')),
    ('CC', '(V^2/2)*(alpha^2 + beta^2 - 4*I*(kp/nu)*alpha)', ('alpha', 'beta')),
    ('Ans', 'Sqrt[2*Pi]*V*D[D[Exp[BB[alpha, beta]*EE + CC[alpha, beta]], {beta, n}], {alpha, m}]', ()),
    ('Ans', 'Ans /. {alpha -> I*(kp/nu), beta -> (-I)*(kp/nu)}', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/code-KiLCA/formulas.wl')
