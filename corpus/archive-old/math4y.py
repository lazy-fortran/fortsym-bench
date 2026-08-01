"""Generated SymPy translation of ``corpus/archive-old/math4y.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 162 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('c', '13.3', ()),
    ('sf', 'NSolve[f[x] == 0, x]', ()),
    ('x', '37', ()),
    ('tp', 'Table[{nt[[k,2,1]], nt[[k,1]]}, {k, Length[nt]}]', ()),
    ('dm', 'Timing[Table[{k, Fibonacci[k]}, {k, 2, 200}]]', ()),
    ('p', 'x^2 /', ('x',)),
    ('p', '-x^2 /', ('x',)),
    ('h', 'z', ()),
    ('h1', 'h /. z -> 44', ()),
    ('h', 'f[x, y]', ()),
    ('h1', 'h /. c -> 13.3', ()),
    ('h2', 'h1 /. {x -> a, y -> b}', ()),
    ('x', '4*y = 5', ()),
    ('u', '(a + b)^2', ()),
    ('v', '(c + d)^2', ()),
    ('w', '(e + f)^2', ()),
    ('uv', 'Expand[u + v + w]', ()),
    ('su', 'x :> t', ()),
    ('f', 'x^2', ()),
    ('t', '5', ()),
    ('x', '4', ()),
    ('s', 'x^2', ()),
    ('p', 'x^2', ()),
    ('x', '5', ()),
    ('ex', 'Expand[(1 + x)^2]', ('x',)),
    ('rd', 'ex[y + 2]', ()),
    ('ri', 'iex[y + 2]', ()),
    ('f1', '-Exp[(-a)*x] + x', ('x', 'a')),
    ('f', 'x^7 - a^7', ()),
    ('g', 'Factor[f]', ()),
    ('h', 'x - a', ()),
    ('k', 'f/g', ()),
    ('k', 'f/h', ()),
    ('e', '(x - 1)^2*((2 + x)/((1 + x)*(x - 3)^2))', ()),
    ('et', 'Together[%]', ()),
    ('ae', 'Apart[%]', ()),
    ('s', 'Simplify[%]', ()),
    ('n', 'Numerator[s]', ()),
    ('d', 'Denominator[s]', ()),
    ('d', 'Factor[d]', ()),
    ('g', 'Simplify[f, x > y], Null, D[g, x]', ()),
    ('g', 'Simplify[f, x < y], Null, D[g, x]', ()),
    ('f', '4*x + 6*y + 10*z', ()),
    ('g', 'Collect[f^3, x]', ()),
    ('h', 'Collect[f^3, y]', ()),
    ('f', 'Sqrt[x*y]', ()),
    ('g', 'PowerExpand[f]', ()),
    ('z', 'x + I*y', ()),
    ('f', '-2*u + 2*u^3 + 2*ε - 2*u^2*ε', ()),
    ('df', 'D[f, u]', ()),
    ('so', 'Solve[df == 0, u]', ()),
    ('f0', 'f /. so', ()),
    ('expr', 'Pi*(x/(x + 1 - 2*(-1)^(1/3) + I*Sqrt[3]))', ()),
    ('s2', 'FunctionExpand[%]', ()),
    ('s3', 'PowerExpand[s1]', ()),
    ('s4', 'Cancel[s1]', ()),
    ('expr', 'Expand[Sum[(-b + a*n)*x^(n + 0.12/n), {n, 3}]]', ()),
    ('CollectLogs', 'Log[Simplify[E^xx]]', ('xx',)),
    ('f', 'Sin[x]^3*Cos[2*x]', ()),
    ('g', 'TrigExpand[f]', ()),
    ('r', 'TrigReduce[f]', ()),
    ('t', 'TrigToExp[f]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/archive-old/math4y.wl')
