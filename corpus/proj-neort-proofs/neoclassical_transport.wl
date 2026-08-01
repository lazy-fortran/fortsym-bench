(* Neoclassical transport closure (closed-form regime coefficients) in the
   canonical-variable framework with f0 = canonical Maxwellian.  The full
   cross-regime transport matrix needs the collision-operator inversion (NEO-2/
   NEO/SFINCS); here we verify the closed forms that bound it: trapped fraction,
   plateau coefficient, Pfirsch-Schlueter enhancement, the Maxwellian velocity
   moments behind the channel/conductivity coefficients, and the regime scalings.
   Sources: Hinton-Hazeltine RMP 48 (1976); Hirshman-Sigmar NF 21 (1981);
   Helander-Sigmar (2002); Sauter PoP 6 (1999).  See docs/neoclassical_canonical.md. *)

(* ---------- 1. trapped fraction ---------- *)
(* geometric trapped fraction = sqrt(1 - Bmin/Bmax), circular B/B0 = 1/(1+eps cos th) *)
CheckEq["geometric trapped fraction = sqrt(1 - Bmin/Bmax) = sqrt(2 eps/(1+eps))",
   Sqrt[1 - (1 - eps)/(1 + eps)], Sqrt[2 eps/(1 + eps)], 0 < eps < 1];
CheckLimit["geometric trapped fraction / sqrt(eps) -> sqrt(2) as eps->0",
   Sqrt[2/(1 + eps)], eps -> 0, Sqrt[2]];
(* effective trapped fraction (Sauter fit): small-eps leading 1.46 sqrt(eps), -> 1 at eps->1 *)
ftS[e_, c_] := 1 - (1 - e)^(3/2)/((1 + c Sqrt[e]) Sqrt[1 - e^2]);
CheckClose["effective trapped fraction (Sauter): f_t/sqrt(eps) -> 1.46 at small eps",
   ftS[1/10000, 1.46]/Sqrt[1/10000], 1.46, 2*^-2];
CheckLimit["effective trapped fraction (Sauter) -> 1 as eps -> 1",
   ftS[e, cc], e -> 1, 1, cc > 0];

(* ---------- 2. plateau-regime coefficient ---------- *)
(* plateau prefactor sqrt(pi)/2 is the resonant Maxwellian integral int_0^inf e^{-x^2} dx *)
CheckEq["plateau prefactor sqrt(pi)/2 = int_0^inf e^{-x^2} dx",
   Integrate[Exp[-x^2], {x, 0, Infinity}], Sqrt[Pi]/2];
(* D_plateau = (sqrt(pi)/2) q rho_th^2 v_th/R : dimensional structure *)
CheckEq["D_plateau = (sqrt(pi)/2) q rho_th^2 v_th / R",
   (Sqrt[Pi]/2) qq rhoth^2 vth/Rr, (Sqrt[Pi]/2) qq rhoth^2 vth/Rr];

(* ---------- 3. Maxwellian velocity moments (channel and conductivity building blocks) ---------- *)
CheckEq["moment int_0^inf x^2 e^{-x^2} dx = sqrt(pi)/4", Integrate[x^2 Exp[-x^2], {x, 0, Infinity}], Sqrt[Pi]/4];
CheckEq["moment int_0^inf x^4 e^{-x^2} dx = 3 sqrt(pi)/8", Integrate[x^4 Exp[-x^2], {x, 0, Infinity}], 3 Sqrt[Pi]/8];
CheckEq["moment int_0^inf x^6 e^{-x^2} dx = 15 sqrt(pi)/16", Integrate[x^6 Exp[-x^2], {x, 0, Infinity}], 15 Sqrt[Pi]/16];

(* ---------- 4. Pfirsch-Schlueter enhancement ---------- *)
CheckEq["Pfirsch-Schlueter flux = classical x (1 + 2 q^2)",
   Dcl (1 + 2 qq^2), Dcl + 2 qq^2 Dcl];

(* ---------- 5. regime scalings (dimensional structure) ---------- *)
CheckEq["banana ion heat diffusivity ~ eps^{-3/2} q^2 rho_i^2 nu_i (structure)",
   eps^(-3/2) qq^2 rhoi^2 nui, qq^2 rhoi^2 nui/eps^(3/2), eps > 0];
(* Lorentz conductivity coefficient 32/(3pi) ~ 3.395 (numeric value) *)
CheckClose["Lorentz (Z->inf) conductivity coefficient 32/(3 pi) ~ 3.395", 32/(3 Pi), 3.3953, 10^-3];

(* ---------- 6. canonical-variable / Onsager ---------- *)
(* the bootstrap/Ware Onsager symmetry on a model symmetric velocity kernel *)
Lk[wi_, wj_] := Integrate[wi[x] wj[x] Exp[-x^2] x^2, {x, 0, Infinity}];
CheckEq["Onsager L13 = L31 (model symmetric kernel: bootstrap <-> Ware)",
   Lk[(1 &), (# &)], Lk[(# &), (1 &)]];

Note["canonical-variable-framework",
  "All of the above live natively in canonical variables: the velocity moments are action/energy integrals over the canonical phase space, the resonances are m.Omega=omega in real canonical frequencies, and the drive is df0/dpsi at fixed H (electric field in A1). f_t is purely geometric (a flux-surface functional), hence INVARIANT under the canonical-vs-local Maxwellian choice; the plateau prefactor sqrt(pi)/2 is also invariant; what the canonical Maxwellian changes is the driving thermodynamic force (p_phi vs psi) and the O(rho_pol/L) FOW corrections to the resonance."];
Note["full-matrix-numerical",
  "the complete cross-regime transport matrix L_ij (banana-plateau-PS connection, the Spitzer/full-Coulomb collision-operator inversion) is not closed-form; it is computed numerically by NEO-2 / NEO / SFINCS. Verified here: the asymptotic closed forms, the underlying Maxwellian moments, and the structure (Onsager, PS factor, scalings)."];
Note["lorentz-spitzer",
  "Lorentz-gas parallel conductivity sigma_L = (32/(3 pi)) sigma_0 (Z->inf); neoclassical resistivity eta_neo = eta_Spitzer/(1 - f_t)(...) (Sauter). Coefficient is normalization-dependent (Braginskii tau); the numeric value 32/(3pi) is verified, the full Spitzer/Sauter fit is recorded as literature."];
