"""Generated SymPy translation of ``corpus/gh-itpplasma-paper_sympl/sympl3_.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 61 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('$Assumptions', '{Element[{h0ph, h0th, B0}, Reals], h0ph > 0, h0ph < 1, h0th > 0, h0th < 1}', ()),
    ('R', 'R0*(1 + (r/R0)*Cos[th])', ()),
    ('Ar', '0', ()),
    ('Ath', 'h0ph*B0*(r^2/2 - (r^3/(3*R0))*Cos[th])', ()),
    ('Aph', '(-h0th)*B0*R0*r', ()),
    ('sqrtg', 'r*R', ()),
    ('gthth', 'r^2', ()),
    ('gphph', 'R^2', ()),
    ('Bmod', 'B0*(1 - (r/R0)*Cos[th])', ()),
    ('hr', '0', ()),
    ('hth', 'r*h0th', ()),
    ('hph', 'R*h0ph', ()),
    ('pth', 'm*vp*hth + eoc*Ath', ()),
    ('pph', 'm*vp*hph + eoc*Aph', ()),
    ('eoc', '1', ()),
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
    ('sol', 'Flatten[NDSolve[{eq1, eq3, th[0] == 1.5, vp[0] == 0.}, {th[t], vp[t]}, {t, 0, tmax}]]', ()),
    ('tmax', '100', ()),
    ('th0', '1.5', ()),
    ('r0', '0.3', ()),
    ('vp0', '0.', ()),
    ('w', 'm*(vp^2/2) + Jperp*(eoc/m)*Bmod /. {vp -> vp0, th -> th0, r -> r0}', ()),
    ('Astarr', 'Ar + m*(vp/eoc)*hr', ()),
    ('Astarth', 'Ath + m*(vp/eoc)*hth', ()),
    ('Astarph', 'Aph + m*(vp/eoc)*hph', ()),
    ('U', '(1/m)*(w - Jperp*(eoc/m)*Bmod)', ()),
    ('Brctr', '(1/sqrtg)*(D[Aph, th] - D[Ath, ph])', ()),
    ('Bthctr', 'FullSimplify[(1/sqrtg)*(D[Ar, ph] - D[Aph, r])]', ()),
    ('Bphctr', 'FullSimplify[(1/sqrtg)*(D[Ath, r] - D[Ar, th])]', ()),
    ('Bthcov', 'FullSimplify[gthth*Bthctr]', ()),
    ('Bphcov', 'FullSimplify[gphph*Bphctr]', ()),
    ('Bstarr', 'FullSimplify[Brctr + m*(vp/eoc)*(1/sqrtg)*(D[hph, th] - D[hth, ph])]', ()),
    ('Bstarth', 'FullSimplify[Bthctr + m*(vp/eoc)*(1/sqrtg)*(D[hr, ph] - D[hph, r])]', ()),
    ('Bstarph', 'FullSimplify[Bphctr + m*(vp/eoc)*(1/sqrtg)*(D[hth, r] - D[hr, th])]', ()),
    ('Bstarpar', 'FullSimplify[hth*Bstarth + hph*Bstarph]', ()),
    ('rdot', 'FullSimplify[(1/(Bstarpar*sqrtg))*(vp*(D[Aph, th] - D[Ath, ph]) + 2*U*(m/eoc)*(D[hph, th] - D[hth, ph]) + (m/eoc)*(hph*D[U, th] - hth*D[U, ph])) /. {th -> th[t], r -> r[t], vp -> vp[t]}]', ()),
    ('thdot', 'FullSimplify[(1/(Bstarpar*sqrtg))*(vp*(D[Ar, ph] - D[Aph, r]) + 2*U*(m/eoc)*(D[hr, ph] - D[hph, r]) + (m/eoc)*(hr*D[U, ph] - hph*D[U, r])) /. {th -> th[t], r -> r[t], vp -> vp[t]}]', ()),
    ('phdot', 'FullSimplify[(1/(Bstarpar*sqrtg))*(vp*(D[Ath, r] - D[Ar, th]) + 2*U*(m/eoc)*(D[hth, r] - D[hr, th]) + (m/eoc)*(hth*D[U, r] - hr*D[U, th])) /. {th -> th[t], r -> r[t], vp -> vp[t]}]', ()),
    ('vpdot', 'FullSimplify[(1/(Bstarpar*sqrtg))*(D[U, r]*(D[Aph, th] + vp*(m/eoc)*D[hph, th]) + D[U, th]*(D[Ar, ph] + vp*(m/eoc)*D[hr, ph]) + D[U, ph]*(D[Ath, r] + vp*(m/eoc)*D[hth, r]) - D[U, r]*(D[Ath, ph] + vp*(m/eoc)*D[hth, ph]) - D[U, th]*(D[Aph, r] + vp*(m/eoc)*D[hph, r]) - D[U, ph]*(D[Ar, th] + vp*(m/eoc)*D[hr, th])) /. {th -> th[t], r -> r[t], vp -> vp[t]}]', ()),
    ('repl', '{h0th -> 0.99, h0ph -> Sqrt[1 - 0.99^2]}', ()),
    ('eq1a', 'D[r[t], t] == rdot /. repl', ()),
    ('eq2a', 'D[th[t], t] == thdot /. repl', ()),
    ('eq3a', 'D[ph[t], t] == phdot /. repl', ()),
    ('eq4a', 'D[vp[t], t] == vpdot /. repl', ()),
    ('sol', 'Flatten[NDSolve[{eq1a, eq2a, eq4a, th[0] == th0, r[0] == r0, vp[0] == vp0}, {th[t], r[t], vp[t]}, {t, 0, tmax}, Method -> "BDF"]]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/gh-itpplasma-paper_sympl/sympl3_.wl')
