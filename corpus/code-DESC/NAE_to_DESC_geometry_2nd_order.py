"""Generated SymPy translation of ``corpus/code-DESC/NAE_to_DESC_geometry_2nd_order.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments
import sympy as sp

# NOT TRANSLATED: 64 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('radial', '{Cos[ϕ], Sin[ϕ], 0}', ()),
    ('toroidal', '{-Sin[ϕ], Cos[ϕ], 0}', ()),
    ('vertical', '{0, 0, 1}', ()),
    ('normal', 'kR[ϕ]*radial + kTh[ϕ]*toroidal + kZ[ϕ]*vertical', ()),
    ('binormal', 'tR[ϕ]*radial + tTh[ϕ]*toroidal + tZ[ϕ]*vertical', ()),
    ('tangent', 'bR[ϕ]*radial + bTh[ϕ]*toroidal + bZ[ϕ]*vertical', ()),
    ('X1', 'X1c[ϕ]*Cos[θ] + X1s[ϕ]*Sin[θ]', ()),
    ('Y1', 'Y1c[ϕ]*Cos[θ] + Y1s[ϕ]*Sin[θ]', ()),
    ('R1stExp', 'FullSimplify[Series[R[ϕ, θ], {ϵ, 0, 2}]]', ()),
    ('TanPhi1stExp', 'Series[TanPhiCyl[ϕ, θ], {ϵ, 0, 2}]', ()),
    ('Phi1stExp', 'FullSimplify[ArcTan[TanPhi1stExp] - ArcTan[Tan[ϕ]]]', ()),
    ('R1full', 'Collect[FullSimplify[Series[R1stExpFun[Subscript[ϕ, c] - Phi1stExpFun[Subscript[ϕ, c] - Phi1stExpFun[Subscript[ϕ, c], θ], θ], θ], {ϵ, 0, 1}]] - R0[Subscript[ϕ, c]], {Cos[θ], Sin[θ]}] /. {Sqrt[R0[Subscript[ϕ, c]]^2] -> R0[Subscript[ϕ, c]]}', ()),
    ('Z1stExp', 'Normal[FullSimplify[Series[Z[ϕ, θ], {ϵ, 0, 2}]]]', ()),
    ('Z1full', 'Collect[Series[Z1stExpFun[Subscript[ϕ, c] - Phi1stExpFun[Subscript[ϕ, c] - Phi1stExpFun[Subscript[ϕ, c] - Phi1stExpFun[Subscript[ϕ, c], θ], θ], θ], θ], {ϵ, 0, 1}] - Z0[Subscript[ϕ, c]], {Cos[θ], Sin[θ]}]', ()),
    ('radial', '{Cos[ϕ], Sin[ϕ], 0}', ()),
    ('toroidal', '{-Sin[ϕ], Cos[ϕ], 0}', ()),
    ('vertical', '{0, 0, 1}', ()),
    ('R2ndExp', 'Normal[FullSimplify[Series[R[ϕ, θ], {ϵ, 0, 3}]]]', ()),
    ('Z2ndExp', 'Normal[FullSimplify[Series[Z[ϕ, θ], {ϵ, 0, 3}]]]', ()),
    ('Phi2ndExp', 'Normal[FullSimplify[ArcTan[Series[TanPhiCyl[ϕ, θ], {ϵ, 0, 3}]] - ArcTan[Tan[ϕ]]]]', ()),
    ('deltaPhi2', 'Series[Phi2ndExpFun[Subscript[ϕ, c] - Phi2ndExpFun[Subscript[ϕ, c] - Phi2ndExpFun[Subscript[ϕ, c], θ], θ], θ], {ϵ, 0, 2}]', ()),
    ('nuFull', 'Normal[FullSimplify[Series[nu[Subscript[ϕ, c] - deltaPhi2], {ϵ, 0, 3}]]]', ()),
    ('DeltaR', 'Series[R2ndExpFun[Subscript[ϕ, c] - Phi2ndExpFun[Subscript[ϕ, c] - Phi2ndExpFun[Subscript[ϕ, c] - Phi2ndExpFun[Subscript[ϕ, c], θ], θ], θ], θ] - R0[Subscript[ϕ, c]], {ϵ, 0, 2}]', ()),
    ('DeltaR2', 'Coefficient[DeltaR, ϵ^2]', ()),
    ('DeltaR2man', '(-(1/2))*D[D[R0[Subscript[ϕ, c]], Subscript[ϕ, c]], Subscript[ϕ, c]]*(x1Th[Subscript[ϕ, c], θ]^2/R0[Subscript[ϕ, c]]^2) - (x2Th[Subscript[ϕ, c], θ]/R0[Subscript[ϕ, c]] - (x1R[Subscript[ϕ, c], θ]*x1Th[Subscript[ϕ, c], θ])/R0[Subscript[ϕ, c]]^2)*D[R0[Subscript[ϕ, c]], Subscript[ϕ, c]] - (x1Th[Subscript[ϕ, c], θ]/R0[Subscript[ϕ, c]])*D[x1R[Subscript[ϕ, c], θ] - (x1Th[Subscript[ϕ, c], θ]/R0[Subscript[ϕ, c]])*D[R0[Subscript[ϕ, c]], Subscript[ϕ, c]], Subscript[ϕ, c]] + (x2R[Subscript[ϕ, c], θ] + x1Th[Subscript[ϕ, c], θ]^2/(2*R0[Subscript[ϕ, c]]))', ()),
    ('DeltaZ', 'Series[Z2ndExpFun[Subscript[ϕ, c] - Phi2ndExpFun[Subscript[ϕ, c] - Phi2ndExpFun[Subscript[ϕ, c] - Phi2ndExpFun[Subscript[ϕ, c], θ], θ], θ], θ] - Z0[Subscript[ϕ, c]], {ϵ, 0, 2}]', ()),
    ('DeltaZ2', 'Coefficient[DeltaZ, ϵ^2]', ()),
    ('DeltaZ2man', 'x2Z[Subscript[ϕ, c], θ] - (x1Th[Subscript[ϕ, c], θ]/R0[Subscript[ϕ, c]])*D[x1Z[Subscript[ϕ, c], θ] - (x1Th[Subscript[ϕ, c], θ]/R0[Subscript[ϕ, c]])*D[Z0[Subscript[ϕ, c]], Subscript[ϕ, c]], Subscript[ϕ, c]] - (x2Th[Subscript[ϕ, c], θ]/R0[Subscript[ϕ, c]] - (x1R[Subscript[ϕ, c], θ]*x1Th[Subscript[ϕ, c], θ])/R0[Subscript[ϕ, c]]^2)*D[Z0[Subscript[ϕ, c]], Subscript[ϕ, c]] - (x1Th[Subscript[ϕ, c], θ]^2/(2*R0[Subscript[ϕ, c]]^2))*D[D[Z0[Subscript[ϕ, c]], Subscript[ϕ, c]], Subscript[ϕ, c]]', ()),
    ('x1th', 'X1thc[ϕ]*Cos[θ] + X1ths[ϕ]*Sin[θ]', ()),
    ('x1R', 'X1Rc[ϕ]*Cos[θ] + X1Rs[ϕ]*Sin[θ]', ()),
    ('x2th', 'X2thc[ϕ]*Cos[2*θ] + X2ths[ϕ]*Sin[2*θ] + X2th0[ϕ]', ()),
    ('x2R', 'X2Rc[ϕ]*Cos[2*θ] + X2Rs[ϕ]*Sin[2*θ] + X2R0[ϕ]', ()),
    ('x1z', 'X1zc[ϕ]*Cos[θ] + X1zs[ϕ]*Sin[θ]', ()),
    ('x2z', 'X2zc[ϕ]*Cos[2*θ] + X2zs[ϕ]*Sin[2*θ] + X2z0[ϕ]', ()),
    ('delR2', '(-(1/2))*D[D[R0[ϕ], ϕ], ϕ]*(x1th^2/R0[ϕ]^2) - (x2th/R0[ϕ] - (x1R*x1th)/R0[ϕ]^2)*D[R0[ϕ], ϕ] - (x1th/R0[ϕ])*D[x1R - (x1th/R0[ϕ])*D[R0[ϕ], ϕ], ϕ] + (x2R + x1th^2/(2*R0[ϕ]))', ()),
    ('delZ2', '(-(1/2))*D[D[Z0[ϕ], ϕ], ϕ]*(x1th^2/R0[ϕ]^2) - (x2th/R0[ϕ] - (x1R*x1th)/R0[ϕ]^2)*D[Z0[ϕ], ϕ] - (x1th/R0[ϕ])*D[x1z - (x1th/R0[ϕ])*D[Z0[ϕ], ϕ], ϕ] + x2z', ()),
]

def _source_names(text):
    """Use parser-safe names internally, restoring the source spelling later."""

    return (
        text.replace("ϕ", "fortsymPhi")
        .replace("θ", "fortsymTheta")
        .replace("ϵ", "fortsymEpsilon")
    )


def _restore_source_names(value):
    replacements = {
        # The cross-language input-form parser canonicalises Wolfram's phi
        # glyph to ``phi`` before parsing. Retain that spelling at the
        # protocol boundary; it is only a serialization spelling, not a
        # change to the coordinate represented here.
        sp.Symbol("fortsymPhi"): sp.Symbol("phi"),
        sp.Symbol("fortsymTheta"): sp.Symbol("θ"),
        sp.Symbol("fortsymEpsilon"): sp.Symbol("ϵ"),
    }
    if hasattr(value, "xreplace"):
        return value.xreplace(replacements)
    if isinstance(value, tuple):
        return tuple(_restore_source_names(item) for item in value)
    return value


def results():
    assignments = [
        (name, _source_names(rhs), parameters)
        for name, rhs, parameters in _ASSIGNMENTS
    ]
    values = evaluate_assignments(
        assignments, 'corpus/code-DESC/NAE_to_DESC_geometry_2nd_order.wl'
    )
    return {name: _restore_source_names(value) for name, value in values.items()}
