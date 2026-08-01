"""Generated SymPy translation of ``corpus/archive-tu/math22y.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 123 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('x', 'Pi', ()),
    ('f', 'Sin[a*x]', ('x',)),
    ('t', '17', ()),
    ('f', 'Module[{t}, t = (1 + v)^2; Expand[t]]', ('v',)),
    ('fac3', 'Module[{f, n}, f[1] = 1; f[n_] := k + n*f[n - 1]; f[3]]', ('k',)),
    ('p', '33', ()),
    ('t', '17', ()),
    ('facn', 'Module[{t = u}, f[1] = 1; f[n_] := t + n*f[n - 1]; f[3]]', ('u',)),
    ('g', 'Module[{t = u}, t += t/(1 + u)]', ('u',)),
    ('t', '17', ()),
    ('la', '{33, 17}', ()),
    ('li1', '{1.1, 2.2, 3.5, 4.3}', ()),
    ('li2', '{0, 1.5, 2.5, 3.2, 5}', ()),
    ('li', '{li1, li2}', ()),
    ('fi', 'Block[{t}, gr1 = ListPlot[li[[nnn]]]; gf = Fit[li[[nnn]], {1, t, t^2, t^3}, t]; gr2 = Plot[gf, {t, 1, 5}, PlotStyle -> Hue[nnn*0.3]]; Show[gr1, gr2]]', ('nnn',)),
    ('u', 'x^2 + t^2', ()),
    ('t', '17', ()),
    ('x1', '2', ()),
    ('x2', '3', ()),
    ('x3', '4', ()),
    ('x4', '5', ()),
    ('y', '7', ()),
    ('z', '19', ()),
    ('cmdList', 'Names["*"]', ()),
    ('V', '5', ()),
    ('V', '5', ()),
    ('PowerSum', 'Sum[x^i, {i, 1, n}]', ('x', 'n')),
    ('SerSum', 'Sum[a[i]*x^i, {i, 1, n}]', ('x', 'n')),
    ('PowerSumm', 'Module[{i}, Sum[x^i, {i, 1, n}]]', ('x', 'n')),
    ('PowerSumb', 'Block[{i}, Sum[x^i, {i, 1, n}]]', ('x', 'n')),
    ('FunSer', 'Module[{i}, Sum[a[i]*func[i*x], {i, 1, n}]]', ('func', 'x', 'n')),
    ('FunSerm', 'Module[{i, a}, Sum[a[i]*func[i*x], {i, 1, n}]]', ('func', 'x', 'n')),
    ('FunSerb', 'Block[{i, a}, Sum[a[i]*func[i*x], {i, 1, n}]]', ('func', 'x', 'n')),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/archive-tu/math22y.wl')
