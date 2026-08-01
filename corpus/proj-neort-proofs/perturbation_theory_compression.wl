(* The NEO-RT perturbation is compressional: the magnetic decomposition that makes it
   so, and the contrast with Brizard-Hahm gyrokinetics and the KiLCA/KAMEL resonant
   layer.

   Companion prose: docs/perturbation_theory_compression.md and
   tex/nonresonant_perturbation.tex (the compressional-vs-gyrokinetics section).

   A magnetic perturbation has two physical (gauge-invariant) degrees of freedom:
   compression delta B_par = b.delta B = delta|B|, and bending delta B_perp (the radial
   reconnecting field in flux coordinates).  NEO-RT's drive is the compression; the
   bending is the separate radial/island channel.  Brizard-Hahm gyrokinetics carries
   BOTH (delta A_par for bending, delta B_par for compression); its compression coupling
   mu delta B_par IS NEO-RT's mu delta|B|.  KiLCA solves the bending/radial channel. *)

(* ============================================================
   D1.  Compression vs bending: the two parts of delta B
   ============================================================
   delta B = delta B_par b + delta B_perp, delta B_par = b.delta B (compression),
   delta B_perp = delta B - (b.delta B) b (bending, perpendicular to B). *)

With[{Bvec = {Bx, By, Bz}, dB = {dBx, dBy, dBz}},
  Module[{bb, dBperp},
   bb = Bvec/Sqrt[Bvec . Bvec];
   dBperp = dB - (bb . dB) bb;
   CheckEq["D1  bending part is perpendicular: (delta B - (b.delta B) b).b = 0",
     dBperp . bb, 0, Bvec . Bvec > 0]]];

(* ============================================================
   D2.  Only compression changes |B| to first order
   ============================================================
   delta|B| = b.delta B = delta B_par at first order; the bending delta B_perp changes
   |B| only at O(delta^2). *)

With[{Bvec = {Bx, By, Bz}, dB = {dBx, dBy, dBz}},
  CheckEq["D2  compression: d|B|/de at 0 = b.delta B (first-order modulus change)",
    D[Sqrt[(Bvec + ep dB) . (Bvec + ep dB)], ep] /. ep -> 0,
    (Bvec/Sqrt[Bvec . Bvec]) . dB, Bvec . Bvec > 0]];

With[{Bvec = {Bx, By, Bz}, aB = {ax, ay, az}},
  Module[{bb, dBperp},
   bb = Bvec/Sqrt[Bvec . Bvec];
   dBperp = aB - (bb . aB) bb;             (* purely perpendicular (bending) *)
   CheckEq["D2  bending changes |B| only at O(delta^2): d|B+e dB_perp|/de at 0 = 0",
     D[Sqrt[(Bvec + ep dBperp) . (Bvec + ep dBperp)], ep] /. ep -> 0,
     0, Bvec . Bvec > 0]]];

(* ============================================================
   D3.  A parallel vector potential makes compression only through b.curl b
   ============================================================
   b.curl(f b) = f (b.curl b), because b.(grad f x b) = 0.  So delta A_par = f
   contributes to compression only via the geometric/current factor b.curl b. *)

With[{xx = {x, y, z}},
  Module[{f, bb, lhs, rhs},
   f = ff[x, y, z];
   bb = {bvx[x, y, z], bvy[x, y, z], bvz[x, y, z]};
   lhs = bb . Curl[f bb, xx];
   rhs = f (bb . Curl[bb, xx]);
   CheckEq["D3  b.curl(f b) = f (b.curl b)  (parallel A -> compression only via b.curl b)",
     lhs, rhs]]];

(* ============================================================
   D4.  b.curl b = (b.curl B)/|B| = (4pi/c) j_par/|B|: parallel current carries it
   ============================================================
   The crux is (grad(1/|B|) x B).B = 0 (triple product), so the modulus gradient drops
   out of b.curl b and only the parallel current survives. *)

With[{xx = {x, y, z}},
  Module[{Bvec},
   Bvec = {BBx[x, y, z], BBy[x, y, z], BBz[x, y, z]};
   CheckEq["D4  (grad(1/|B|) x B).B = 0  =>  b.curl b = (b.curl B)/|B| = (4pi/c) j_par/|B|",
     (Cross[Grad[1/Sqrt[Bvec . Bvec], xx], Bvec]) . Bvec, 0, Bvec . Bvec > 0]]];

(* ============================================================
   D5.  The master split: two gauge routes to the same compression
   ============================================================
   delta B_par = b.curl(delta A) = delta A_par (b.curl b) + b.curl(delta A_perp).
   Field-aligned gauge (delta A = alpha B, delta A_perp = 0): compression rides
   b.curl b ~ j_par (NEO-RT/White).  Coulomb gauge (delta A_par dropped): compression is
   b.curl(delta A_perp) (gyrokinetics, the A_perp content carried as the scalar
   delta B_par).  Both equal the gauge-invariant b.delta B. *)

With[{xx = {x, y, z}},
  Module[{g, bb, aperp, dA, lhs, rhs},
   g = gg[x, y, z];
   bb = {bvx[x, y, z], bvy[x, y, z], bvz[x, y, z]};
   aperp = {apx[x, y, z], apy[x, y, z], apz[x, y, z]};
   dA = g bb + aperp;
   lhs = bb . Curl[dA, xx];
   rhs = g (bb . Curl[bb, xx]) + bb . Curl[aperp, xx];
   CheckEq["D5  b.curl(dA_par b + dA_perp) = dA_par(b.curl b) + b.curl(dA_perp)  (two routes)",
     lhs, rhs]]];

(* ============================================================
   E1.  Gyrokinetic compression coupling = NEO-RT mirror coupling
   ============================================================
   The gyrocentre Hamiltonian is delta H = e<delta phi> - (e/c)<v_par delta A_par>
   + <mu delta B_par> (Bessel gyro-averages).  The compression term mu delta B_par,
   with delta B_par = b.delta B = delta|B| (D2), is exactly NEO-RT's mirror mu delta|B|. *)

With[{Bvec = {Bx, By, Bz}, dB = {dBx, dBy, dBz}},
  CheckEq["E1  GK compression coupling mu (b.delta B) = NEO-RT mirror mu delta|B|",
    muu ((Bvec/Sqrt[Bvec . Bvec]) . dB),
    muu (D[Sqrt[(Bvec + ep dB) . (Bvec + ep dB)], ep] /. ep -> 0),
    Bvec . Bvec > 0]];

(* ============================================================
   E2.  NEO-RT's drive is compressional: mirror identification and weight
   ============================================================
   Both pieces of H1 = (m vpar^2 + mu B) delta B/B0 are driven by the compression
   delta B = delta|B|: the mirror mu B (delta B/B0) -> mu delta B, and the parallel
   coupling m vpar^2 (delta B/B0) from the v_par constraint.  The weight is (2 - eta B). *)

CheckEq["E2  mirror part mu B (delta B/B0) = mu delta B at the surface (compression coupling)",
  muu B0 (dBs/B0), muu dBs, B0 != 0];
CheckEq["E2  compressional drive weight m vpar^2 + mu B = (1/2) m v^2 (2 - eta B)",
  mA (vv^2 (1 - eta Bmod)) + (1/2) mA vv^2 eta Bmod,
  (1/2) mA vv^2 (2 - eta Bmod)];

(* ============================================================
   F1.  The bending/radial channel: KiLCA/KAMEL, the kernel at m = n q
   ============================================================
   The bending delta B_perp includes the covariant radial delta B^r, the reconnecting
   field.  It is the kernel of B.grad at the rational surface m = n q (no bounded gauge,
   no compression-only reduction), and it is nearly independent of the modulus channel
   for a near-vacuum perturbation since b.(grad alpha x B) = 0. *)

CheckEq["F1  radial/bending channel = kernel of B.grad at m = n q (KiLCA resonant layer)",
  I Bct (mm - nn qq) /. mm -> nn qq, 0];
CheckEq["F1  modulus and radial channels independent: b.(grad alpha x B) = 0",
  (Cross[{gax, gay, gaz}, {Bx, By, Bz}]) . {Bx, By, Bz}, 0];

Note["compressional",
  "NEO-RT's drive H1 = (m vpar^2 + mu B) delta|B|/B0 = (1/2) m v^2 (2 - eta B) delta|B|/B0 \
is driven entirely by the compression delta|B| = b.delta B = delta B_par (D2, E2).  The \
bending delta B_perp does not change |B| at first order (D2); in flux coordinates its \
covariant radial component delta B^r is the resonant/island channel, excluded from the \
delta|B|-only Hamiltonian (F1).  So NEO-RT is the compressional, non-resonant channel."];

Note["gyrokinetics-contrast",
  "Brizard-Hahm gyrokinetics carries three field variables, delta phi, delta A_par, \
delta B_par, and the gyrocentre Hamiltonian delta H = e<delta phi> - (e/c)<v_par \
delta A_par> + <mu delta B_par>.  The compression coupling mu delta B_par IS NEO-RT's \
mirror mu delta|B| (E1); the bending coupling (e/c) v_par delta A_par is the channel \
NEO-RT gauges away off resonance (watertight B1, B2).  Differences: gyrokinetics keeps \
both channels self-consistently (gyrokinetic Poisson/Ampere), at k_perp rho ~ 1 (FLR \
resummed to all orders), nonlinear, in LOCAL (X, v_par, mu) variables; NEO-RT uses only \
the compression, at k_perp rho << 1 (FLR an O(rho*^2) drop), quasilinear, in GLOBAL \
action-angle (J_g, J_b, p_phi) with the bounce/precession resonances and neoclassical \
collision regimes.  Same Littlejohn/Cary-Brizard guiding-centre parent and the same \
first-order compression coupling; different second step and regime."];

Note["kilca-contrast",
  "KiLCA / KAMEL is the bending/radial channel NEO-RT excludes: it solves the linearized \
Vlasov-Maxwell boundary-value problem in a cylinder for one resonant harmonic (m, n), \
the reconnecting radial field delta B^r, with the collisional -i nu denominator \
regularizing the singular layer at q = m/n (the kernel of B.grad, F1).  It produces the \
shielding current, the island width, and field penetration: the resonant-layer physics \
that a compressional delta|B|-only Hamiltonian cannot.  NEO-RT (compression, \
non-resonant, global) and KiLCA (bending, resonant, layer) are the two channels of one \
perturbation, nearly independent for a near-vacuum external field (F1); the seam is the \
torque pipeline."];
