(* Slide 4: omnigenity. J_par(psi,alpha,lambda) = Integral v_par dl.
   Model well B(l; alpha) = B0 (1 - eps Cos[2 Pi l/L]), minimum at l = 0.
   Omnigenous: eps alpha-independent => dJ/dalpha = 0.
   Non-omnigenous: eps -> eps(alpha) => dJ/dalpha != 0.
   Drift relation verified (bounce-averaged drift-kinetic form, fixed E, mu):
     <psidot>   = -(1/(q tau_b)) dJ/dalpha,
     <alphadot> = +(1/(q tau_b)) dJ/dpsi,
   which conserves J along the drift and gives <psidot> = 0 under omnigenity. *)

failed = 0;
check[name_String, cond_] := Module[{ok = TrueQ[cond]},
    Print[If[ok, "PASS: ", "FAIL: "], name];
    If[! ok, failed++]; ok];

(* ---------- symbolic omnigenous model ---------- *)
Bomni[l_] := b0 (1 - eps Cos[2 Pi l/len]);
vpar[l_] := Sqrt[2 (en - mu Bomni[l])];   (* m = 1 *)

check["omnigenous model: dB/dalpha = 0 symbolically",
    D[Bomni[l], alpha] === 0];
check["omnigenous model: d v_par/dalpha = 0 symbolically",
    Simplify[D[vpar[l], alpha]] === 0];
(* bounce points solve en == mu B(l); alpha absent => alpha-independent,
   so by Leibniz dJ/dalpha = 0 for the omnigenous well. *)
check["omnigenous model: bounce condition en - mu B independent of alpha",
    D[en - mu Bomni[l], alpha] === 0];

(* ---------- numerical J_par(alpha) ---------- *)
(* normalized: B0 = 1, L = 1, v_par = Sqrt[2 E] Sqrt[1 - lam (1 - eps Cos)];
   well minimum at l = 0, bounce points where 1 - lam B(l) = 0 *)
jpar[epsval_?NumericQ, lam_?NumericQ] := Module[{lb},
    lb = ArcCos[(lam - 1)/(lam epsval)]/(2 Pi); (* bounce point, symmetric *)
    2 NIntegrate[Sqrt[2] Sqrt[1 - lam (1 - epsval Cos[2 Pi l])],
        {l, -lb, lb}, AccuracyGoal -> 10, PrecisionGoal -> 10]];

eps0 = 0.2; lam0 = 0.9; (* trapped: lam (1-eps) < 1 < lam (1+eps) *)
jref = jpar[eps0, lam0];
Print["  J_par(eps0, lam0) = ", jref];
check["J_par is real and positive (integrand nonnegative in the well)",
    Abs[Im[jref]] < 10.^-12 && Re[jref] > 0];
jOmni[a_?NumericQ] := jpar[eps0, lam0];                    (* alpha-independent *)
jGen[a_?NumericQ] := jpar[eps0 (1 + 0.3 Cos[a]), lam0];    (* alpha-dependent *)

da = 10.^-3;
dJomni = (jOmni[1. + da] - jOmni[1. - da])/(2 da);
dJgen = (jGen[1. + da] - jGen[1. - da])/(2 da);
Print["  dJ/dalpha (omnigenous)     = ", dJomni];
Print["  dJ/dalpha (alpha-dep well) = ", dJgen];
check["omnigenous well: numerical dJ/dalpha = 0 (|.| < 1e-8)",
    Abs[dJomni] < 10.^-8];
check["alpha-dependent well: numerical dJ/dalpha nonzero (|.| > 1e-3)",
    Abs[dJgen] > 10.^-3];

(* ---------- bounce-averaged drift relation ---------- *)
(* generic J[psi, alpha] at fixed (E, mu); q = charge, taub = bounce time *)
psidot = -D[j[psi, alpha], alpha]/(q taub);
alphadot = D[j[psi, alpha], psi]/(q taub);
jdot = D[j[psi, alpha], psi] psidot + D[j[psi, alpha], alpha] alphadot;
check["drift form conserves J: dJ/dt = J_psi <psidot> + J_alpha <alphadot> = 0",
    Simplify[jdot] === 0];
check["omnigenity dJ/dalpha = 0 implies <psidot> = 0 (no secular radial drift)",
    Simplify[psidot /. Derivative[0, 1][j][psi, alpha] -> 0] === 0];

If[failed > 0,
    Print["RESULT: FAIL (", failed, " checks failed)"]; Quit[1],
    Print["RESULT: PASS"]; Quit[0]];
