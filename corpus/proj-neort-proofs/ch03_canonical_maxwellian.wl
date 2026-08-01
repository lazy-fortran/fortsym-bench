(* The canonical Maxwellian f0 (Hager-Chang term; = Maxwellian of the constants
   of motion, Jeans theorem).  In the axisymmetric background the guiding-centre
   motion has three invariants H, p_phi, J_perp; any f0(H,p_phi,J_perp) is an
   exact collisionless equilibrium.  At low collisionality banana mixing makes
   f0 constant along orbits, realized as a local shifted Maxwellian evaluated at
   the orbit/banana-tip radius r_phi(p_phi).  Refs: Albert et al PoP 23, 082515
   (2016); Kasilov et al PoP 21, 092506 (2014); Hager & Chang (XGC); NEO-RT
   doc/driftorbit.lyx.  See docs/canonical_maxwellian.md.
   K = H - e Phi is the kinetic energy; T,n,Phi profiles; omE = E x B frequency. *)

(* ---------- 1. Jeans theorem: any function of the actions is an equilibrium --------- *)
PB[f_, g_, th_, J_] := D[f, th] D[g, J] - D[f, J] D[g, th];
CheckEq["Jeans: {f0(J), H0(J)} = 0  (function of actions is a collisionless equilibrium)",
   PB[f0fun[Jv], H0fun[Jv], thv, Jv], 0];

(* ---------- 2. canonical Maxwellian f0(H, p_phi) is an equilibrium ----------
   H and p_phi are constants of motion ({p_phi,H}=0 axisymmetry) => {f0(H,p_phi),H}=0 *)
CheckEq["{f0(H,p_phi), H} = 0 given {p_phi,H}=0 (canonical Maxwellian is an equilibrium)",
   D[f0c[Hs, Ps], Hs] PBHH + D[f0c[Hs, Ps], Ps] PBpH /. {PBHH -> 0, PBpH -> 0}, 0];

(* ---------- 3. shifted (rotating) Maxwellian: completion of the square ----------
   H - omE p_phi with H = (1/2) m (vphi^2+vperp^2) + e Phi, p_phi = m R vphi + (e/c) psi
   gives a Maxwellian shifted by rigid rotation V = omE R *)
Hkin = (1/2) mm (vphi^2 + vperp^2);
pphi = mm R vphi + (ee/cc) psi;
CheckEq["H - omE p_phi = (1/2) m (v - V)^2 + Phi_eff,  V = omE R  (shifted Maxwellian)",
   (Hkin + ee Phi) - omE pphi,
   (1/2) mm (vperp^2 + (vphi - omE R)^2) + (ee Phi - (1/2) mm omE^2 R^2 - omE (ee/cc) psi)];

(* ---------- 4. thermodynamic-force drive: gradient at FIXED H (the invariant) ----------
   f0 = n(r) (m/2 pi T(r))^{3/2} exp(-(H - e Phi(r))/T(r));  d ln f0/dr at fixed H
   gives A1 + (K/T) A2 with K = H - e Phi.  The electric force enters A1 because
   we differentiate along the invariant H, not along the kinetic energy K. *)
f0M = nf[r] (mm/(2 Pi Tf[r]))^(3/2) Exp[-(Hh - ee Phif[r])/Tf[r]];
dlnf = D[Log[f0M], r];
Ksym = Hh - ee Phif[r];
A1 = nf'[r]/nf[r] + ee Phif'[r]/Tf[r] - (3/2) Tf'[r]/Tf[r];
A2 = Tf'[r]/Tf[r];
CheckEq["d ln f0/dr|_H = A1 + (K/T) A2,  A1 = dln n/dr + (e/T)dPhi/dr - (3/2)dln T/dr",
   dlnf, A1 + (Ksym/Tf[r]) A2];

(* ---------- 5. banana-tip radius r_phi and finite-orbit-width parameter ----------
   p_phi = (e/c) psi(r) + m R vpar; banana tip vpar=0 => p_phi=(e/c)psi(r_phi) *)
CheckEq["banana tip: p_phi(vpar=0) = (e/c) psi(r_phi)  (orbit label r_phi)",
   ((ee/cc) psifun[rphi] + mm R vpar) /. vpar -> 0, (ee/cc) psifun[rphi]];

(* orbit width = poloidal Larmor radius; FOW small parameter rho_pol/L_n *)
CheckEq["orbit width delta r = (c m vpar)/(e B_pol) = rho_pol  (psi'=R B_pol, p_phi fixed)",
   (cc/ee) (mm R vpar)/(R Bpol), (cc mm vpar)/(ee Bpol)];
CheckEq["FOW small parameter = rho_pol/L_n  (thin-orbit r=r_phi valid for rho_pol << L_n)",
   ((cc mm vth)/(ee Bpol))/Ln, rhopol/Ln /. rhopol -> (cc mm vth)/(ee Bpol)];

Note["banana-mixing",
  "low collisionality (nu << omega_b): fast bounce phase-mixes f0 to constant along orbits (function of invariants); collisions thermalize energy => Maxwellian with parameters depending on p_phi (canonical Maxwellian). High collisionality (nu >> omega_b): local Maxwellian f_M(r). Crossover at nu ~ omega_b."];
Note["fow-validity",
  "thin-orbit r=r_phi valid for rho_pol/L_n << 1; FOW corrections are O(rho_pol/L_n). Two conventions: standard neoclassical f0=f_M(r), FOW in f1; canonical-Maxwellian f0=f_M(r_phi), leading FOW shift inside f0."];
