(* Watertight derivation of the quasilinear decorrelation time and its
   equivalence to the thesis parameter D >> 1.

   Kasilov (validity_of_QL_approximation.pdf) states the cubic phase-damping
   delta-Phi = (1/3) nu_eff om_eff^2 t^3 (eq.28-29) WITHOUT derivation.  We
   derive it from his own near-resonance model equation (eq.26) and verify
   every step, then connect to the thesis dimensionless diffusivity D (eq:D). *)

(* ---------- 1. the decorrelation law, derived from Kasilov eq.26 ---------- *)
(* model PDE (eq.26):  f_t + om_eff x f_phi - nu_eff f_xx = 0
   claimed solution (eq.28): f = exp(i phi - i om_eff x t - (1/3) nu_eff om_eff^2 t^3) *)
fsol = Exp[I phi - I omeff x t - (1/3) nueff omeff^2 t^3];
CheckEq["eq.26  Kasilov decorrelation solution solves the model PDE",
   D[fsol, t] + omeff x D[fsol, phi] - nueff D[fsol, {x, 2}], 0];

(* mechanism: factor f = e^{i phi} h(x,t); phase mixing gives h = e^{-i om_eff x t},
   whose x-wavenumber grows linearly: k_x(t) = om_eff t *)
hmix = Exp[-I omeff x t];
CheckEq["phase mixing: x-wavenumber k_x(t) = om_eff t",
   D[hmix, x]/(I hmix), -omeff t];  (* (1/i h) dh/dx = -k_x ; here = -om_eff t *)

(* instantaneous damping rate nu_eff k_x(t)^2 = nu_eff om_eff^2 t^2 *)
CheckEq["instantaneous damping rate = nu_eff om_eff^2 t^2",
   nueff (omeff t)^2, nueff omeff^2 t^2];

(* accumulated phase damping delta-Phi(t) = int_0^t nu_eff om_eff^2 t'^2 dt'
   = (1/3) nu_eff om_eff^2 t^3  (the cubic law, derived) *)
CheckEq["delta-Phi(t) = (1/3) nu_eff om_eff^2 t^3  (cubic phase damping)",
   Integrate[nueff omeff^2 tp^2, {tp, 0, t}], (1/3) nueff omeff^2 t^3];

(* decorrelation time tau_dec from delta-Phi(tau_dec) = 1 *)
taudec = (3/(nueff omeff^2))^(1/3);
CheckEq["tau_dec = (3/(nu_eff om_eff^2))^{1/3}  from delta-Phi=1",
   (1/3) nueff omeff^2 taudec^3, 1];

(* ---------- 1b. same cubic law from the beat-phase random walk ----------
   Detuning x random-walks under collisions: <dx(t') dx(t'')> = 2 nu_eff min(t',t'').
   Beat phase Phi(t) = int_0^t om_eff x(t') dt' (detuning = beat rate).
   Var Phi = om_eff^2 int int 2 nu_eff min(t',t'') = (2/3) nu_eff om_eff^2 t^3,
   and the coherent amplitude is <e^{i Phi}> = e^{-Var Phi / 2}, so the damping
   exponent Var Phi / 2 equals Kasilov's delta-Phi exactly. *)
(* inner integral int_0^t min(t',t'') dt' split at t'=t'': int_0^t'' t' dt' + int_t''^t t'' dt' *)
minInt = Integrate[tpp^2/2 + tpp (t - tpp), {tpp, 0, t}, Assumptions -> t > 0];
CheckEq["min-kernel double integral = t^3/3 (split into two triangles, no symbolic Min)",
   minInt, t^3/3, t > 0];
CheckEq["Var Phi = (2/3) nu_eff om_eff^2 t^3 (beat-phase random walk, <dx dx>=2 nu min)",
   2 nueff omeff^2 minInt, (2/3) nueff omeff^2 t^3, t > 0 && nueff > 0 && omeff > 0];
CheckEq["damping exponent = Var Phi / 2 = (1/3) nu_eff om_eff^2 t^3 (both routes agree)",
   (1/2) (2/3) nueff omeff^2 t^3, (1/3) nueff omeff^2 t^3];

(* ---------- 2. island timescale and the QL number A_QL ---------- *)
ombN = Sqrt[Op Hm];          (* Kasilov eq.13 island frequency *)
taubN = 2 Pi/ombN;           (* island bounce time *)
AQL = (1/3) nueff omeff^2 taubN^3;   (* Kasilov eqs.29-30 *)

(* A_QL is exactly (tau_bN/tau_dec)^3 : QL <=> tau_dec << tau_bN <=> A_QL>>1 *)
CheckEq["A_QL = (tau_bN/tau_dec)^3",
   AQL, (taubN/taudec)^3, nueff > 0 && omeff > 0 && Op > 0 && Hm > 0];

(* ---------- 3. equivalence to the thesis parameter D (eq:D) ---------- *)
(* D_res = nu_eff om_eff^2 / Op^2 (collisional diffusivity through resonance;
   Obar=Op*DJ => om_eff=Op*dDJ/dx => D_res = nu_eff (om_eff/Op)^2) *)
Dres = nueff omeff^2/Op^2;
Dthesis = Dres Sqrt[Op]/Hm^(3/2);    (* eq:D *)
assum = nueff > 0 && omeff > 0 && Op > 0 && Hm > 0;

CheckEq["D = nu_eff om_eff^2 / om_bN^3  (decorrelation per island bounce)",
   Dthesis, nueff omeff^2/ombN^3, assum];
CheckEq["A_QL = (2pi)^3/3 * D   ->  D>>1 <=> A_QL>>1",
   AQL, (2 Pi)^3/3 Dthesis, assum];
CheckEq["D = (3/(2pi)^3) (tau_bN/tau_dec)^3",
   Dthesis, (3/(2 Pi)^3) (taubN/taudec)^3, assum];
CheckClose["(2pi)^3/3 ~ 82.68", (2 Pi)^3/3, 82.68, 10^-1];
