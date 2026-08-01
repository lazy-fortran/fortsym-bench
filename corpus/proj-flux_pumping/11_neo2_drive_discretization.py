"""Generated SymPy translation of ``corpus/proj-flux_pumping/11_neo2_drive_discretization.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 33 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('lam', 'Sqrt[1 - Bh eta]', ('eta', 'Bh')),
    ('geodBandDensity', '-D[lam[eta, Bh] (4/Bh - eta)/(3 Bh), eta]', ()),
    ('vgs', 'vT^2 x^2 (1 + lamv^2) kGgrads/(2 omegacRef Bh)', ()),
    ('qGeodesic', 'vgs/(vT x lamv rhoA) /. rhoA -> vT/omegacRef', ()),
    ('qWare', '(Ehat Bh) (vT x sig lamv)/(vT x lamv)', ()),
    ('qVparPiece', '(cB hph) (vT x sig lamv)/(vT x lamv rhoA)', ()),
    ('dPhi', 'Phim Exp[I (m th + n ph)]', ()),
    ('vEs', 'cl (B0covth D[dPhi, ph] - B0covph D[dPhi, th])/(sqrtg B0^2)', ()),
    ('vEsExpected', 'I cl Phim (n B0covth - m B0covph)/(sqrtg B0^2) Exp[I (m th + n ph)]', ()),
    ('vEsm', 'I cl Phim (n B0covth - m B0covph)/(psip (iota B0covth + B0covph))', ()),
    ('GDim', 'MM^(1/2) LL^(-1/2)/TT', ()),
    ('esuDim', 'MM^(1/2) LL^(3/2)/TT', ()),
    ('dimRules', '{cl -> LL/TT, Phim -> GDim LL, B0covth -> GDim LL,\n  B0covph -> GDim LL, psip -> GDim LL^2, iota -> 1, m -> 1, n -> 2}', ()),
    ('dimOf', 'FreeQ[PowerExpand@Simplify[(expr /. dimRules)/target], LL | TT | MM]', ('expr', 'target')),
    ('ampE', 'vEsm omegacv/vTv^2 /. {omegacv -> za ee Bref/(ma cl),\n  vTv -> Sqrt[2 Ta/ma]}', ()),
    ('ampB', 'cB za ee Bref/(Sqrt[2 Ta/ma] ma cl)', ()),
    ('aNew1', 'Integrate[x^4 Exp[-x^2] x^(2 mm)/x, {x, 0, Infinity}]/Pi^(3/2)', ('mm',)),
    ('aNew2', 'Integrate[x^4 Exp[-x^2] x^(2 mm) x^2, {x, 0, Infinity}]/Pi^(3/2)', ('mm',)),
    ('fA', 'I hs df0ds/kpar', ()),
    ('Zfun', 'I Sqrt[Pi] Exp[-zeta^2] Erfc[-I zeta]', ('zeta',)),
    ('jKrook', '-(ee ne vE/(I kpar)) (\n  (A1 + A2) (1 + zeta Zfun[zeta]) + A2 (1/2 + zeta^2 + zeta^3 Zfun[zeta]))', ('A1', 'A2', 'zeta')),
    ('jDirect', '-(1/I) (1/Sqrt[Pi]) NIntegrate[\n    Exp[-u^2] u (A1v + A2v (u^2 + 1))/(u - zetav),\n    {u, -Infinity, Infinity}, WorkingPrecision -> 30]', ('A1v', 'A2v', 'zetav')),
    ('uEth', 'cl P0p B0covph/(sqrtg B0^2)', ()),
    ('uEph', '-cl P0p B0covth/(sqrtg B0^2)', ()),
    ('OmRigid', '-cl P0p/(iota psip)', ()),
    ('omFull', 'cl P0p (m B0covph - n B0covth)/(psip (iota B0covth + B0covph))', ()),
    ('PhiAmemo', 'I P0p cB/(iota m + n)', ()),
    ('PhiAneo2', 'PhiAmemo n OmRigid/omFull', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-flux_pumping/11_neo2_drive_discretization.wl')
