(* Quasilinear validity evaluated for ASDEX Upgrade #30835 and ITER.
   Uses Kasilov's reduced criteria (validity_of_QL_approximation.pdf):
     pitch-angle (barely trapped), eq.32:  A_QL ~ 80 (Lc/lc) / (m_th eps_M^{3/2})
     energy (deeply trapped),     eq.37:  A_QL ~ 12 (Lc/lc) / (n q Mt eps_M A^{3/2})
   with m_th = max(1, n q Mt (2A)^{1/2}).
   The checks verify the arithmetic of the criterion and assert A_QL >> 1
   (taken here as A_QL > 10) GIVEN the parameter estimates below.  Physics inputs
   are mid-radius (s=0.5) estimates; eps_M for #30835 is the NEO-RT base-model
   value (the shot-specific Boozer amplitude is not published).  See
   docs/ql_validity_aug_iter.md. *)

(* Lc/lc = 2 pi q R nu_D / v = 2 pi nu_star eps^{3/2}, eps = a/R *)
LcOverLc[nustar_, eps_] := 2 Pi nustar eps^(3/2);
mth[n_, q_, Mt_, A_] := Max[1, n q Mt Sqrt[2 A]];
AQLpitch[n_, q_, Mt_, A_, epsM_, LL_] := 80 LL/(mth[n, q, Mt, A] epsM^(3/2));
AQLenergy[n_, q_, Mt_, A_, epsM_, LL_] := 12 LL/(n q Mt epsM A^(3/2));

(* ---------- ASDEX Upgrade #30835, mid-radius s=0.5 ---------- *)
Module[{R = 1.65, a = 0.5, q = 2., Mt = 0.036, n = 2, epsM = 1.0*^-3, nustar = 1.0*^-3,
        A, eps, LL, AQLp, AQLe},
  A = R/a; eps = a/R; LL = LcOverLc[nustar, eps];
  AQLp = AQLpitch[n, q, Mt, A, epsM, LL];
  AQLe = AQLenergy[n, q, Mt, A, epsM, LL];
  Note["AUG#30835 inputs",
    "R=1.65 a=0.5 q=2 Mt=0.036 n=2 epsM=1e-3 nu*=1e-3 -> A=" <> ToString[A] <>
    " Lc/lc=" <> ToString[LL] <> " m_th=" <> ToString[mth[n, q, Mt, A]]];
  Note["AUG#30835 A_QL", "pitch=" <> ToString[AQLp] <> "  energy=" <> ToString[AQLe]];
  CheckTrue["AUG#30835 QL valid (pitch-angle): A_QL >> 1", AQLp > 10];
  CheckTrue["AUG#30835 QL valid (energy/deeply-trapped): A_QL >> 1", AQLe > 10];
  (* lock the computed magnitude *)
  CheckClose["AUG#30835 A_QL(pitch) ~ 2.7e3", AQLp, 2657., 50.];
];

(* ---------- ITER baseline, mid-radius, RMP n=3 ---------- *)
Module[{R = 6.2, a = 2.0, q = 2., Mt = 0.03, n = 3, epsM = 1.0*^-3, nustar = 1.0*^-3,
        A, eps, LL, AQLp},
  A = R/a; eps = a/R; LL = LcOverLc[nustar, eps];
  AQLp = AQLpitch[n, q, Mt, A, epsM, LL];
  Note["ITER-RMP inputs",
    "R=6.2 a=2 q=2 Mt=0.03 n=3 epsM=1e-3 nu*=1e-3 -> Lc/lc=" <> ToString[LL] <>
    " m_th=" <> ToString[mth[n, q, Mt, A]]];
  Note["ITER-RMP A_QL(pitch)", ToString[AQLp]];
  CheckTrue["ITER RMP (n=3) QL valid (pitch-angle): A_QL >> 1", AQLp > 10];
];

(* ---------- ITER baseline, TF ripple n=18, larger amplitude ---------- *)
Module[{R = 6.2, a = 2.0, q = 2., Mt = 0.03, n = 18, epsM = 4.0*^-3, nustar = 1.0*^-3,
        A, eps, LL, AQLp},
  A = R/a; eps = a/R; LL = LcOverLc[nustar, eps];
  AQLp = AQLpitch[n, q, Mt, A, epsM, LL];
  Note["ITER-ripple inputs",
    "R=6.2 a=2 q=2 Mt=0.03 n=18 epsM=4e-3 nu*=1e-3 -> Lc/lc=" <> ToString[LL] <>
    " m_th=" <> ToString[mth[n, q, Mt, A]]];
  Note["ITER-ripple A_QL(pitch)", ToString[AQLp]];
  (* still QL but smaller margin: assert > 10, record that it is the tightest case *)
  CheckTrue["ITER TF ripple (n=18, epsM=4e-3) QL valid (pitch-angle): A_QL > 10", AQLp > 10];
];

(* sanity: the validity number grows when collisionality rises or amplitude drops *)
CheckTrue["A_QL increases with collisionality (decorrelation) at fixed amplitude",
   AQLpitch[2, 2, 0.036, 3.3, 1.*^-3, LcOverLc[2.*^-3, 0.3]] >
   AQLpitch[2, 2, 0.036, 3.3, 1.*^-3, LcOverLc[1.*^-3, 0.3]]];
CheckTrue["A_QL decreases with perturbation amplitude (toward non-linear) at fixed collisions",
   AQLpitch[2, 2, 0.036, 3.3, 1.*^-3, LcOverLc[1.*^-3, 0.3]] >
   AQLpitch[2, 2, 0.036, 3.3, 4.*^-3, LcOverLc[1.*^-3, 0.3]]];
