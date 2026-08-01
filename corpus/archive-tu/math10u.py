"""Generated SymPy translation of ``corpus/archive-tu/math10u.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 70 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('F', '{Sin[x]^2, Sin[Sqrt[x]], Sin[x]^(-2), Exp[-x^2], 1/Tan[x]^3, Sin[Sqrt[a*x + b]]}', ()),
    ('F', '{Exp[x^2]/x^2, Exp[-4*I*x]/x^3, BesselJ[n, x]/x^(n + 1), (x^2 + 3*x - 1)/Sin[x]^2}, Null, (Residue[#1, {x, 0}, Assumptions -> Element[n, Integers]] & ) /@ F', ()),
    ('F', '{(3*x + 1)/((x + 1)^2*(x - 2)), Sin[5*x]*Cos[3*x]}, Null, F2 = {x*(y/r^2), x*(y/r)} /. r -> Sqrt[x^2 + y^2 + z^2]', ()),
    ('elli', '(x/a)^2 + (y/b)^2 + (z/c)^2', ('x', 'y', 'z', 'a', 'b', 'c')),
    ('data', 'Sin[{0, Pi/2, Pi}]', ()),
    ('sol', 'Solve[p[0] == 0 && p[Pi/2] == 1 && p[Pi] == 0 && Derivative[1][p][Pi/2] == 0]', ()),
    ('al0', 'Pi/2', ()),
    ('aln', 'NSolve[res[a, b] == 0 && 0 < al < Pi, al, Reals]', ('a', 'b')),
    ('f', '(1 - t^4)^(1/2)', ()),
    ('f', '(x - 1)/(x^7 + x^3 + 1)', ()),
    ('sing', 'Solve[1 + x^3 + x^7 == 0, x, Reals]', ()),
    ('f', '(1/2)*z*Exp[z] - 1', ()),
    ('Wronsky', 'FullSimplify[Det[Table[D[f, {x, i}], {i, Range[0, Length[f] - 1]}]]]', ('f', 'x')),
    ('f', '1 - (2/(b - a))*Abs[t - (a + b)/2]', ()),
    ('F', '{t^a*Exp[b*t], (1 - Exp[-t])/t, Log[t], Exp[-t^2/4], Cos[x*Sqrt[t]]/Sqrt[t], Sin[x*Sqrt[t]], Cosh[x*Sqrt[t]]/Sqrt[t], Sinh[x*Sqrt[t]], Exp[-x^2/(4*t)]/Sqrt[t], Exp[-x^2/(4*t)]/Sqrt[t^3]}', ()),
    ('f', 'Exp[s^2]', ()),
    ('dgl', 'LS*CS*Derivative[2][i][t] + RS*CS*Derivative[1][i][t] + i[t] == 0', ()),
    ('sol', 'DSolve[{dgl, i[0] == 0, Derivative[1][i][0] == U0/LS}, i[t], t], Null, sol1 = sol /. {LS -> 1, CS -> 1, RS -> 1, U0 -> 10}, Null, Plot[i[t] /. sol1, {t, 0, 10}]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/archive-tu/math10u.wl')
