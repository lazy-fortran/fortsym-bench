"""Generated SymPy translation of ``corpus/gh-itpplasma-paper_sympl/sympl3_.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 43 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('$Assumptions', '{Element[{h0ph, h0th, B0}, Reals], h0ph > 0, h0ph < 1, h0th > 0, h0th < 1}', ()),
    ('m', '1', ()),
    ('B0', '1', ()),
    ('R0', '1', ()),
    ('Jperp', '0.1', ()),
    ('dpdq', 'FullSimplify[{{D[pth, th], D[pth, ph]}, {D[pph, th], D[pph, ph]}}]', ()),
    ('dpdw', 'FullSimplify[{{D[pth, r], D[pth, vp]}, {D[pph, r], D[pph, vp]}}]', ()),
    ('dwdp', 'FullSimplify[Inverse[dpdw]]', ()),
    ('dwdq', 'FullSimplify[-dwdp . dpdq]', ()),
    ('H', 'm*(vp^2/2) + Jperp*eoc*m*Bmod', ()),
    ('dHdr', 'FullSimplify[D[H, r]]', ()),
    ('dHdvp', 'FullSimplify[D[H, vp]]', ()),
    ('dHdth', 'FullSimplify[D[H, th]]', ()),
    ('Lgc', 'pth*thdot - H /. {th -> th[t], r -> r[t], vp -> vp[t], thdot -> D[th[t], t]} /. {h0th -> 1, h0ph -> 0} /. r[t] -> 0.3', ()),
    ('eq1', 'FullSimplify[D[D[Lgc, Derivative[1][th][t]], t] - D[Lgc, th[t]] == 0]', ()),
    ('eq2', 'FullSimplify[D[Lgc, r[t]] == 0]', ()),
    ('eq3', 'FullSimplify[D[Lgc, vp[t]] == 0]', ()),
    ('tmax', '100', ()),
    ('tmax', '100', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/gh-itpplasma-paper_sympl/sympl3_.wl')
