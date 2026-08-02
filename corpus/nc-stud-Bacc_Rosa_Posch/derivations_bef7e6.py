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
    ('w0', 'w /. Last[Solve[w L == 1/(w C), w]] // PowerExpand', ()),
    ('Qfac', '(w0 L)/R // Simplify', ()),
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
    ('pabs', '1/2 sigRe Emag^2 // Simplify', ()),
    ('strip', 'x /. ConditionalExpression[a_, _] :> a', ('x',)),
    ('Vb', 'Bp u/(Log[Ap u] - Log[Log[1 + 1/gse]])', ()),
    ('dVb', 'D[Vb, u] // Simplify', ()),
    ('uMin', 'strip[Solve[dVb == 0, u][[1, 1, 2]] // Simplify]', ()),
    ('VbMin', 'strip[Simplify[Vb /. u -> uMin]]', ()),
    ('Ztot', 'I w L11 + w^2 M^2/(R2 + I w L22)', ()),
    ('Rpl', 'ComplexExpand[Re[Ztot]] // Simplify', ()),
    ('Xpl', 'ComplexExpand[Im[Ztot]] // Simplify', ()),
    ('eta', 'Rpl/(Rpl + Rcoil) // Simplify', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/nc-stud-Bacc_Rosa_Posch/derivations_bef7e6.wl')
