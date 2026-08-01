"""Generated SymPy translation of ``corpus/archive-tu/math11u.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 42 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('Ef', '{0, E0, 0}', ()),
    ('Bf', '{0, 0, B0}', ()),
    ('r', '{x[t], y[t], z[t]}', ()),
    ('v', 'D[r, t]', ()),
    ('b', 'D[v, t]', ()),
    ('Force', 'q*Ef + q*Cross[v, Bf] - m*a*v', ()),
    ('eq', 'Table[b[[i]] == Force[[i]], {i, 3}]', ()),
    ('id', '{x[0] == 0, Derivative[1][x][0] == vx, y[0] == 0, Derivative[1][y][0] == vy, z[0] == 0, Derivative[1][z][0] == vz}', ()),
    ('sol', 'Flatten[DSolve[Union[eq, id], {x, y, z}, t]]', ()),
    ('Force', 'q*Ef + q*Cross[v, Bf] - m*a*v*Abs[v]', ()),
    ('eq', 'Table[b[[i]] == Force[[i]], {i, 3}] /. {q -> 1, m -> 1, a -> 1, E0 -> 1, B0 -> 10}', ()),
    ('id', '{x[0] == 0, Derivative[1][x][0] == 1, y[0] == 0, Derivative[1][y][0] == 1, z[0] == 0, Derivative[1][z][0] == 1}', ()),
    ('sol', 'Flatten[NDSolve[Union[eq, id], {x, y, z}, {t, 0, 1}]]', ()),
    ('p1', 'ParametricPlot3D[Evaluate[{x[t], y[t], z[t]} /. sol], {t, 0, 1}]', ()),
    ('p2', 'ListPointPlot3D[Evaluate[({x[#1], y[#1], z[#1]} & ) /@ Range[0, 1, 0.05] /. sol], PlotStyle -> {PointSize -> Medium}]', ()),
    ('r', '{x[t], y[t], z[t]}', ()),
    ('v', 'D[r, t]', ()),
    ('a', 'D[v, t]', ()),
    ('Force', '{0, 0, -g} - c1*v - c2*v*Abs[v]', ()),
    ('eq', 'Table[a[[i]] == Force[[i]], {i, 1, 3}] /. {g -> 10}', ()),
    ('id', '{x[0] == 0, Derivative[1][x][0] == 0, y[0] == 0, Derivative[1][y][0] == 5, z[0] == 0, Derivative[1][z][0] == 10}', ()),
    ('sol', 'Array[Null, 3]', ()),
    ('p1', 'ParametricPlot3D[Evaluate[{x[t], y[t], z[t]} /. sol], {t, 0, 2}]', ()),
    ('p2', 'ListPointPlot3D[Evaluate[({x[#1], y[#1], z[#1]} & ) /@ Range[0, 2, 0.1] /. sol], PlotStyle -> {PointSize -> Medium}]', ()),
    ('Force', 'If[Abs[x[t]] < 1, -x[t], 0]', ()),
    ('eq', 'Derivative[2][x][t] == Force', ()),
    ('sol', 'Array[Null, 2]', ()),
    ('p1', 'Plot[Evaluate[x[t] /. sol], {t, 0, 3}]', ()),
    ('dgl', 'Derivative[2][y][x] + 2*x*Derivative[1][y][x] + 2*y[x] == 0', ()),
    ('asol1', 'DSolve[dgl, y[x], x]', ()),
    ('asol2', 'DSolve[{dgl, y[0] == 0, y[2] == 1}, y[x], x]', ()),
    ('nsol1', 'NDSolve[{dgl, y[0] == 1, Derivative[1][y][0] == 0}, y[x], {x, 0, 3}]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/archive-tu/math11u.wl')
