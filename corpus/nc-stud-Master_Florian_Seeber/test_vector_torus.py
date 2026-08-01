"""Generated SymPy translation of ``corpus/nc-stud-Master_Florian_Seeber/test_vector_torus.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 6 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('$Assumptions', '{Element[{a, et, th, m}, Reals], a > 0, m != 0, et >= 0, th > -Pi, th <= Pi}', ()),
    ('R', 'Sqrt[Cosh[et] - Cos[th]], Null, g11 = a^2/(Cosh[et] - Cos[th])^2, Null, g22 = g11, Null, g33 = g11*Sinh[et]^2, Null, sqg = FullSimplify[Sqrt[g11*g22*g33]], Null', ()),
    ('eq1R', 'Simplify[D[g33*curlt[AR], th] + (m^2/sqg)*(g22*AR[1]) == 0], Null, eq2R = Simplify[-D[g33*curlt[AR], et] + (m^2/sqg)*(g11*AR[2]) == 0]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/nc-stud-Master_Florian_Seeber/test_vector_torus.wl')
