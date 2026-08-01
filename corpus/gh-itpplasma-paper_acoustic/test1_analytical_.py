"""Generated SymPy translation of ``corpus/gh-itpplasma-paper_acoustic/test1_analytical_.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 26 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('rho', '1.*10^3', ()),
    ('K', '2.25*10^9', ()),
    ('c', 'Sqrt[K/rho]', ()),
    ('R', 'Sqrt[x^2 + y^2]', ('x', 'y')),
    ('G', '(1/(2*Pi))*(HeavisideTheta[(t - tpr) - R[x - xpr, y - ypr]/c]/Sqrt[(t - tpr)^2 - R[x - xpr, y - ypr]^2/c^2])', ('x', 'y', 't', 'xpr', 'ypr', 'tpr')),
    ('x0', '(120*0.05)/10^3', ()),
    ('y0', '(200*0.05)/10^3', ()),
    ('x1', '(120*0.05)/10^3', ()),
    ('y1', 'y0 + 3/10^3', ()),
    ('t0', '1.5/10^6', ()),
    ('q', 'Exp[-(t - t0)^2/((0.3*1.5)/10^6)^2]', ('t',)),
    ('Vals', 'Table[NIntegrate[G[x1, y1, t1, x0, y0, t]*q[t], {t, t0, t1}], {t1, 0, 10/10^6, 10^(-6)}]', ()),
    ('t1', '6/10^6', ()),
    ('G0', 'HeavisideTheta[(t - tpr) - R[x - xpr, y - ypr]]/Sqrt[(t - tpr)^2 - R[x - xpr, y - ypr]^2]', ('x', 'y', 't', 'xpr', 'ypr', 'tpr')),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/gh-itpplasma-paper_acoustic/test1_analytical_.wl')
