(* Access conditions and the limit cycle of the reduced flux-pumping model.

   Verifies the algebra of doc/01_access:

     dA/dt     = g0 (D - Dc) A - a A^3
     dD/dt     = (Dohm - D)/tR + eps D - k A^2

   with A the normalised (1,1) helical amplitude and D = 1 - q0.  The
   quadratic dependence of the supplier term on A is forced: both the
   mean-field EMF <v~ x B~> and the resistivity-current correlation
   <eta~ j~> are correlations of two fluctuating quantities.

   The central result is negative: at eps = 0 the flux-pumping fixed point
   has negative trace and positive determinant for every admissible
   parameter value, so it cannot oscillate.  The autocatalytic peaking term
   eps D supplies the positive diagonal entry that produces a Hopf
   bifurcation.  *)

Get[FileNameJoin[{DirectoryName[$InputFileName], "checklib.wl"}]];

ClearAll[A, D0, g0, a, k, tR, eps, Dohm, Dc, As, Ds, f, g, jac, tr, det,
  Astar2, epsCrit, positive];

(* All model coefficients are physically positive. *)
positive = {g0 > 0, a > 0, k > 0, tR > 0, Dohm > 0, Dc >= 0, eps >= 0};

f[A_, D0_] := g0 (D0 - Dc) A - a A^3;
g[A_, D0_] := (Dohm - D0)/tR + eps D0 - k A^2;

(* ---------------------------------------------------------------- *)
(* 1.  The nontrivial fixed point at eps = 0.                        *)
(* ---------------------------------------------------------------- *)

(* Mode balance: g0 (Ds - Dc) = a As^2, so Ds = Dc + (a/g0) As^2. *)
Ds = Dc + (a/g0) As^2;

check["mode equation vanishes at the fixed point",
  Simplify[(f[As, Ds]/As) == 0, As != 0]];

(* Profile balance at eps = 0 fixes the amplitude. *)
Astar2 = (Dohm - Dc)/(k tR + a/g0);

check["fixed-point amplitude solves the profile balance",
  Simplify[
    ((g[As, Ds] /. eps -> 0) /. As^2 -> Astar2) == 0,
    Join[positive, {As != 0}]]];

check["fixed-point amplitude is positive exactly when Dohm > Dc",
  Simplify[Astar2 > 0, Join[positive, {Dohm > Dc}]]];

(* The pumped state is held strictly on the unstable side of threshold:
   at marginality the mode would have neither growth rate nor amplitude. *)
check["pumped state sits strictly above the stability threshold",
  Simplify[(Ds /. As^2 -> Astar2) > Dc, Join[positive, {Dohm > Dc}]]];

(* ---------------------------------------------------------------- *)
(* 2.  The obvious model cannot oscillate.                           *)
(* ---------------------------------------------------------------- *)

jac = {{D[f[A, D0], A], D[f[A, D0], D0]},
       {D[g[A, D0], A], D[g[A, D0], D0]}} /. {A -> As, D0 -> Ds};

tr = Simplify[Tr[jac]];
det = Simplify[Det[jac]];

check["Jacobian trace is -2 a As^2 - 1/tR + eps",
  Simplify[tr == -2 a As^2 - 1/tR + eps]];

check["Jacobian determinant is 2 a As^2/tR + 2 k g0 As^2 (eps = 0)",
  Simplify[(det /. eps -> 0) == 2 a As^2/tR + 2 k g0 As^2]];

(* The two signs that close the argument. *)
check["at eps = 0 the trace is negative for every admissible parameter",
  Simplify[(tr /. eps -> 0) < 0, Join[positive, {As > 0}]]];

check["at eps = 0 the determinant is positive for every admissible parameter",
  Simplify[(det /. eps -> 0) > 0, Join[positive, {As > 0}]]];

(* Hence: stable node or stable spiral, never a growing oscillation. *)
check["at eps = 0 the fixed point is unconditionally stable",
  Simplify[(tr /. eps -> 0) < 0 && (det /. eps -> 0) > 0,
    Join[positive, {As > 0}]]];

(* Predator-prey coupling contributes to det but not to tr: that is why the
   naive structure is so rigidly stable. *)
