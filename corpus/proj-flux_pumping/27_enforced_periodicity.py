"""Generated SymPy translation of ``corpus/proj-flux_pumping/27_enforced_periodicity.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 11 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('w', 'Exp[-2 Pi/(1 - t) Exp[-Sqrt[2]/t]]', ('t',)),
    ('wLoc', 'Piecewise[{{1, (x - x1)/(x2 - x1) <= 0},\n    {0, (x - x1)/(x2 - x1) >= 1}}, w[(x - x1)/(x2 - x1)]]', ('x1', 'x2', 'x')),
    ('periodized', 'Module[\n  {l = 2 (dr + drtr), xleft = xmid - dr - drtr, xin, g},\n  xin = xleft + Mod[x - xleft, l];\n  g = f[xin] wLoc[xmid + dr, xmid + dr + 2 drtr, xin] +\n    f[xin - l] (1 - wLoc[xmid + dr, xmid + dr + 2 drtr, xin]);\n  g (1 - wLoc[xmid - dr - 2 drtr, xmid - dr, xin]) +\n    f[xin + l] wLoc[xmid - dr - 2 drtr, xmid - dr, xin]]', ('f', 'xmid', 'dr', 'drtr', 'x')),
    ('layerPoints', 'Range[1/4, 3/4, 1/20]', ()),
    ('samples', 'Range[-2, 3, 1/13]', ()),
    ('blend', 'Module[{l = 2 (dr + drtr), g},\n  g = f[x] wLoc[xmid + dr, xmid + dr + 2 drtr, x] +\n    f[x - l] (1 - wLoc[xmid + dr, xmid + dr + 2 drtr, x]);\n  g (1 - wLoc[xmid - dr - 2 drtr, xmid - dr, x]) +\n    f[x + l] wLoc[xmid - dr - 2 drtr, xmid - dr, x]]', ('f', 'xmid', 'dr', 'drtr', 'x')),
    ('seam', '-1/4', ()),
    ('xtr', '9/8', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-flux_pumping/27_enforced_periodicity.wl')
