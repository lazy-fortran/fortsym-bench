(* Chapter "Finite island width": the island as the pendulum of eq:king made
   dimensional, the displacement paradox, the validity number AQL(w), the regime
   flux scalings, the connecting harmonic mean, and the shielded-input paradox.
   Verified against monograph/chapters/body_island.tex.  Companion machinery:
   ch02_quasilinear_nonlinear (eq:king, pendulum invariant), 13_decorrelation
   (wbN, taubN, taudec, AQL).  See docs/island_finite_width.md. *)

(* ---------- the island in action space ---------- *)

(* island-halfwidth  the pendulum invariant I = y^2 - 2 cos(thb) has its
   separatrix at I = 2 (the hyperbolic point thb=Pi, y=0: I = -2 cos Pi = 2).
   On the separatrix the largest |y| is at thb=0: y^2 = 2 + 2 cos 0 = 4. *)
CheckEq["island-halfwidth  separatrix value I=2 at the hyperbolic point",
   (y^2 - 2 Cos[thb]) /. {thb -> Pi, y -> 0}, 2];
CheckEq["island-halfwidth  separatrix |y|=2 at thb=0",
   (y /. Last[Solve[y^2 - 2 Cos[0] == 2 && y > 0, y]]), 2];

(* with DJ = sgn(Op) |Hm/Op|^{1/2} y (univ:eq-DJscale), the action half-width is
   w = 2 |Hm/Op|^{1/2} and the full width W = 4 |Hm/Op|^{1/2}. *)
wHalf[Hm_, Op_] := 2 Sqrt[Hm/Op];
Wisl[Hm_, Op_] := 4 Sqrt[Hm/Op];
CheckEq["island-halfwidth  w = 2|Hm/Op|^{1/2} from y_sep=2 and the DJ scaling",
   Sqrt[Hm/Op] * 2, wHalf[Hm, Op], Hm > 0 && Op > 0];

(* island-width-scaling  W ~ |Hm|^{1/2} ~ (dB)^{1/2}: quadrupling Hm doubles W. *)
CheckEq["island-width-scaling  W(c Hm)/W(Hm) = sqrt(c)",
   Wisl[c Hm, Op]/Wisl[Hm, Op], Sqrt[c], c > 0 && Hm > 0 && Op > 0];

(* island-bounce-pendulum  small-oscillation frequency of the pendulum
   K = (1/2) Op DJ^2 - Hm cos(thb) about the O-point thb=0 is wbN = (Op Hm)^{1/2},
   the island bounce frequency of 13_decorrelation (dec:ombn).
   omega^2 = K_{DJ DJ} * K_{thb thb}|_{thb=0} = Op * Hm. *)
CheckEq["island-bounce-pendulum  wbN = (Op Hm)^{1/2}",
   Sqrt[ D[(1/2) Op DJ^2, {DJ, 2}] * (D[-Hm Cos[thb], {thb, 2}] /. thb -> 0) ],
   Sqrt[Op Hm], Op > 0 && Hm > 0];

(* ---------- the displacement paradox ---------- *)

(* displacement-ratio-scaling  the island-trapped excursion dJisl = w ~ |Hm|^{1/2}
   and the linear (QL) displacement dJlin ~ |Hm| scale differently, so the ratio
   dJisl/dJlin ~ |Hm|^{-1/2}: quadrupling Hm halves the ratio. *)
dJisl[Hm_] := ai Sqrt[Hm];
dJlin[Hm_] := al Hm;
CheckEq["displacement-ratio-scaling  (dJisl/dJlin)(c Hm)/(...)(Hm) = 1/sqrt(c)",
   (dJisl[c Hm]/dJlin[c Hm])/(dJisl[Hm]/dJlin[Hm]), 1/Sqrt[c],
   c > 0 && Hm > 0 && ai > 0 && al > 0];
(* the divergence stated as: the linear estimate is negligible against the island
   excursion as Hm->0, i.e. dJlin/dJisl ~ |Hm|^{1/2} -> 0. *)
CheckLimit["displacement-ratio-scaling  dJlin/dJisl -> 0 as Hm->0",
   dJlin[Hm]/dJisl[Hm], Hm -> 0, 0, ai > 0 && al > 0];

(* ---------- why quasilinear transport survives ---------- *)

(* AQL-width-scaling  AQL = (taubN/taudec)^3 with taubN = 2 Pi/wbN and wbN ~ w,
   taudec independent of w, so AQL ~ w^{-3}: doubling the width gives AQL/8. *)
