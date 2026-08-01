"""Generated SymPy translation of ``corpus/archive-tu/math14y.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 93 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('a', '{ar[r, φ, z], aφ[r, φ, z], az[r, φ, z]}', ()),
    ('screw', '{5*Cos[t], 5*Sin[t], 3*t}', ()),
    ('kreis', '{1, t, 0}', ()),
    ('kreis', '{a, t, 0}', ()),
    ('jm', 'JacobianMatrix[]', ()),
    ('a', '{0, 0, 1}', ()),
    ('c', 'Expand[Curl[Curl[m]] - k^2*m]', ()),
    ('drsps', 'Flatten[D[sps, r]]', ()),
    ('dpsps', 'Flatten[D[sps, φ]]', ()),
    ('dzsps', 'Flatten[D[sps, z]]', ()),
    ('dsps', 'Join[drsps, dpsps, dzsps]', ()),
    ('c', 'Expand[Curl[Curl[n]] - k^2*n]', ()),
    ('ddsps', 'Flatten[Union[D[sps, r, r], D[sps, φ, φ], D[sps, z, z], D[sps, r, φ], D[sps, φ, z], D[sps, r, z], dsps]]', ()),
    ('l', 'Grad[ψ[r, φ, z]]', ()),
    ('c', 'Grad[Div[l]] + k^2*l', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/archive-tu/math14y.wl')
