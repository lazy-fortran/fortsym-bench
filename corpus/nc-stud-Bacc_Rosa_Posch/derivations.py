"""Generated SymPy translation of ``corpus/nc-stud-Bacc_Rosa_Posch/derivations.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 80 non-assignment statement(s) remain.
COMPARE = {
    'refs': 'numeric',
}
_ASSIGNMENTS = [
    ('$failures', '0', ()),
    ('gammaOfSWR', 'Simplify[Solve[s == (1 + g)/(1 - g), g][[1, 1, 2]],\n   Assumptions -> s > 1]', ()),
    ('delFraction', 'Simplify[1 - gammaOfSWR^2]', ()),
    ('sensitivity', 'Simplify[D[delFraction, s]]', ()),
    ('zin', '1/(1/(I Xp) + 1/(Rlo + I Xs))', ()),
    ('sol', 'Solve[{ComplexExpand[Re[zin]] == Rhi,\n     ComplexExpand[Im[zin]] == 0}, {Xs, Xp}, Reals,\n    Assumptions -> Rhi > Rlo > 0][[1]]', ()),
    ('qm', 'Sqrt[Rhi/Rlo - 1]', ()),
    ('bCenter', 'Integrate[\\[Mu]0 (nn/lc) II Rc^2/(2 (Rc^2 + zp^2)^(3/2)),\n   {zp, -lc/2, lc/2}, Assumptions -> Rc > 0 && lc > 0]', ()),
    ('bCenter', 'Simplify[bCenter]', ()),
    ('ephi', 'Simplify[-(1/(2 Pi r)) D[B0 Exp[I \\[Omega] t] Pi r^2, t]]', ()),
    ('sigma', 'ne qe^2/(me (\\[Nu] + I \\[Omega]))', ()),
    ('sigmaRe', 'Simplify[ComplexExpand[Re[sigma]],\n  Assumptions -> ne > 0 && qe > 0 && me > 0 && \\[Nu] > 0 && \\[Omega] > 0]', ()),
    ('sigmaIm', 'Simplify[ComplexExpand[Im[sigma]],\n  Assumptions -> ne > 0 && qe > 0 && me > 0 && \\[Nu] > 0 && \\[Omega] > 0]', ()),
    ('deltaColl', 'Sqrt[2/(\\[Mu]0 \\[Omega] \\[Sigma]R)]', ()),
    ('wpe', 'Sqrt[ne qe^2/(\\[Epsilon]0 me)]', ()),
    ('deltaInertial', 'Simplify[c/Sqrt[wpe^2 - \\[Omega]^2]]', ()),
    ('kk2', '-I \\[Omega] \\[Mu]0 \\[Sigma]', ()),
    ('bz', 'Ba BesselJ[0, kk r]/BesselJ[0, kk a]', ('r',)),
    ('ePhiIn', 'Simplify[-(1/(\\[Mu]0 \\[Sigma])) D[bz[r], r]]', ('r',)),
    ('fluxPlasma', 'Integrate[bz[r] 2 Pi r, {r, 0, a},\n   Assumptions -> a > 0 && kk > 0]', ()),
    ('fluxPlasma', 'Simplify[fluxPlasma]', ()),
    ('zTotal', 'I \\[Omega] nn (\\[Mu]0 nn/lc) (Pi (Rc^2 - a^2) + fluxPlasma/Ba)', ()),
    ('zVac', 'I \\[Omega] \\[Mu]0 nn^2 Pi Rc^2/lc', ()),
    ('zPl', 'Simplify[zTotal - zVac]', ()),
    ('zPlSeries', 'Simplify[Normal[Series[\n    I \\[Omega] \\[Mu]0 nn^2/lc (2 Pi a BesselJ[1, kk a]/\n        (kk BesselJ[0, kk a]) - Pi a^2) /. kk -> Sqrt[kk2],\n    {\\[Sigma], 0, 1}]]]', ()),
    ('rplUniform', '\\[Omega]^2 \\[Mu]0^2 \\[Sigma] nn^2 Pi a^4/(8 lc)', ()),
    ('pAbsUniform', 'Simplify[\n   (1/2) \\[Sigma] Integrate[(r \\[Omega] \\[Mu]0 nn II/(2 lc))^2 2 Pi r lc,\n     {r, 0, a}, Assumptions -> a > 0]]', ()),
    ('kgeo', 'lc/Sqrt[lc^2 + 4 Rc^2]', ()),
    ('pAbsFinite', 'Simplify[\n   (1/2) \\[Sigma] Integrate[\n     (r \\[Omega] bCenter/2)^2 2 Pi r lc, {r, 0, a},\n     Assumptions -> a > 0 && Rc > 0 && lc > 0]]', ()),
    ('skinRefRule', '{\\[Omega] -> 2 Pi 13.56*^6, \\[Mu]0 -> 4 Pi 10^-7,\n   \\[Sigma] -> 5000., a -> 0.035, lc -> 0.05, nn -> 5}', ()),
    ('deltaVal', 'Sqrt[2/(\\[Mu]0 \\[Omega] \\[Sigma])] /. skinRefRule', ()),
    ('rplExactNum', 'Re[zPl /. kk -> Sqrt[kk2] /. skinRefRule]', ()),
    ('rplSkinNum', '(2 Pi a nn^2/(lc \\[Sigma] deltaVal)) /. skinRefRule', ()),
    ('eta', 'aa ne/(Rcoil + aa ne)', ()),
    ('neSol', 'Simplify[Solve[eta PL == bb ne && ne != 0, ne][[1, 1, 2]]]', ()),
    ('pMin', 'bb Rcoil/aa', ()),
    ('iOp', 'Simplify[Sqrt[2 PL/(Rcoil + aa neSol)],\n   Assumptions -> aa > 0 && bb > 0 && Rcoil > 0 && PL > bb Rcoil/aa]', ()),
    ('uB', 'Sqrt[qe Te/Mi]', ()),
    ('deff', 'Rp lp/(2 (Rp hl + lp hR))', ()),
    ('vb', 'BP pd/(Log[AP pd] - Log[Log[1 + 1/\\[Gamma]se]])', ()),
    ('pdMin', 'Simplify[pd /. Solve[D[vb, pd] == 0 && pd > 0, pd,\n     Assumptions -> AP > 0 && BP > 0 && \\[Gamma]se > 0][[1]]]', ()),
    ('vbMin', 'Simplify[vb /. pd -> pdMin,\n   Assumptions -> AP > 0 && BP > 0 && 0 < \\[Gamma]se < 1]', ()),
    ('vAmp', 'qe E0/(me Sqrt[\\[Nu]^2 + \\[Omega]^2])', ()),
    ('xAmp', 'Simplify[vAmp/\\[Omega]]', ()),
    ('pPerElectron', 'qe^2 E0^2 \\[Nu]/(2 me (\\[Nu]^2 + \\[Omega]^2))', ()),
    ('eEff', 'E0/Sqrt[2] \\[Nu]/Sqrt[\\[Nu]^2 + \\[Omega]^2]', ()),
    ('constRules', '{\\[Mu]0 -> 4 Pi 10^-7, \\[Epsilon]0 -> 8.8541878128*^-12,\n   qe -> 1.602176634*^-19, me -> 9.1093837015*^-31,\n   Mi -> 6.6335209*^-26, kB -> 1.380649*^-23, c -> 2.99792458*^8}', ()),
    ('refRules', 'Join[constRules, {\\[Omega] -> 2 Pi 13.56*^6, nn -> 5,\n    Rc -> 0.05, lc -> 0.05, a -> 0.035, lp -> 0.10, II -> 1.,\n    \\[Nu] -> nuRef, ne -> 10.^17, \\[Gamma]se -> 0.05}]', ()),
    ('ngRef', '133.322 2/(1.380649*^-23 300.)', ()),
    ('nuRef', 'ngRef 1.*^-19 Sqrt[8 1.602176634*^-19 2./(Pi 9.1093837015*^-31)]', ()),
    ('sigmaRefC', 'ne qe^2/(me (\\[Nu] + I \\[Omega])) //. refRules', ()),
    ('zplRef', 'zPl /. kk -> Sqrt[-I \\[Omega] \\[Mu]0 \\[Sigma]] /.\n    \\[Sigma] -> sigmaRefC //. refRules', ()),
    ('refs', '{\n  {"gamma_swr3", N[gammaOfSWR /. s -> 3]},\n  {"b_over_i", N[(bCenter/II) //. refRules]},\n  {"delta_cu",\n   N[Sqrt[2 1.68*^-8/((2 Pi 13.56*^6) (4 Pi 10^-7))]]},\n  {"n_g_2torr", N[ngRef]},\n  {"nu_m_2torr_2ev", N[nuRef]},\n  {"sigma_re_1e17", N[Re[sigmaRefC]]},\n  {"sigma_im_1e17", N[Im[sigmaRefC]]},\n  {"delta_coll_1e17", N[Sqrt[2/((4 Pi 10^-7) (2 Pi 13.56*^6)\n       Re[sigmaRefC])]]},\n  {"r_pl_exact_1e17", N[Re[zplRef]]},\n  {"x_pl_exact_1e17", N[Im[zplRef]]},\n  {"r_pl_uniform_1e17", N[rplUniform /. \\[Sigma] -> Re[sigmaRefC] //.\n      refRules]},\n  {"k_geo2", N[kgeo^2 //. refRules]},\n  {"r_pl_finite_1e17", N[(kgeo^2 //. refRules) Re[zplRef]]},\n  {"paschen_pd_min_ar", N[pdMin /. {AP -> 12, \\[Gamma]se -> 0.05}]},\n  {"paschen_v_min_ar",\n   N[vbMin /. {AP -> 12, BP -> 180, \\[Gamma]se -> 0.05}]}}', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/nc-stud-Bacc_Rosa_Posch/derivations.wl')
