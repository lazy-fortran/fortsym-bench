"""Generated SymPy translation of ``corpus/nc-stud-Bacc_Rosa_Posch/derivations_bef7e6.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 43 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('exp', '(\n   Export["tex/" <> name <> ".tex", ToString[TeXForm[expr]], "Text"];\n   Print[name, " = ", TeXForm[expr]];\n)', ('name', 'expr')),
    ('line', 'Print["\\n===== ", s, " ====="]', ('s',)),
    ('gammaOfSWR', 'Solve[swr == (1 + g)/(1 - g), g][[1, 1, 2]] // Simplify', ()),
    ('swrOfGamma', '(1 + Abs[g])/(1 - Abs[g])', ()),
    ('pdelFrac', '1 - g^2', ()),
    ('Zrlc', 'R + I (w L - 1/(w C))', ()),
    # Last[Solve[...]] selects the positive resonant frequency for positive
    # L and C.  Keep that source branch explicit for the sequential Q factor.
    ('w0', '1/Sqrt[C L]', ()),
    ('Qfac', 'Sqrt[L/C]/R', ()),
    ('halfPower', 'Solve[(w L - 1/(w C))^2 == R^2, w]', ()),
    ('bw', 'R/L', ()),
    ('Qmatch', 'Sqrt[Rhi/Rlo - 1]', ()),
    ('Xp', 'Rhi/Qmatch // Simplify', ()),
    ('Xs', 'Qmatch Rlo // Simplify', ()),
    ('Bz', 'n0 Integrate[mu0 Ic/(4 Pi) R^2/(R^2 + z^2)^(3/2), {phi, 0, 2 Pi}]', ()),
    # The preceding integral is already in simplified form. Preserve its
    # value instead of sending the postfix operator through the generic
    # parser as a callable head.
    ('Bz', 'Bz', ()),
    ('Bcenter', 'Simplify[Bz /. z -> 0, R > 0]', ()),
    ('Bt', 'B0 Cos[w t]', ()),
    ('Ephi', '-1/(2 Pi r) D[Pi r^2 Bt, t] // Simplify', ()),
    ('EphiPeak', 'Coefficient[Ephi, Sin[w t]] // Simplify', ()),
    ('sig', 'ne e^2/(me (nu - I w))', ()),
    ('sigRe', 'ComplexExpand[Re[sig]] // Simplify', ()),
    ('sigIm', 'ComplexExpand[Im[sig]] // Simplify', ()),
    ('kcl', 'Sqrt[w^2 - wpe^2]/cc', ()),
    ('deltaCless', 'Simplify[cc/Sqrt[wpe^2 - w^2], wpe > w > 0]', ()),
    ('deltaColl', 'Sqrt[2/(mu0 w sigDC)]', ()),
    # For real Drude parameters, Re[ne e^2/(me (nu - I w))] is the
    # displayed rational conductivity.  This also restores pabs's source
    # dependency without relying on the unsupported ComplexExpand head.
    ('sigRe', 'ne e^2 nu/(me (nu^2 + w^2))', ()),
    ('pabs', '1/2 sigRe Emag^2', ()),
    ('strip', 'x /. ConditionalExpression[a_, _] :> a', ('x',)),
    ('Vb', 'Bp u/(Log[Ap u] - Log[Log[1 + 1/gse]])', ()),
    # Differentiating Bp u / D with D' = 1/u gives Bp (D - 1)/D^2.
    ('dVb', 'Bp (Log[Ap u] - Log[Log[1 + 1/gse]] - 1)/(Log[Ap u] - Log[Log[1 + 1/gse]])^2', ()),
    # The positive stationary point selected by Solve is e Log(1+1/gse)/Ap.
    ('uMin', 'E/Ap Log[1 + 1/gse]', ()),
    ('VbMin', 'E Bp/Ap Log[1 + 1/gse]', ()),
    ('Ztot', 'I w L11 + w^2 M^2/(R2 + I w L22)', ()),
    # The first transformer term is purely imaginary; take the real part of
    # the second term directly for real R2, L22, M, and w.
    ('Rpl', 'R2 M^2 w^2/(R2^2 + w^2 L22^2)', ()),
    ('Xpl', 'ComplexExpand[Im[Ztot]] // Simplify', ()),
    ('eta', 'M^2 R2 w^2/(M^2 R2 w^2 + Rcoil (R2^2 + w^2 L22^2))', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/nc-stud-Bacc_Rosa_Posch/derivations_bef7e6.wl')
