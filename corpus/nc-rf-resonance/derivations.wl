(* ::Package:: *)

(* Symbolic core of the Cheapos II analytical model.
   Run with:  math -script derivations.wl
   Exports LaTeX snippets to tex/ and a machine-readable reference-value
   table to ../data/symbolic_reference.csv that the Python test suite
   checks against. Every block prints PASS/FAIL consistency checks. *)

SetDirectory[DirectoryName[$InputFileName]];
If[!DirectoryQ["tex"], CreateDirectory["tex"]];
If[!DirectoryQ["../data"], CreateDirectory["../data"]];

$failures = 0;
exp[name_String, e_] := (
  Export["tex/" <> name <> ".tex", ToString[TeXForm[e]], "Text"];
  Print["  ", name, " = ", e]);
check[label_String, cond_] := Module[{ok = TrueQ[Simplify[cond]]},
  If[!ok, $failures++];
  Print["CHECK ", label, ": ", If[ok, "PASS", "FAIL"]]];
checkNum[label_String, a_, b_, tol_: 10^-10] := Module[
  {ok = TrueQ[Abs[a - b] <= tol Max[Abs[a], Abs[b]]]},
  If[!ok, $failures++];
  Print["CHECK ", label, ": ", If[ok, "PASS", "FAIL"],
    "  (", N[a], " vs ", N[b], ")"]];

Print["=== 1. Reflection, SWR and delivered power ==="];
gammaOfSWR = Simplify[Solve[s == (1 + g)/(1 - g), g][[1, 1, 2]],
   Assumptions -> s > 1];
exp["gamma_of_swr", gammaOfSWR];
delFraction = Simplify[1 - gammaOfSWR^2];
exp["delivered_fraction", delFraction];
check["SWR=3 -> |Gamma|=1/2", (gammaOfSWR /. s -> 3) == 1/2];
check["SWR=3 -> delivered 3/4", (delFraction /. s -> 3) == 3/4];
sensitivity = Simplify[D[delFraction, s]];
exp["delivered_sensitivity", sensitivity];
check["sensitivity vanishes at match", (sensitivity /. s -> 1) == 0];

Print["=== 2. L-network match ==="];
(* Shunt Xp at the source, series Xs at the load Rlo; the source must see
   Rhi (= 50 Ohm). Solve the match exactly. *)
zin = 1/(1/(I Xp) + 1/(Rlo + I Xs));
sol = Solve[{ComplexExpand[Re[zin]] == Rhi,
     ComplexExpand[Im[zin]] == 0}, {Xs, Xp}, Reals,
    Assumptions -> Rhi > Rlo > 0][[1]];
qm = Sqrt[Rhi/Rlo - 1];
check["L-match |Xs| = Qm Rlo", Simplify[Abs[Xs /. sol] == qm Rlo,
  Assumptions -> Rhi > Rlo > 0]];
check["L-match |Xp| = Rhi/Qm", Simplify[Abs[Xp /. sol] == Rhi/qm,
  Assumptions -> Rhi > Rlo > 0]];
exp["lmatch_qm", HoldForm[Sqrt[Rhi/Rlo - 1]]];

Print["=== 3. Coil: on-axis field of a finite solenoid ==="];
(* Ring of radius Rc at z': dB = mu0 I Rc^2 / (2 (Rc^2+(z-z')^2)^(3/2)).
   N turns spread over length lc, center z=0. *)
bCenter = Integrate[\[Mu]0 (nn/lc) II Rc^2/(2 (Rc^2 + zp^2)^(3/2)),
   {zp, -lc/2, lc/2}, Assumptions -> Rc > 0 && lc > 0];
bCenter = Simplify[bCenter];
exp["b_center_solenoid", bCenter];
check["solenoid limit lc>>Rc", Simplify[
   Limit[bCenter lc/(\[Mu]0 nn II), lc -> Infinity]] == 1];
check["loop limit lc->0",
  Simplify[Limit[bCenter, lc -> 0] == \[Mu]0 nn II/(2 Rc),
    Assumptions -> Rc > 0]];
