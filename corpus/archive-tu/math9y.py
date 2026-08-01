"""Generated SymPy translation of ``corpus/archive-tu/math9y.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 114 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('e', 'Expand[(1 + 3*x + 4*y^2)^2]', ()),
    ('pp', '17 + 2*x*y^2 + 3*x^3*y', ()),
    ('f', '2/3', ()),
    ('p1', 'x^3 - 1', ()),
    ('p2', 'x - 1', ()),
    ('p1', 'x^3 - 2', ()),
    ('p1', '(x + 2)*(x + 1)*(x + 3)', ()),
    ('p1', 'Expand[p1]', ()),
    ('p2', '(x + 3)*(x + 2)*(x - 1)', ()),
    ('p2', 'Expand[p2]', ()),
    ('p1', '(Sqrt[2] - x)*(x + 1)*(x + Sqrt[2])^2', ()),
    ('p1', 'Expand[p1]', ()),
    ('p2', 'x^3 + 3*x^2 + a', ()),
    ('p2', 'Expand[p2]', ()),
    ('ff', 'Factor[x^3 - 2, Extension -> {2^(1/3)}]', ()),
    ('so', 'Solve[ff[[3]] == 0]', ()),
    ('pa', 'α^3 - 2', ()),
    ('pr', 'Expand[(a1 + b1*α + c1*α^2)*(a2 + b2*(α + c2*α^2))]', ()),
    ('sopr', 'Flatten[Solve[%, {a, b, c}]]', ()),
    ('p', '3 + 3*x - 7*x^2 - x^3 + 2*x^4 + 3*x^7 - 3*x^8 - x^9 + x^10', ()),
    ('q', 'x^6 - 9*x^4 - 4*x^3 + 27*x^2 - 36*x - 23', ()),
    ('x1', '2^(1/3) + 3^(1/2)', ()),
    ('x2', '2^(1/3) - 3^(1/2)', ()),
    ('tr', 'Table[{x -> 2^(1/3)*E^(I*2*Pi*(k/3)) + Sqrt[3]*(-1)^n}, {k, 3}, {n, 2}]', ()),
    ('p', 'x^3 + x^2 - 20*x - 9', ()),
    ('eq', 'a*x^4 + b*x^3 + c*x^2 + d*x + e == 0', ()),
    ('p', 'x^3 + 2*x - 2', ()),
    ('so', 'Solve[p == 0]', ()),
    ('eq', 'x^2 + 12*x + y^2 - 20*y + 15 == (x - a)^2 + (y - b)^2 - r^2', ()),
    ('soa', 'SolveAlways[eq, {x, y}]', ()),
    ('v0', 'N[Last[%]]', ()),
    ('ma', '{{2, 1, 3}, {4, 3, 5}}', ()),
    ('sys', '{ungl1, ungl2} = %', ()),
    ('sos', '{{x1 -> 0, x2 -> 0, x3 -> 0}, {x1 -> 0, x2 -> 0, x3 -> 1}, {x1 -> 0, x2 -> 1, x3 -> 0}, {x1 -> 0, x2 -> 1, x3 -> 1}, {x1 -> 1, x2 -> 0, x3 -> 0}, {x1 -> 1, x2 -> 0, x3 -> 1}, {x1 -> 1, x2 -> 1, x3 -> 0}}', ()),
    ('f', 'z^2 + Conjugate[z] + 2*I', ()),
    ('fx', 'Sin[x] + x - 2', ()),
    ('p1', 'Plot[E^Abs[x] - 2, {x, -1, 1}, PlotLabel -> "\\!\\(\\*SuperscriptBox[\\(\uf74d\\), \\(Abs[x]\\)]\\) - 2\\n"]', ()),
    ('p2', 'Plot[fx, {x, 0, 2}, PlotLabel -> fx]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/archive-tu/math9y.wl')