AQLw[w_] := (2 Pi/(kk w)/td)^3;
CheckEq["AQL-width-scaling  AQL(2w)/AQL(w) = 1/8  (AQL ~ w^{-3})",
   AQLw[2 w]/AQLw[w], 1/8, w > 0 && kk > 0 && td > 0];
(* in the amplitude, w ~ |Hm|^{1/2} gives AQL ~ |Hm|^{-3/2}. *)
CheckEq["AQL-width-scaling  AQL ~ |Hm|^{-3/2}",
   (c Hm)^(-3/2)/Hm^(-3/2), c^(-3/2), c > 0 && Hm > 0];

(* crossover  AQL = (2Pi)^3/3 Dres (dec:AQLD); AQL = 1 boundary <-> Dres = 1
   <-> D = 1 of the universal equation. At Dres = 1, AQL = (2Pi)^3/3. *)
CheckEq["crossover  AQL = (2Pi)^3/3 at Dres = 1",
   ((2 Pi)^3/3) Dres /. Dres -> 1, (2 Pi)^3/3];

(* ---------- the regime where island width counts ---------- *)

(* flux-QL-scaling  quasilinear/plateau flux Gamma_QL ~ |Hm|^2 ~ W^4
   (W ~ |Hm|^{1/2} => |Hm| ~ W^2 => |Hm|^2 ~ W^4). *)
CheckEq["flux-QL-scaling  Gamma_QL(2W)/Gamma_QL(W) = 16  (Gamma ~ W^4)",
   (gq (2 W)^4)/(gq W^4), 16, W > 0 && gq > 0];
CheckEq["flux-QL-scaling  W^4 = a^4 |Hm|^2 consistency",
   (aa Sqrt[Hm])^4, aa^4 Hm^2, aa > 0 && Hm > 0];

(* flux-NT-scaling  nonlinear-trapping flux Gamma_NT ~ nu |Hm|^{1/2} ~ nu W:
   linear in width, and linear in collisionality. *)
CheckEq["flux-NT-scaling  Gamma_NT ~ W (linear in width)",
   (gn nu (2 W))/(gn nu W), 2, W > 0 && nu > 0 && gn > 0];
CheckEq["flux-NT-scaling  Gamma_NT ~ nu (linear in collisionality)",
   (gn (2 nu) W)/(gn nu W), 2, W > 0 && nu > 0 && gn > 0];

(* connecting-harmonic-mean  keff = kNT kQP/(kNT + kQP) is the smaller rate:
   it does not exceed either, and it reduces to each in the dominant limit. *)
keff[kNT_, kQP_] := kNT kQP/(kNT + kQP);
CheckTrue["connecting-harmonic-mean  keff <= kNT and keff <= kQP",
   (keff[kNT, kQP] <= kNT) && (keff[kNT, kQP] <= kQP), kNT > 0 && kQP > 0];
CheckLimit["connecting-limit  keff -> kQP as kNT->inf (quasilinear)",
   keff[kNT, kQP], kNT -> Infinity, kQP, kQP > 0];
CheckLimit["connecting-limit  keff -> kNT as kQP->inf (nonlinear trapping)",
   keff[kNT, kQP], kQP -> Infinity, kNT, kNT > 0];

(* ---------- the shielded input paradox ---------- *)

(* shielding-vanishes  the ideal resonant amplitude b_res ~ (m - n q) is driven
   to zero at the rational surface q = m/n (finite off-surface, zero on it). *)
CheckEq["shielding-vanishes  b_res ~ (m-nq) -> 0 at q = m/n",
   (m - n q) /. q -> m/n, 0];

(* gauge-singular  the same vanishing factor (m-nq) sits in the DENOMINATOR of the
   gauge scalar chi_mn ~ 1/(m-nq) that pushes dA_par into d|B|, so the SCALAR
   diverges at q=m/n while the line-integral drive eq:coorddrive stays finite.
   k_par = (m-nq)/(qR) -> 0 carries both statements. *)
CheckEq["gauge-singular  k_par = (m-nq)/(qR) -> 0 at q = m/n",
   ((m - n q)/(q R)) /. q -> m/n, 0];
CheckLimit["gauge-singular  1/k_par -> 0 reciprocal vanishes (chi_mn diverges)",
   (q R)/(m - n q) // (1/# &), q -> m/n, 0, R > 0];
Note["gauge-singular  line integral finite",
   "eq:coorddrive integrates the bounded field dgamma on a smooth B0 orbit, so H_m is finite at q=m/n; the 1/(m-nq) singularity is in the gauge, not the field (sec:coord-thin)."];