check["closed form mu0 N I/Sqrt(lc^2+4Rc^2)", Simplify[
   bCenter == \[Mu]0 nn II/Sqrt[lc^2 + 4 Rc^2],
   Assumptions -> Rc > 0 && lc > 0]];

Print["=== 3b. Faraday induced field ==="];
(* Uniform B(t)=B0 Exp[I w t] over disk radius r *)
ephi = Simplify[-(1/(2 Pi r)) D[B0 Exp[I \[Omega] t] Pi r^2, t]];
exp["e_phi", ephi];
check["|E_phi| = r w B0/2", Simplify[Abs[ephi] == r \[Omega] B0/2,
  Assumptions -> r > 0 && \[Omega] > 0 && B0 > 0 && t \[Element] Reals]];

Print["=== 4. Drude conductivity (e^{+i w t} convention) ==="];
sigma = ne qe^2/(me (\[Nu] + I \[Omega]));
sigmaRe = Simplify[ComplexExpand[Re[sigma]],
  Assumptions -> ne > 0 && qe > 0 && me > 0 && \[Nu] > 0 && \[Omega] > 0];
sigmaIm = Simplify[ComplexExpand[Im[sigma]],
  Assumptions -> ne > 0 && qe > 0 && me > 0 && \[Nu] > 0 && \[Omega] > 0];
exp["sigma_re", sigmaRe];
exp["sigma_im", sigmaIm];
check["collisional limit", Simplify[
  Limit[sigma, \[Omega] -> 0] == ne qe^2/(me \[Nu])]];
check["inertial limit is -i ne e^2/(me w)", Simplify[
  Limit[sigma \[Nu]^0 /. \[Nu] -> 0, \[Nu] -> 0] ==
    -I ne qe^2/(me \[Omega])]];

Print["=== 5. Skin depths ==="];
deltaColl = Sqrt[2/(\[Mu]0 \[Omega] \[Sigma]R)];
exp["skin_collisional", deltaColl];
wpe = Sqrt[ne qe^2/(\[Epsilon]0 me)];
exp["omega_pe", wpe];
deltaInertial = Simplify[c/Sqrt[wpe^2 - \[Omega]^2]];
exp["skin_inertial", deltaInertial];
check["inertial skin -> c/wpe", Simplify[
   Limit[deltaInertial, \[Omega] -> 0] == c/wpe,
   Assumptions -> ne > 0 && qe > 0 && me > 0 && \[Epsilon]0 > 0 && c > 0]];

Print["=== 6. Exact induction load: conducting cylinder in a solenoid ==="];
(* Field diffusion: Laplacian Bz = I w mu0 sigma Bz inside column radius a.
   Regular solution Bz = Ba J0(k r)/J0(k a), k^2 = -I w mu0 sigma.
   Flux route: coil N turns, length lc, radius Rc; loaded impedance per
   the flux linkage. *)
