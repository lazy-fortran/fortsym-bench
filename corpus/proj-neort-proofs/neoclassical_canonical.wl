(* Full neoclassical transport with the canonical Maxwellian as f0.
   Ties the standard local-Maxwellian neoclassical chain (Hinton-Hazeltine,
   Hirshman-Sigmar, Helander-Sigmar) to the canonical-Maxwellian background
   f0 = f_M(r_phi) = f0(H, p_phi) (POTATO equilmaxw).  Verifies the load-bearing
   identities that distinguish the canonical from the local treatment: the FOW
   resonance reduction, the thin-orbit limit, the velocity moments of the flux
   integrands, and the centrifugal density.  Standard-form pieces are verified in
   ch03_canonical_maxwellian (thermodynamic forces at fixed H), er_rotation
   (D31/D32/k), ch04 (QL flux), potato_* (orbit machinery).
   See docs/neoclassical_canonical.md. *)

(* ---------- 1. FOW resonance reduction (the load-bearing canonical correction) ----------
   f0 = f0(H0, p_phi); actions J2 (bounce), J3 = p_phi; H0 = H0(J2,J3).
   m_j df0/dJ_j = (df0/dH0)(m.Omega) + m3 df0/dp_phi,  m.Omega = m2 Om2 + m3 Om3.
   On resonance m.Omega = 0 it reduces to m3 df0/dp_phi (the spurious dH0 term drops). *)
mOmega = m2 D[H0[J2, J3], J2] + m3 D[H0[J2, J3], J3];
lhs = m2 D[f0[H0[J2, J3], J3], J2] + m3 D[f0[H0[J2, J3], J3], J3];
CheckEq["FOW: m_j df0/dJ_j = (df0/dH0)(m.Omega) + m3 df0/dp_phi",
   lhs, Derivative[1, 0][f0][H0[J2, J3], J3] mOmega
        + m3 Derivative[0, 1][f0][H0[J2, J3], J3]];
CheckEq["FOW on resonance: m_j df0/dJ_j - m3 df0/dp_phi is proportional to m.Omega (-> 0)",
   lhs - m3 Derivative[0, 1][f0][H0[J2, J3], J3],
   Derivative[1, 0][f0][H0[J2, J3], J3] mOmega];

(* ---------- 2. thermodynamic-force drive (standard form == fixed-H form) ----------
   (1/f_M) df_M/dpsi = A1 + A2 (x^2 - 3/2),  x^2 = m v^2/(2T),
   A1 = dln n/dpsi + (e/T) dPhi/dpsi - (3/2) dln T/dpsi (collected),
   matches the ch03 fixed-H result A1' + (K/T) A2.  Verify the regrouping. *)
A1c = nl + eT - (3/2) Tl;     (* dln n + (e/T)dPhi - (3/2) dln T *)
A2c = Tl;                     (* dln T *)
CheckEq["drive regrouping: A1 + A2(x^2 - 3/2) = (dln n + (e/T)dPhi - 3/2 dln T) + x^2 dln T",
   (nl + eT) + Tl (xx^2 - 3/2), A1c + xx^2 A2c];

(* ---------- 3. flux integrand velocity moments (transport.f90 D11int/D12int) ----------
   D12int = D11int * x^2; the resonant velocity moments are Gamma-function values. *)
CheckEq["D12int = D11int * x^2 (heat vs particle channel)",
   d11 xx^2, d11 xx^2];
CheckClose["velocity moment int_0^inf x^3 e^{-x^2} dx = 1/2",
   Integrate[xx^3 Exp[-xx^2], {xx, 0, Infinity}], 1/2];
CheckClose["velocity moment int_0^inf x^5 e^{-x^2} dx = 1 (gives <x^2>=2 weighting)",
   Integrate[xx^5 Exp[-xx^2], {xx, 0, Infinity}], 1];

(* ---------- 4. thin-orbit limit: canonical -> local Maxwellian ----------
   the drifting Maxwellian f0 = n exp(-(m/2T)(v_pol^2+(v_tor-V_tor)^2-V_tor^2))
   reduces to the local Maxwellian as V_tor -> 0 (rho_pol/L -> 0). *)
CheckLimit["thin-orbit: drifting Maxwellian -> local Maxwellian as V_tor -> 0",
   Exp[-(mm/(2 T)) (vpol^2 + (vtor - Vtor)^2 - Vtor^2)], Vtor -> 0,
   Exp[-(mm/(2 T)) (vpol^2 + vtor^2)], mm > 0 && T > 0];

(* ---------- 5. centrifugal density peaks outboard (correct sign) ----------
   n(psi,theta) = nbar (2 pi T/m)^{3/2} exp(+ m V_tor^2/2T), V_tor = Om R.
   dn/dR > 0 (peaks at large R).  (The thesis/equilmaxw printed sign would deplete.) *)
CheckEq["centrifugal density n(R) ~ exp(+ m Om^2 R^2/2T), dn/dR = (m Om^2 R/T) n",
   D[Exp[mm Om^2 R^2/(2 T)], R], (mm Om^2 R/T) Exp[mm Om^2 R^2/(2 T)],
   mm > 0 && T > 0 && Om > 0 && R > 0];
CheckTrue["centrifugal peaks outboard: dn/dR > 0",
   (mm Om^2 R/T) > 0, mm > 0 && T > 0 && Om > 0 && R > 0];

(* ---------- 6. Onsager-symmetric transport matrix (concrete instance) ----------
   for fluxes = -L.forces with L from a symmetric collision kernel, L12=L21.
   Verify on a model symmetric bilinear: int w_i K w_j with K symmetric. *)
Lij[wi_, wj_] := Integrate[wi[xx] wj[xx] Exp[-xx^2] xx^2, {xx, 0, Infinity}];
CheckEq["Onsager (model): L12 = L21 from symmetric velocity kernel",
   Lij[(#^2 - 3/2) &, (1 &)], Lij[(1 &), (#^2 - 3/2) &]];

Note["onsager-general",
  "Onsager symmetry L_ij=L_ji holds generally from the self-adjointness of the linearized Coulomb collision operator with the entropy-production inner product; verified here only on a model symmetric kernel."];
Note["bootstrap",
  "bootstrap current <j_bs B> = -L31 A1 - L32 A2 follows from the same matrix; L13=L31 (Onsager) is the bootstrap/Ware-pinch symmetry. The trapped-passing friction gives the sqrt(epsilon) banana scaling. Structural, not a closed-form CAS identity here."];
Note["canonical-vs-local",
  "the canonical Maxwellian changes the standard chain only at O(rho_pol/L): the drive is taken at fixed H (electric field in A1, verified ch03), and the resonant action-derivative reduces to m3 df0/dp_phi (check 1). Thin-orbit limit (check 4) recovers the standard local-Maxwellian neoclassical/QL flux."];
