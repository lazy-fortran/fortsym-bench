(* Reduced Cianciosa-type internal helical state with a nearly axisymmetric
   boundary. This script pins the geometry needed before constructing a
   production mhd1d/VMEC scan. It does NOT model the V3FIT reconstruction.

   PASS-checked statements:
   (1) for the script-42 helical equilibrium with
       H(psi) = H0 - a psi + O(psi^2), the regular-axis expansion gives
       iota_axis = -R0 a/2. Thus the old a=+0.08, R0=20 fixture lies on
       iota_axis=-0.8, while the adopted (1,-1), iota=+1 orientation needs
       a=-2/R0;
   (2) an m=1 flux harmonic displaces a surface by
       Delta(r) = -psi1(r)/psi0'(r), with the finite magnetic-axis limit
       Delta_axis = -d1/(2 c2) for psi0=c2 r^2+..., psi1=d1 r+...;
   (3) the regular solution J1(lambda r) of the cylindrical m=1 equation
       has a non-trivial internal state with an exactly axisymmetric boundary
       when lambda a_edge is a zero of J1;
   (4) just off that eigenvalue, a tiny prescribed edge displacement has an
       internal/edge amplification a_edge lambda/[2 J1(lambda a_edge)], and
       a regular point with amplification 50 exists. This is the reduced
       analogue of Cianciosa et al.'s core displacement about 50 times the
       applied edge deformation; it is a target/gate, not a fitted result. *)

Get[FileNameJoin[{DirectoryName[$InputFileName], "checklib.wl"}]];

ClearAll[r, u, k, R0, H0, aa, bb, psi0, psi1, c2, d1, lam, aedge];
$Assumptions = r > 0 && R0 > 0 && H0 > 0 && aedge > 0 &&
  Element[{k, aa, bb, c2, d1, lam}, Reals];

(* ==== 1. Regular-axis transform and the orientation pin ==== *)

(* Script 42 mean equation:
     psi0'' + psi0' (1-k^2 r^2)/(r (1+k^2 r^2)) + g S = 0,
   S = H (2k + g H')/g^2, g=1+k^2r^2. At the axis,
   psi0=c2 r^2+..., H(0)=H0, H'(0)=-a, so
     4 c2 + H0 (2k-a) = 0.
   Insert this into Btheta=-(psi0'+krH)/g and Bz=(H-kr psi0')/g. *)
c2Rule = c2 -> -H0 (2 k - aa)/4;
bthetaAxisCoeff = Simplify[-(2 c2 + k H0) /. c2Rule];
bzAxis = H0;
iotaAxis = Simplify[R0 bthetaAxisCoeff/bzAxis];

check["regular-axis expansion gives iota_axis = -R0 a/2",
  Simplify[iotaAxis + R0 aa/2] === 0];
check["old fixture a=+0.08, R0=20 has iota_axis=-0.8",
  Chop[(iotaAxis /. {aa -> 0.08, R0 -> 20.0}) + 0.8] == 0];
check["adopted (1,-1) resonance iota=+1 requires a=-2/R0",
  Simplify[iotaAxis /. aa -> -2/R0] === 1];

qTarget = 1.04;
aTarget = -2/(20 qTarget);
check["q_axis=1.04 orientation seed has negative a and positive iota",
  aTarget < 0 && Abs[(iotaAxis /. {aa -> aTarget, R0 -> 20.}) -
      1/qTarget] < 10^-14];

(* ==== 2. Flux-harmonic displacement ==== *)

(* At fixed flux label, psi0(r+Delta cos u)+psi1(r) cos u=psi0(r)
   gives Delta=-psi1/psi0' to first order. For regular m=1 behavior,
   psi0=c2 r^2+O(r^4), psi1=d1 r+O(r^3), the axis limit is finite. *)
deltaSeries = Simplify[-(d1 r + O[r]^3)/(2 c2 r + O[r]^3)];
deltaAxis = Block[{$Assumptions = c2 != 0},
  Limit[Normal[deltaSeries], r -> 0]];
check["regular m=1 magnetic-axis displacement is -d1/(2 c2)",
  Simplify[deltaAxis + d1/(2 c2)] === 0];

rigidPsi1 = -del0 D[c2 r^2, r];
check["rigid translation psi1=-Delta psi0' returns constant Delta",
  Simplify[-rigidPsi1/D[c2 r^2, r]] === del0];

(* ==== 3. Internal m=1 eigenstate with an axisymmetric boundary ==== *)

(* The canonical cylindrical m=1 radial equation is the constant-coefficient
   member of the script-42 harmonic operator. Its regular solution is J1.
   A Dirichlet boundary selects the zeros of J1 and leaves a finite internal
   state with no boundary corrugation. *)
y[r_] := BesselJ[1, lam r];
m1Residual = FullSimplify[D[y[r], {r, 2}] + D[y[r], r]/r +
    (lam^2 - 1/r^2) y[r]];
check["J1(lambda r) solves the regular cylindrical m=1 equation",
  m1Residual === 0];

j11 = BesselJZero[1, 1];
check["first m=1 eigenstate is nontrivial internally and zero at the edge",
  Abs[BesselJ[1, j11]] < 10^-14 && Abs[BesselJ[1, j11/2]] > 0.1];

(* ==== 4. Near-eigenvalue core/edge amplification ==== *)

(* Normalize psi1 so psi1(a_edge)=epsEdge. With psi0=c2 r^2, the
   magnetic-axis and edge displacements give
     |Delta_axis/Delta_edge| = |a_edge lambda/(2 J1(lambda a_edge))|.
   Work at a_edge=1 below the first zero, where all quantities are real and
   positive. *)
amp[xx_?NumericQ] := xx/(2 BesselJ[1, xx]);
lambda50 = lam /. FindRoot[lam/(2 BesselJ[1, lam]) == 50,
    {lam, 0.98 N[j11]}];
Print["    first J1 zero = ", N[j11, 10],
  ", lambda for amplification 50 = ", N[lambda50, 10]];
check["near-eigenvalue prescribed-edge response amplifies the core by 50",
  0 < lambda50 < j11 && Abs[amp[lambda50] - 50] < 10^-9];
check["amplification diverges as the exact internal eigenstate is approached",
  Block[{$Assumptions = True},
    Limit[lam/(2 BesselJ[1, lam]), lam -> j11,
      Direction -> "FromBelow"] === Infinity]];

reportAndExit[];