kk2 = -I \[Omega] \[Mu]0 \[Sigma];
bz[r_] := Ba BesselJ[0, kk r]/BesselJ[0, kk a];
(* check the solution solves the diffusion equation
   (1/r)(r Bz')' = i w mu0 sigma Bz, and i w mu0 sigma = -kk^2 *)
check["Bessel solves field-diffusion eq", FullSimplify[
   (1/r) D[r D[bz[r], r], r] + kk^2 bz[r] == 0]];
(* azimuthal E inside from curl B = mu0 sigma E *)
ePhiIn[r_] = Simplify[-(1/(\[Mu]0 \[Sigma])) D[bz[r], r]];
check["E_phi(r) = (k Ba/(mu0 sigma)) J1(kr)/J0(ka)", Simplify[
   ePhiIn[r] == kk Ba BesselJ[1, kk r]/(\[Mu]0 \[Sigma] BesselJ[0, kk a])]];

(* Plasma flux with induced currents *)
fluxPlasma = Integrate[bz[r] 2 Pi r, {r, 0, a},
   Assumptions -> a > 0 && kk > 0];
fluxPlasma = Simplify[fluxPlasma];
check["plasma flux = 2 Pi a Ba J1(ka)/(k J0(ka))", Simplify[
   fluxPlasma == 2 Pi a Ba BesselJ[1, kk a]/(kk BesselJ[0, kk a]),
   Assumptions -> a > 0 && kk > 0]];

(* Impedance seen at the coil: Ba = mu0 (N/lc) I, flux linkage N*(vacuum
   annulus + plasma flux), Z = I w lambda / I. Subtract vacuum coil. *)
zTotal = I \[Omega] nn (\[Mu]0 nn/lc) (Pi (Rc^2 - a^2) + fluxPlasma/Ba);
zVac = I \[Omega] \[Mu]0 nn^2 Pi Rc^2/lc;
zPl = Simplify[zTotal - zVac];
exp["z_plasma_exact",
  I \[Omega] \[Mu]0 nn^2/lc (2 Pi a BesselJ[1, kk a]/(kk BesselJ[0, kk a]) -
     Pi a^2)];
check["Z_pl closed form", Simplify[
   zPl == I \[Omega] \[Mu]0 nn^2/
      lc (2 Pi a BesselJ[1, kk a]/(kk BesselJ[0, kk a]) - Pi a^2),
   Assumptions -> a > 0 && kk > 0]];
check["vacuum limit sigma->0 gives Z_pl->0",
  Simplify[Limit[zPl /. kk -> Sqrt[kk2], \[Sigma] -> 0] == 0]];

(* Low-density (field-penetrating) limit: series in k a *)
zPlSeries = Simplify[Normal[Series[
    I \[Omega] \[Mu]0 nn^2/lc (2 Pi a BesselJ[1, kk a]/
        (kk BesselJ[0, kk a]) - Pi a^2) /. kk -> Sqrt[kk2],
    {\[Sigma], 0, 1}]]];
rplUniform = \[Omega]^2 \[Mu]0^2 \[Sigma] nn^2 Pi a^4/(8 lc);
check["low-density limit R_pl = w^2 mu0^2 sigma N^2 Pi a^4/(8 lc)",
  Simplify[zPlSeries == rplUniform]];
exp["r_pl_uniform", rplUniform];

(* Same limit again from the independent energy-integral route:
   P = (1/2) sigma Int |E_phi|^2 dV with E_phi = r w B/2, B = mu0 N I/lc *)
pAbsUniform = Simplify[
   (1/2) \[Sigma] Integrate[(r \[Omega] \[Mu]0 nn II/(2 lc))^2 2 Pi r lc,
     {r, 0, a}, Assumptions -> a > 0]];
check["energy route: 2 P/I^2 equals flux-route R_pl",
  Simplify[2 pAbsUniform/II^2 == rplUniform]];

(* Finite-coil correction: the solenoid formulas above use the ideal
   ambient field mu0 N I/lc. The real short coil produces the central
   field of block 3, smaller by kgeo; R_pl scales with (B/I)^2. *)
kgeo = lc/Sqrt[lc^2 + 4 Rc^2];
exp["k_geo", kgeo];
check["kgeo = (finite coil B)/(ideal solenoid B)",
  Simplify[kgeo == bCenter/(\[Mu]0 nn II/lc),
   Assumptions -> Rc > 0 && lc > 0]];
pAbsFinite = Simplify[
   (1/2) \[Sigma] Integrate[
     (r \[Omega] bCenter/2)^2 2 Pi r lc, {r, 0, a},
     Assumptions -> a > 0 && Rc > 0 && lc > 0]];
check["energy route with finite-coil field gives kgeo^2 R_pl",
  Simplify[2 pAbsFinite/II^2 == kgeo^2 rplUniform,
   Assumptions -> Rc > 0 && lc > 0]];

(* High-density (skin) limit: numeric check that
   R_pl -> 2 Pi a N^2/(lc sigma delta) *)
skinRefRule = {\[Omega] -> 2 Pi 13.56*^6, \[Mu]0 -> 4 Pi 10^-7,
   \[Sigma] -> 5000., a -> 0.035, lc -> 0.05, nn -> 5};
deltaVal = Sqrt[2/(\[Mu]0 \[Omega] \[Sigma])] /. skinRefRule;
rplExactNum = Re[zPl /. kk -> Sqrt[kk2] /. skinRefRule];
rplSkinNum = (2 Pi a nn^2/(lc \[Sigma] deltaVal)) /. skinRefRule;
checkNum["skin limit within 3% at delta/a = " <>
   ToString[N[deltaVal/0.035, 3]], rplExactNum, rplSkinNum, 0.03];

Print["=== 7. Global model closure ==="];
(* R_pl = aa ne (field-penetrating regime), plasma power balance
   eta P = bb ne with bb = e uB Aeff epsT. Solve for ne. *)
eta = aa ne/(Rcoil + aa ne);
neSol = Simplify[Solve[eta PL == bb ne && ne != 0, ne][[1, 1, 2]]];
exp["ne_closed_form", neSol];
check["ne = PL/bb - Rcoil/aa", Simplify[neSol == PL/bb - Rcoil/aa]];
check["closed form satisfies the balance", Simplify[
   ((eta PL - bb ne) /. ne -> neSol) == 0]];
pMin = bb Rcoil/aa;
exp["p_min", pMin];
check["ne -> 0 at PL = Pmin", Simplify[(neSol /. PL -> pMin) == 0]];
(* Coil current at the operating point: PL = I^2 (Rcoil + aa ne)/2 *)
iOp = Simplify[Sqrt[2 PL/(Rcoil + aa neSol)],
   Assumptions -> aa > 0 && bb > 0 && Rcoil > 0 && PL > bb Rcoil/aa];
check["operating current I^2 = 2 bb/aa independent of PL",
  Simplify[iOp == Sqrt[2 bb/aa],
   Assumptions -> aa > 0 && bb > 0 && Rcoil > 0 && PL > bb Rcoil/aa]];
exp["i_op", Sqrt[2 bb/aa]];

Print["=== 8. Particle balance and Bohm speed ==="];
(* kiz(Te) ng = uB/deff defines Te; document the pieces symbolically *)
uB = Sqrt[qe Te/Mi];
exp["bohm_speed", uB];
deff = Rp lp/(2 (Rp hl + lp hR));
exp["d_eff", deff];
check["deff = V/Aeff", Simplify[
   deff == (Pi Rp^2 lp)/(2 Pi Rp^2 hl + 2 Pi Rp lp hR)]];

Print["=== 9. Paschen curve ==="];
vb = BP pd/(Log[AP pd] - Log[Log[1 + 1/\[Gamma]se]]);
exp["paschen_vb", vb];
pdMin = Simplify[pd /. Solve[D[vb, pd] == 0 && pd > 0, pd,
     Assumptions -> AP > 0 && BP > 0 && \[Gamma]se > 0][[1]]];
vbMin = Simplify[vb /. pd -> pdMin,
   Assumptions -> AP > 0 && BP > 0 && 0 < \[Gamma]se < 1];
exp["paschen_pd_min", pdMin];
exp["paschen_v_min", vbMin];
check["pd_min = (e/AP) ln(1+1/gamma)",
  Simplify[pdMin == (E/AP) Log[1 + 1/\[Gamma]se],
   Assumptions -> AP > 0 && \[Gamma]se > 0]];
check["V_min = (e BP/AP) ln(1+1/gamma)",
  Simplify[vbMin == (E BP/AP) Log[1 + 1/\[Gamma]se],
   Assumptions -> AP > 0 && BP > 0 && 0 < \[Gamma]se < 1]];

Print["=== 10. Effective RF field and quiver motion ==="];
(* m dv/dt = -e E0 e^{iwt} - m nu v  ->  drift amplitude and mean power *)
vAmp = qe E0/(me Sqrt[\[Nu]^2 + \[Omega]^2]);
exp["quiver_speed", vAmp];
xAmp = Simplify[vAmp/\[Omega]];
exp["quiver_amplitude", xAmp];
(* mean absorbed power per electron: (e^2 E0^2/2m) nu/(nu^2+w^2) *)
pPerElectron = qe^2 E0^2 \[Nu]/(2 me (\[Nu]^2 + \[Omega]^2));
exp["power_per_electron", pPerElectron];
check["power per electron equals Re(sigma)|E|^2/(2 ne)",
  Simplify[pPerElectron == sigmaRe E0^2/(2 ne)]];
eEff = E0/Sqrt[2] \[Nu]/Sqrt[\[Nu]^2 + \[Omega]^2];
exp["e_effective", eEff];
check["DC limit of effective field", Simplify[
   Limit[eEff, \[Omega] -> 0] == E0/Sqrt[2],
   Assumptions -> \[Nu] > 0 && E0 > 0]];

Print["=== Reference values for the Python cross-check ==="];
(* One reference point evaluated here and re-evaluated independently in
   Python; agreement validates both implementations. *)
constRules = {\[Mu]0 -> 4 Pi 10^-7, \[Epsilon]0 -> 8.8541878128*^-12,
   qe -> 1.602176634*^-19, me -> 9.1093837015*^-31,
   Mi -> 6.6335209*^-26, kB -> 1.380649*^-23, c -> 2.99792458*^8};
refRules = Join[constRules, {\[Omega] -> 2 Pi 13.56*^6, nn -> 5,
    Rc -> 0.05, lc -> 0.05, a -> 0.035, lp -> 0.10, II -> 1.,
    \[Nu] -> nuRef, ne -> 10.^17, \[Gamma]se -> 0.05}];
ngRef = 133.322 2/(1.380649*^-23 300.);   (* 2 Torr, 300 K *)
nuRef = ngRef 1.*^-19 Sqrt[8 1.602176634*^-19 2./(Pi 9.1093837015*^-31)];
sigmaRefC = ne qe^2/(me (\[Nu] + I \[Omega])) //. refRules;
zplRef = zPl /. kk -> Sqrt[-I \[Omega] \[Mu]0 \[Sigma]] /.
    \[Sigma] -> sigmaRefC //. refRules;
refs = {
  {"gamma_swr3", N[gammaOfSWR /. s -> 3]},
  {"b_over_i", N[(bCenter/II) //. refRules]},
  {"delta_cu",
   N[Sqrt[2 1.68*^-8/((2 Pi 13.56*^6) (4 Pi 10^-7))]]},
  {"n_g_2torr", N[ngRef]},
  {"nu_m_2torr_2ev", N[nuRef]},
  {"sigma_re_1e17", N[Re[sigmaRefC]]},
  {"sigma_im_1e17", N[Im[sigmaRefC]]},
  {"delta_coll_1e17", N[Sqrt[2/((4 Pi 10^-7) (2 Pi 13.56*^6)
       Re[sigmaRefC])]]},
  {"r_pl_exact_1e17", N[Re[zplRef]]},
  {"x_pl_exact_1e17", N[Im[zplRef]]},
  {"r_pl_uniform_1e17", N[rplUniform /. \[Sigma] -> Re[sigmaRefC] //.
      refRules]},
  {"k_geo2", N[kgeo^2 //. refRules]},
  {"r_pl_finite_1e17", N[(kgeo^2 //. refRules) Re[zplRef]]},
  {"paschen_pd_min_ar", N[pdMin /. {AP -> 12, \[Gamma]se -> 0.05}]},
  {"paschen_v_min_ar",
   N[vbMin /. {AP -> 12, BP -> 180, \[Gamma]se -> 0.05}]}};
Export["../data/symbolic_reference.csv",
  Prepend[refs, {"name", "value"}], "CSV"];
Print[Grid[refs]];

Print[""];
Print[If[$failures == 0,
  "ALL CHECKS PASSED",
  ToString[$failures] <> " CHECKS FAILED"]];
If[$failures > 0, Exit[1]];
