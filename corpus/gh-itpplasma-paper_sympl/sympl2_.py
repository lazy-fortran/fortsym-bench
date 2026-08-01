"""Generated SymPy translation of ``corpus/gh-itpplasma-paper_sympl/sympl2_.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 14 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('$Assumptions', '{Element[{h0ph, h0th, B0}, Reals], h0ph > 0, h0ph < 1}', ()),
    ('R', 'R0*(1 + (r/R0)*Cos[th])', ()),
    ('Bmod', 'B0*(1 - (r/R0)*Cos[th])', ()),
    ('hth', 'r*h0th, Null, hph = R*h0ph', ()),
    ('pthofw', 'm*vpar*hth + (e/c)*Ath, Null, pphofw = m*vpar*hph + (e/c)*Aph', ()),
    ('dpdq', 'FullSimplify[{{D[pthofw, th], D[pthofw, ph]}, {D[pphofw, th], D[pphofw, ph]}}]', ()),
    ('dpdw', 'FullSimplify[{{D[pthofw, r], D[pthofw, vpar]}, {D[pphofw, r], D[pphofw, vpar]}}]', ()),
    ('dwdp', 'FullSimplify[Inverse[dpdw] /. {e -> 1, m -> 1, c -> 1, B0 -> 1, R0 -> 1}]', ()),
    ('dwdq', 'FullSimplify[-dwdp . dpdq /. {e -> 1, m -> 1, c -> 1, B0 -> 1, R0 -> 1}]', ()),
    ('Hofw', 'm*(vpar^2/2) + Jperp*e*(c/m)*Bmod', ()),
    ('dHdr', 'FullSimplify[D[Hofw, r] /. {e -> 1, m -> 1, c -> 1, B0 -> 1, R0 -> 1}]', ()),
    ('dHdvpar', 'FullSimplify[D[Hofw, vpar] /. {e -> 1, m -> 1, c -> 1, B0 -> 1, R0 -> 1, Jperp -> 1}]', ()),
    ('dHdth', 'FullSimplify[D[Hofw, th] /. {e -> 1, m -> 1, c -> 1, B0 -> 1, R0 -> 1, Jperp -> 1}]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/gh-itpplasma-paper_sympl/sympl2_.wl')
