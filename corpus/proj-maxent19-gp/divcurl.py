"""Generated SymPy translation of ``corpus/proj-maxent19-gp/divcurl.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 5 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('k', 'Exp[-((x - x0)^2 + (y - y0)^2 + (z - z0)^2)]*{1, 1, 1}', ()),
    ('kdiv0', 'Simplify[Curl[k, {x, y, z}]]', ()),
    ('phi0', 'Integrate[kdiv0[[1]], {x, x0, x1}] + f[y, z]', ()),
    ('a', 'Simplify[E^(-(y - y0)^2 - (z - z0)^2)*Sqrt[Pi]*(y - y0 - z + z0)*Erf[x0 - x1] + E^(-x^2 + 2*x*x0 - x0^2 - (y - y0)^2 - z^2 + 2*z*z0 - z0^2)*Sqrt[Pi]*((-E^(x - x0)^2)*(y - y0 - z + z0)*Erf[x0 - x1] + E^(y - y0)^2*(x - x0 - z + z0)*Erf[y - y0]) - 2*E^(-(x - x0)^2 - (y - y0)^2 - (z - z0)^2)*(x - x0 - y + y0) - E^(-x^2 + 2*x*x0 - x0^2 - (y - y0)^2 - z^2 + 2*z*z0 - z0^2)*Sqrt[Pi]*((-E^(x - x0)^2)*(y - y0 - z + z0)*Erf[x0 - x1] + E^(y - y0)^2*(x - x0 - z + z0)*Erf[y - y0])]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-maxent19-gp/divcurl.wl')