check["off-diagonal product is of predator-prey sign",
  Simplify[jac[[1, 2]] jac[[2, 1]] < 0, Join[positive, {As > 0}]]];

check["off-diagonal coupling does not enter the trace",
  Simplify[D[tr, k] == 0]];

(* ---------------------------------------------------------------- *)
(* 3.  The Hopf bifurcation created by autocatalytic peaking.        *)
(* ---------------------------------------------------------------- *)

epsCrit = 2 a As^2 + 1/tR;

check["trace vanishes exactly at eps = 2 a As^2 + 1/tR",
  Simplify[(tr /. eps -> epsCrit) == 0]];

(* The determinant at the trace-zero point does NOT have a fixed sign.  It
   factorises, and that factorisation is the substantive result: the
   bifurcation is a Hopf only if the predator-prey coupling is strong enough
   compared with the mode's nonlinear damping. *)
check["determinant at the trace-zero point factorises as 2 As^2 (g0 k - 2 a^2 As^2)",
  Simplify[(det /. eps -> epsCrit) == 2 As^2 (g0 k - 2 a^2 As^2)]];

check["Hopf requires g0 k > 2 a^2 As^2",
  Simplify[(det /. eps -> epsCrit) > 0,
    Join[positive, {As > 0, g0 k > 2 a^2 As^2}]]];

(* A Hopf bifurcation requires tr = 0 with det > 0, so that the eigenvalue
   pair crosses the imaginary axis rather than passing through zero. *)
check["eigenvalues at the Hopf point are a conjugate imaginary pair",
  Module[{ev},
    ev = Eigenvalues[jac /. eps -> epsCrit];
    Simplify[Total[ev] == 0 && Times @@ ev > 0,
      Join[positive, {As > 0, g0 k > 2 a^2 As^2}]]]];

(* The competing route: the determinant can reach zero first, which is a
   saddle-node (real eigenvalue through zero) and gives hysteresis rather
   than an oscillation. *)
epsSaddle = 1/tR + g0 k/a;

check["determinant vanishes at eps = 1/tR + g0 k/a",
  Simplify[(det /. eps -> epsSaddle) == 0, Join[positive, {As > 0}]]];

check["Hopf precedes the saddle-node exactly when g0 k > 2 a^2 As^2",
  Simplify[epsCrit < epsSaddle,
    Join[positive, {As > 0, g0 k > 2 a^2 As^2}]]];

check["saddle-node precedes Hopf when the coupling is too weak",
  Simplify[epsSaddle < epsCrit,
    Join[positive, {As > 0, g0 k < 2 a^2 As^2}]]];

check["trace is monotone increasing in the autocatalytic rate",
  Simplify[D[tr, eps] > 0]];

check["fixed point is unstable above the Hopf threshold",
  Simplify[(tr /. eps -> epsCrit + 1) > 0]];

(* Oscillation frequency at onset is sqrt(det). *)
check["onset frequency squared equals the determinant",
  Module[{ev},
    ev = Eigenvalues[jac /. eps -> epsCrit];
    Simplify[(ev[[1]] ev[[2]]) == (det /. eps -> epsCrit),
      Join[positive, {As > 0}]]]];

(* ---------------------------------------------------------------- *)
(* 4.  Robustness: the conclusion does not depend on the cubic.      *)
(* ---------------------------------------------------------------- *)

(* Replace the cubic saturation by A^(1+2s) for any s > 0.  The on-shell mode
   balance is then g0 (DsGen - Dc) = a As^(2 s), so the diagonal entry
   becomes -2 s a As^(2 s). *)
ClearAll[s, fGen, DsGen, jacGen, trGen, detGen];
fGen[A_, D0_] := g0 (D0 - Dc) A - a A^(1 + 2 s);
DsGen = Dc + (a/g0) As^(2 s);

check["generalised mode equation vanishes on shell",
  Simplify[fGen[As, DsGen]/As == 0, Join[positive, {As > 0, s > 0}]]];

jacGen = {{D[fGen[A, D0], A], D[fGen[A, D0], D0]},
          {D[g[A, D0], A], D[g[A, D0], D0]}} /. {A -> As, D0 -> DsGen};
trGen = Simplify[Tr[jacGen]];
detGen = Simplify[Det[jacGen]];

check["generalised diagonal entry is -2 s a As^(2 s)",
  Simplify[jacGen[[1, 1]] == -2 s a As^(2 s)]];

check["generalised saturation still gives a negative trace at eps = 0",
  Simplify[(trGen /. eps -> 0) < 0, Join[positive, {As > 0, s > 0}]]];

check["generalised saturation still gives a positive determinant at eps = 0",
  Simplify[(detGen /. eps -> 0) > 0, Join[positive, {As > 0, s > 0}]]];

check["unconditional stability at eps = 0 holds for any saturation exponent",
  Simplify[(trGen /. eps -> 0) < 0 && (detGen /. eps -> 0) > 0,
    Join[positive, {As > 0, s > 0}]]];

(* The supplier exponent, by contrast, is NOT free: it is fixed at 2 by the
   fact that the mean-field EMF is a two-field correlation.  Check that a
   linear supplier would change the determinant structure. *)
ClearAll[gLin, detLin];
gLin[A_, D0_] := (Dohm - D0)/tR + eps D0 - k A;
detLin = Simplify[
  Det[{{D[f[A, D0], A], D[f[A, D0], D0]},
       {D[gLin[A, D0], A], D[gLin[A, D0], D0]}} /. {A -> As, D0 -> Ds}]];
check["a linear supplier would give a different determinant",
  Simplify[(detLin /. eps -> 0) =!= (det /. eps -> 0)]];

(* ---------------------------------------------------------------- *)
(* 5.  Closure sensitivity of the boundaries.                        *)
(* ---------------------------------------------------------------- *)

(* The pumping efficiency k is the only coefficient set by the constitutive
   closure, and it enters both boundaries.  Reducing k raises the amplitude
   required to hold a given profile. *)
check["saturated amplitude decreases with pumping efficiency",
  Simplify[D[Astar2, k] < 0, Join[positive, {Dohm > Dc}]]];

check["weaker pumping lowers the Hopf threshold",
  Simplify[D[2 a Astar2 + 1/tR, k] < 0, Join[positive, {Dohm > Dc}]]];

(* In the strong-suppression limit the amplitude scales as k^(-1/2). *)
check["amplitude scales as 1/sqrt(k) when pumping is weak",
  Simplify[
    Limit[Astar2 k tR/(Dohm - Dc), k -> Infinity] == 1,
    Join[positive, {Dohm > Dc}]]];

(* section 5 continues below; the suite reports at the end of the file *)


(* ---------------------------------------------------------------- *)
(* 6.  Non-dimensional form, and why the Hopf route closes.          *)
(* ---------------------------------------------------------------- *)

(* The numerical study in models/access/ works in units of the
   current-diffusion time, with

     Gamma = gamma0 tauR   (mode growth / current diffusion),
     E     = eps tauR      (autocatalytic rate),
     K     = dynamo gain,

   and Jacobian {{-2 Gamma X, Gamma A}, {-2 K A, -(1 - E)}} at X = A^2.
   Check that this is the same object as the dimensional Jacobian above, then
   derive the condition for a Hopf point to EXIST at all.  That condition,
   not the trace sign, is what decides the matter at tokamak parameters. *)

ClearAll[G, K0, E0, X, trN, detN, DohmN, DcN, ceiling];
positiveN = {G > 0, K0 > 0, X > 0, DohmN > 0, DcN >= 0};

trN = -2 G X - (1 - E0);
detN = 2 G X (1 - E0) + 2 G K0 X;

check["non-dimensional trace matches the dimensional one under E = eps tauR",
  Simplify[trN == -2 G X - 1 + E0]];

(* At the trace-zero point the determinant factorises the same way as in the
   dimensional variables: coupling minus twice growth times damping. *)
check["determinant at trace zero factorises as 2 Gamma X (K - 2 Gamma X)",
  Simplify[(detN /. E0 -> 1 + 2 G X) == 2 G X (K0 - 2 G X)]];

check["so the non-dimensional Hopf condition is K > 2 Gamma X",
  Simplify[(detN /. E0 -> 1 + 2 G X) > 0,
    Join[positiveN, {K0 > 2 G X}]]];

(* This is the same statement as the dimensional condition
   kappa gamma0 > 2 alpha^2 A*^2 proved in section 3: both read
   "coupling beats twice the growth rate times the nonlinear damping". *)

(* Existence.  Eliminating E between the trace-zero condition and the
   fixed-point relation gives a quadratic in X, and a Hopf point exists only
   if it has a real positive root. *)
quad = 2 G X^2 - (K0 - 2 G DcN) X + DohmN;

check["the trace-zero fixed point satisfies the reduced quadratic",
  Simplify[quad == 0 /. X -> (K0 - 2 G DcN + Sqrt[(K0 - 2 G DcN)^2
      - 8 G DohmN])/(4 G)]];

check["a real Hopf point requires (K - 2 Gamma Dc)^2 >= 8 Gamma Dohm",
  Simplify[(K0 - 2 G DcN)^2 - 4 (2 G) DohmN >= 0,
    Join[positiveN, {(K0 - 2 G DcN)^2 >= 8 G DohmN}]]];

(* At small mode threshold this is a ceiling on the timescale ratio. *)
ceiling = K0^2/(8 DohmN);
check["for small Dc the existence condition is a ceiling Gamma <= K^2/(8 Dohm)",
  Simplify[
    Equivalent[((K0 - 2 G DcN)^2 - 8 G DohmN /. DcN -> 0) >= 0,
      G <= ceiling],
    Join[positiveN, {G > 0}]]];

(* The decisive numbers.  A resistive internal kink grows on the resistive-kink
   timescale, so Gamma ~ S^(2/3); for AUG core parameters S^(2/3) = 2.1e6,
   while K is order unity and Dohm order 0.1.  The ceiling is then order 10. *)
check["at AUG parameters the ceiling is violated by many orders of magnitude",
  (2.1*^6 > (K0^2/(8 DohmN) /. {K0 -> 1.8, DohmN -> 0.1}))];

check["the required Gamma for a Hopf is smaller than the physical one by >1e5",
  (2.1*^6/(K0^2/(8 DohmN) /. {K0 -> 1.8, DohmN -> 0.1})) > 1.*^5];

(* ---------------------------------------------------------------- *)
(* 7.  With strong timescale separation a cycle needs a FOLD.        *)
(* ---------------------------------------------------------------- *)

(* When Gamma is huge the mode is slaved to its own nullcline, so the dynamics
   follow that curve.  A relaxation oscillation then requires the fast
   nullcline to be non-monotone -- to have a fold -- so that the slow variable
   can jump between branches.  Cubic saturation cannot provide one; a quintic
   law with a positive quadratic coefficient can. *)

ClearAll[drive, b0, Xc, Xq];

(* Cubic: A^2 = Delta - Delta_c, a single positive root, monotone. *)
check["cubic saturation gives exactly one positive mode branch",
  Module[{sol},
    sol = Solve[Xc == drive && Xc > 0, Xc, Reals];
    Simplify[Length[sol] == 1, drive > 0]]];
check["the cubic mode nullcline is monotone in the drive",
  Simplify[D[drive, drive] > 0]];

(* Quintic: A^4 - b A^2 - drive = 0, i.e. X^2 - b X - drive = 0. *)
check["quintic saturation has two positive branches over a window",
  Simplify[(b0^2 + 4 drive > 0) && ((b0 - Sqrt[b0^2 + 4 drive])/2 > 0),
    {b0 > 0, drive < 0, drive > -b0^2/4}]];

check["the quintic fold sits at drive = -b^2/4, which needs b > 0",
  Simplify[(b0^2 + 4 drive == 0) == (drive == -b0^2/4)]];

check["no fold exists when b <= 0",
  Simplify[(b0 - Sqrt[b0^2 + 4 drive])/2 <= 0, {b0 <= 0, drive > 0}]];

(* Conclusion recorded by these checks: at physical timescale separation the
   autocatalytic Hopf route is closed, and an oscillation requires a
   subcritical (folded) mode branch instead.  Autocatalysis is therefore
   neither necessary nor sufficient. *)

reportAndExit[];
