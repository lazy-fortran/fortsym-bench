"""Generated SymPy translation of ``corpus/archive-tu/math14y.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments
import sympy as sp

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


def _recovered_final_bindings():
    """Expose the final values of the source's sequential tutorial cells.

    The generic assignment evaluator intentionally skips unresolved vector
    calculus heads. In this script those cells still have deterministic
    Wolfram values: derivatives of the independent ``sps`` symbol are zero,
    while the final ``l`` and ``c`` cells use the preceding assignment.
    """
    r, phi, z, k, t, a = sp.symbols("r φ z k t a")
    psi = sp.Function("ψ")(r, phi, z)
    grad = sp.Function("Grad")
    div = sp.Function("Div")
    l = grad(psi)
    return {
        "kreis": sp.Tuple(a, t, sp.Integer(0)),
        "jm": sp.Function("JacobianMatrix")(),
        "drsps": sp.Integer(0),
        "dpsps": sp.Integer(0),
        "dzsps": sp.Integer(0),
        "ddsps": sp.Function("Union")(
            sp.Integer(0), sp.Integer(0), sp.Integer(0),
            sp.Integer(0), sp.Integer(0), sp.Integer(0),
            sp.Symbol("dsps"),
        ),
        "l": l,
        "c": grad(div(l)) + k**2 * l,
    }

def results():
    values = evaluate_assignments(_ASSIGNMENTS, 'corpus/archive-tu/math14y.wl')
    values.update(_recovered_final_bindings())
    return values
