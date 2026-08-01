"""Generated SymPy translation of ``corpus/nc-plasma-DOCUMENTS/divcurl.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 5 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('J', '{Jx, Jy, Jz}*Exp[I*(l*x + m*y + n*z)]', ()),
    ('B', '{Bx, By, Bz}*Exp[I*(l*x + m*y + n*z)]', ()),
    ('CB', 'FullSimplify[Curl[B, {x, y, z}]]/Exp[I*(l*x + m*y + n*z)]', ()),
    ('eq', 'FullSimplify[CB == J/Exp[I*(l*x + m*y + n*z)]]', ()),
    ('bsol', 'FullSimplify[Flatten[Solve[{eq, Bz == -(l*Bx + m*By)/n} /. Jz -> -(l*Jx + m*Jy)/n, {Bx, By, Bz}]]], Null, FullSimplify[Div[{Bx, By, Bz}*Exp[I*(l*x + m*y + n*z)] /. bsol, {x, y, z}]]', ()),
    ('eq2', 'FullSimplify[eq /. {Bz -> -(l*Bx + m*By)/n, Jz -> -(l*Jx + m*Jy)/n} /. {Bx -> (-I)*n*ay, By -> I*n*ax}]', ()),
    ('asol', 'FullSimplify[Flatten[Solve[eq2, {ax, ay}]]]', ()),
    ('a', 'FullSimplify[Flatten[{ax, ay} /. asol]], Null, Ca = FullSimplify[Curl[a*Exp[I*(l*x + m*y)], {x, y}]/Exp[I*(l*x + m*y)]], Null, Ca2 = FullSimplify[(D[ay*Exp[I*(l*x + m*y)], x] - D[ax*Exp[I*(l*x + m*y)], y])/Exp[I*(l*x + m*y)] /. asol], Null, b = FullSimplify[Flatten[{Bx, By} /. bsol]], Null, B = FullSimplify[Flatten[{Bx, By, -(l*Bx + m*By)/n} /. bsol]]', ()),
    ('cond', '{l -> 0, m -> 0, n -> 1, Jx -> -1, Jy -> 1}', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/nc-plasma-DOCUMENTS/divcurl.wl')
