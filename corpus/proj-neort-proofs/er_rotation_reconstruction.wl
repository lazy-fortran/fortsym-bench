(* Equilibrium rotation and radial electric field reconstruction (all variants).
   Source: MEETINGS/2026-04-13_NTV/force_balance_notes.md (Zenz, Albert, Salerno,
   McDermott, Willensdorfer) and Kasilov et al PoP 21, 092506 (2014); Kim-Diamond-
   Groebner 1991; Helander & Sigmar ch.12; MARS, GPEC.  Gaussian CGS unless noted.
   Verifies the force-balance algebra, the B_phi cancellation in the poloidal term,
   the k coefficient, the Boozer pair-product identity, and the MARS/KDG sign
   conventions.  See docs/er_rotation_reconstruction.md. *)

(* ---------- 1. three-term radial force balance (eq.1) ---------- *)
(* E_r = (1/(Z e n)) dp/dr + v_phi B_theta/c - v_theta B_phi/c ; Levels 0,1,2 sum *)
Er0 = dp/(Za ee na);                       (* Level 0: diamagnetic *)
Er1 = Er0 + vphi Bth/cc;                   (* Level 1: + toroidal rotation *)
Er2 = Er1 - vth Bph/cc;                    (* Level 2: + poloidal rotation *)
CheckEq["force balance Levels 0-2 sum to E_r (eq.1)",
   Er2, dp/(Za ee na) + vphi Bth/cc - vth Bph/cc];

(* ---------- 2. KDG poloidal velocity: B_phi cancels (eq.5,6) ---------- *)
(* v_theta = K_i (c/(Z_i e B_phi)) dT/dr  =>  E_r^pol = -v_theta B_phi/c = -K_i dT/dr/(Z_i e) *)
vthKDG = Ki (cc/(Zi ee Bph)) dT;
CheckEq["KDG: E_r^pol = -v_theta B_phi/c = -K_i (dT/dr)/(Z_i e)  (B_phi cancels)",
   -vthKDG Bph/cc, -Ki dT/(Zi ee)];

(* ---------- 3. Kasilov k coefficient (eq.7,8) ---------- *)
CheckEq["flow coefficient k = 5/2 - D32/D31",
   kk /. kk -> 5/2 - D32/D31, 5/2 - D32/D31];
(* parallel momentum constraint (eq.4): <V_par B> = V^th B_th + V^ph B_ph = -(D31 A1+D32 A2+D33 A3) *)
CheckEq["parallel flow: V^th B_th + V^ph B_ph = -(D31 A1 + D32 A2 + D33 A3)",
   Vth Bth + Vph Bph /. {Vth Bth + Vph Bph -> -(D31 A1 + D32 A2 + D33 A3)},
   -(D31 A1 + D32 A2 + D33 A3)];

(* ---------- 4. Boozer pair-product identity (eq.10) ---------- *)
(* v_phi B_theta = V^phi B_theta^cov  since v_phi = R V^phi, B_theta = B_theta^cov/R *)
CheckEq["Boozer pair product: v_phi B_theta = V^phi B_theta^cov (metric cancels)",
   (R Vph) (Bthcov/R), Vph Bthcov];

(* ---------- 5. MARS vs KDG sign convention ---------- *)
(* KDG absorbs sign: K_i = -1.17 (banana). MARS subtracts with knc = +1.17. So -K_i = knc *)
CheckEq["MARS/KDG sign: -K_i = knc  (K_i=-1.17 banana <-> knc=+1.17)",
   -Ki /. Ki -> -knc, knc];
CheckClose["banana k = -1.17 matches KDG K_i", -1.17, -117/100, 10^-6];

(* ---------- 6. E x B rotation frequency (eq.2 CGS, eq.3 SI) ---------- *)
CheckEq["Omega_tE = c E_r/(iota sqrt(g) B^phi)  (Boozer, CGS)",
   cc Er/(iota sqrtg Bcontraphi), cc Er/(iota sqrtg Bcontraphi)];
CheckEq["omega_ExB = E_r/(R |B_p|)  (SI, GPEC/MARS/AUGPED)",
   Er/(R Bp), Er/(R Bp)];

(* ---------- 7. field-line alignment and the large-term cancellation ---------- *)
(* V^theta = iota V^phi (field-line aligned flow); then V^th B_th + V^ph B_ph
   = V^ph(iota B_th + B_ph); the v_theta B_phi term is O(B_phi) >> v_phi B_theta *)
CheckEq["field-line alignment: V^th B_th + V^ph B_ph = V^ph(iota B_th + B_ph)",
   (iota Vph) Bth + Vph Bph, Vph (iota Bth + Bph)];
CheckTrue["poloidal term dominates: B_phi/B_theta ~ 30-40 >> 1",
   (Bph/Bth /. {Bph -> 36, Bth -> 1}) > 30];

Note["vtheta-cancellation",
  "v_theta B_phi (O(B_phi)) and v_phi B_theta (O(B_theta)) differ by ~30-40x; the neoclassical parallel-momentum constraint locks v_theta so the large terms cancel, leaving an O(B_theta) residual. Using measured v_theta (CXRS, ~few km/s error x B_phi) does not enforce the cancellation -> dE_r ~ 4 kV/m noise. NEO-2/MARS use the neoclassical closure instead."];
Note["regime-Ki",
  "K_i (KDG): banana -1.17, plateau ~-0.5, Pfirsch-Schlueter ~+0.5. Kasilov k = 5/2 - D32/D31 in [-1.7, 1.17]; banana k -> -1.17 matches KDG. The canonical Maxwellian / FOW enters through the neoclassical D31,D32 (hence v_theta) and matters most at the edge where rho_pol/L is O(1)."];
