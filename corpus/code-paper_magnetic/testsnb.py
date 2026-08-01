"""Generated SymPy translation of ``corpus/code-paper_magnetic/testsnb.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 16 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('J', '{{1, 0, 0}, {a21, a22, 0}, {a31, a32, 1}}', ()),
    ('g1', '1', ()),
    ('g2', '1', ()),
    ('B1', '1', ()),
    ('B2', '1', ()),
    ('B3', '1', ()),
    ('b', 'Sqrt[g1*(g2/(B1*B2))]', ()),
    ('d', 'B1*g2 + B2*g1', ()),
    ('u', '(g2*xi + g1*eta)/d - lam/B3', ()),
    ('z', 'lam/B3 + b*Tanh[u/b]', ()),
    ('phi', '(B2*xi - B1*eta)/d', ()),
    ('rho', 'b*Sech[u/b]', ()),
    ('x', 'rho*Cos[phi]', ()),
    ('y', 'rho*Sin[phi]', ()),
    ('g1', '1', ()),
    ('g2', '1', ()),
    ('B1', '1', ()),
    ('B2', '1', ()),
    ('B3', '1', ()),
    ('b', 'Sqrt[g1*(g2/(B1*B2))]', ()),
    ('rho', 'Sqrt[x^2 + y^2]', ()),
    ('phi', 'ArcTan[y, x]', ()),
    ('xi', 'B1*z + g1*phi + B1*(Sqrt[b^2 - rho^2] + b*Log[rho/(b + Sqrt[b^2 - rho^2])])', ()),
    ('eta', 'B2*z - g2*phi + B2*(Sqrt[b^2 - rho^2] + b*Log[rho/(b + Sqrt[b^2 - rho^2])])', ()),
    ('lam', 'B3*(z + Sqrt[b^2 - rho^2])', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/code-paper_magnetic/testsnb.wl')
