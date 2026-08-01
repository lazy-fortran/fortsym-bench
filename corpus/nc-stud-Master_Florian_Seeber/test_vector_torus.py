"""Generated SymPy translation of ``corpus/nc-stud-Master_Florian_Seeber/test_vector_torus.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 24 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('$Assumptions', '{Element[{a, et, th, m}, Reals], a > 0, m != 0, et >= 0, th > -Pi, th <= Pi}', ()),
    ('R', 'Sqrt[Cosh[et] - Cos[th]]', ()),
    ('g11', 'a^2/(Cosh[et] - Cos[th])^2', ()),
    ('g22', 'g11', ()),
    ('g33', 'g11*Sinh[et]^2', ()),
    ('sqg', 'FullSimplify[Sqrt[g11*g22*g33]]', ()),
    ('curlt', '(1/sqg)*(D[v[2], et] - D[v[1], th])', ('v',)),
    ('eq1', 'FullSimplify[D[g33*curlt[A], th] + (m^2/sqg)*(g22*A[1]) == 0]', ()),
    ('eq2', 'FullSimplify[-D[g33*curlt[A], et] + (m^2/sqg)*(g11*A[2]) == 0]', ()),
    ('eq1R', 'Simplify[D[g33*curlt[AR], th] + (m^2/sqg)*(g22*AR[1]) == 0]', ()),
    ('eq2R', 'Simplify[-D[g33*curlt[AR], et] + (m^2/sqg)*(g11*AR[2]) == 0]', ()),
    ('CurlCurl', '{D[D[v[2][x, y], x] - D[v[1][x, y], y], y], -D[D[v[2][x, y], x] - D[v[1][x, y], y], x]}', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/nc-stud-Master_Florian_Seeber/test_vector_torus.wl')
