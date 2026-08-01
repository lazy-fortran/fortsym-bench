(* Symbolic derivations for the Cheapos II RF plasma model.
   Run:  math -script derivations.wl
   Prints each result and exports LaTeX snippets to symbolic/tex/*.tex        *)

SetDirectory[DirectoryName[$InputFileName]];
If[! DirectoryQ["tex"], CreateDirectory["tex"]];
exp[name_, expr_] := (
   Export["tex/" <> name <> ".tex", ToString[TeXForm[expr]], "Text"];
   Print[name, " = ", TeXForm[expr]];
);
line[s_] := Print["\n===== ", s, " ====="];

(* --------------------------------------------------------------------- *)
line["1. Reflection coefficient, SWR, delivered power"];
gammaOfSWR = Solve[swr == (1 + g)/(1 - g), g][[1, 1, 2]] // Simplify;
exp["gamma_of_swr", gammaOfSWR];
swrOfGamma = (1 + Abs[g])/(1 - Abs[g]);
exp["swr_of_gamma", swrOfGamma];
pdelFrac = 1 - g^2;
exp["pdel_frac", pdelFrac];
(* check SWR = 3 -> |Gamma| = 1/2, delivered fraction 3/4 *)
Print["check SWR=3: |Gamma|=", gammaOfSWR /. swr -> 3,
      "  delivered=", pdelFrac /. g -> 1/2];

(* --------------------------------------------------------------------- *)
line["2. Series RLC resonance and quality factor"];
Zrlc = R + I (w L - 1/(w C));
w0 = w /. Last[Solve[w L == 1/(w C), w]] // PowerExpand;
exp["omega0", w0];
Qfac = (w0 L)/R // Simplify;
exp["Q_factor", Qfac];
(* 3 dB bandwidth: |Z|^2 = 2 R^2 gives the half-power detuning *)
halfPower = Solve[(w L - 1/(w C))^2 == R^2, w] ;
Print["half-power roots w = ", halfPower // Simplify];
bw = R/L;                      (* Delta omega between the two half-power points *)
exp["bandwidth", bw];
Print["Q = w0/Delta_omega ? ", Simplify[w0/bw == Qfac]];

(* --------------------------------------------------------------------- *)
line["3. L-network match to 50 ohm (real load)"];
(* shunt X_p across R_hi, series X_s to R_lo; match to Rlo=Z0 *)
Qmatch = Sqrt[Rhi/Rlo - 1];
exp["Lmatch_Q", Qmatch];
Xp = Rhi/Qmatch // Simplify;   exp["Lmatch_Xp", Xp];
Xs = Qmatch Rlo // Simplify;    exp["Lmatch_Xs", Xs];

(* --------------------------------------------------------------------- *)
line["4. On-axis field of an N-turn loop (Biot-Savart)"];
(* element field on axis: dB = mu0 I/(4 pi) * R dphi * R/(R^2+z^2)^(3/2) *)
Bz = n0 Integrate[mu0 Ic/(4 Pi) R^2/(R^2 + z^2)^(3/2), {phi, 0, 2 Pi}];
Bz = Bz // Simplify;
exp["Bz_axis", Bz];
Bcenter = Simplify[Bz /. z -> 0, R > 0];
exp["B_center", Bcenter];

(* --------------------------------------------------------------------- *)
line["5. Faraday-induced azimuthal field"];
(* uniform B(t)=B0 cos(w t) over a disk radius r: 2 pi r E = - d/dt (pi r^2 B) *)
Bt = B0 Cos[w t];
Ephi = -1/(2 Pi r) D[Pi r^2 Bt, t] // Simplify;
exp["E_phi", Ephi];
EphiPeak = Coefficient[Ephi, Sin[w t]] // Simplify;
exp["E_phi_peak", EphiPeak];

(* --------------------------------------------------------------------- *)
line["6. Drude conductivity: real and imaginary parts"];
sig = ne e^2/(me (nu - I w));
sigRe = ComplexExpand[Re[sig]] // Simplify;   (* all symbols real by default *)
sigIm = ComplexExpand[Im[sig]] // Simplify;
exp["sigma_re", sigRe];
exp["sigma_im", sigIm];
Print["collisional limit nu>>w: ", Limit[sig, w -> 0]];
Print["inertial limit w>>nu:   ", Simplify[sig /. nu -> 0]];

(* --------------------------------------------------------------------- *)
line["7. Skin depths"];
(* collisionless: k = (1/c) Sqrt[w^2 - wpe^2]; for w<wpe it is imaginary and
   the field decays as e^{-z/delta} with delta = 1/Im[k] = c/Sqrt[wpe^2-w^2] *)
kcl = Sqrt[w^2 - wpe^2]/cc;
deltaCless = Simplify[cc/Sqrt[wpe^2 - w^2], wpe > w > 0];
exp["skin_collisionless", deltaCless];
Print["low-frequency form w<<wpe -> ", Simplify[deltaCless /. w -> 0, wpe > 0]];
deltaColl = Sqrt[2/(mu0 w sigDC)];
exp["skin_collisional", deltaColl];

(* --------------------------------------------------------------------- *)
line["8. Absorbed power density"];
pabs = 1/2 sigRe Emag^2 // Simplify;   (* sigRe now the clean real part *)
exp["p_abs", pabs];

(* --------------------------------------------------------------------- *)
line["9. Paschen breakdown minimum"];
strip[x_] := x /. ConditionalExpression[a_, _] :> a;
Vb = Bp u/(Log[Ap u] - Log[Log[1 + 1/gse]]);   (* u = p d *)
dVb = D[Vb, u] // Simplify;
uMin = strip[Solve[dVb == 0, u][[1, 1, 2]] // Simplify];
exp["paschen_pd_min", uMin];
VbMin = strip[Simplify[Vb /. u -> uMin]];
exp["paschen_V_min", VbMin];
Print["pd_min = e/Ap * ln(1+1/gse) ? ",
      Simplify[uMin == E/Ap Log[1 + 1/gse]]];

(* --------------------------------------------------------------------- *)
line["10. ICP transformer: referred plasma impedance"];
Ztot = I w L11 + w^2 M^2/(R2 + I w L22);
Rpl = ComplexExpand[Re[Ztot]] // Simplify;   (* all symbols real *)
Xpl = ComplexExpand[Im[Ztot]] // Simplify;
exp["transformer_Rpl", Rpl];
exp["transformer_Xpl", Xpl];
eta = Rpl/(Rpl + Rcoil) // Simplify;
exp["coupling_eta", eta];

Print["\nAll derivations complete."];
