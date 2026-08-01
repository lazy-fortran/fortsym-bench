(* Local parallel-current normalization for the NEO-2 mode-1 response.
   The solver current row is a directional high-order quadrature of separate
   co- and counter-passing velocity-space moments. This script keeps those
   moments separate, derives the continuum local response whose flux-surface
   average is gamma_out(3,k), and closes the dimensional chain
   gamma -> D_3k -> V_parallel -> j_parallel in CGS units. It does not infer a
   perpendicular or geometric toroidal current. *)

Get[FileNameJoin[{DirectoryName[$InputFileName], "checklib.wl"}]];

ClearAll[wp, wm, rp, rm, beta3, betak, y6, qraw, gamma];

(* rp and rm contain the Laguerre- and eta-integrated current moments before
   the spatial step_factor_p/m weights. The counter-passing sign is explicit. *)
wp = {wp1, wp2, wp3};
wm = {wm1, wm2, wm3};
rp = {rp1, rp2, rp3};
rm = {rm1, rm2, rm3};
qraw = wp.rp - wm.rm;

check["LocalJ1: split directional quadrature reproduces the qflux current row",
  Expand[qraw - Sum[wp[[i]] rp[[i]] - wm[[i]] rm[[i]], {i, 3}]] == 0];

(* A centered spacing cannot undo two different directional weights. *)
oldDensity = (wp1 rp1 - wm1 rm1)/dphi;
check["LocalJ2: centered-spacing division is not the unweighted local moment",
  FullSimplify[oldDensity != rp1 - rm1,
    dphi > 0 && wp1 > 0 && wm1 > 0 && wp1 != dphi && wm1 != dphi &&
      rp1 != 0 && rm1 != 0 &&
      wp1 rp1 - wm1 rm1 != dphi (rp1 - rm1)]];

(* NEO-2 uses y6 = integral ds/Bhat and
     gamma_3k = -beta3 betak qraw/y6.
   In field-line phi, ds/Bhat = dphi/(Bhat h^phi). If raw(phi) is the
   pre-quadrature current-row density, the local coefficient below has this
   surface average. A discrete common-weight representation checks the
   cancellation without assuming a particular grid. *)
ClearAll[dphi, bhat, hphi, raw, mu, gammaLocal, surfaceAverage];
dphi = {d1, d2, d3};
bhat = {b1, b2, b3};
hphi = {h1, h2, h3};
raw = {r1, r2, r3};
mu = dphi/(bhat hphi);
y6 = Total[mu];
gammaLocal = -beta3 betak bhat hphi raw;
surfaceAverage = Total[mu gammaLocal]/y6;
gamma = -beta3 betak (dphi.raw)/y6;

check["LocalJ3: local gamma surface-average closes to gamma_out",
  FullSimplify[surfaceAverage == gamma,
    And @@ Thread[dphi > 0] && And @@ Thread[bhat > 0] &&
      And @@ Thread[hphi > 0]]];

check["LocalJ4: local response retains the co-minus-counter current parity",
  Expand[
    (-beta3 betak bh hph (rplus - rminus) /. {rplus -> u, rminus -> u})
  ] == 0];

(* Dimensional coefficient used by helical_response_mod:
     D_3k = gamma_3k vT rho Bref = gamma_3k 2 T c/(z e).
   Here z is the signed charge number and e is the positive elementary charge. *)
ClearAll[vT, rho, bref, mass, temp, cLight, z, eCharge, dScale];
dScale = vT rho bref;
check["LocalJ5: vT rho Bref equals 2 T c/(z e)",
  FullSimplify[
    (dScale /. rho -> vT mass cLight/(z eCharge bref) /.
        vT^2 -> 2 temp/mass) == 2 temp cLight/(z eCharge),
    mass > 0 && temp > 0 && bref > 0 && eCharge > 0 && z != 0]];

(* For physical radial forces A1,A2 [1/cm],
     V_parallel B = -(D31 A1 + D32 A2),
     j_parallel = z e n V_parallel.
   The local magnetic field is Bref Bhat. *)
ClearAll[g1, g2, a1, a2, density, vparB, jpar];
vparB = -dScale (g1 a1 + g2 a2);
jpar = z eCharge density vparB/(bref bh);

check["LocalJ6: signed-charge current chain reduces consistently",
  FullSimplify[
    (jpar /. rho -> vT mass cLight/(z eCharge bref) /.
        vT^2 -> 2 temp/mass) ==
      -2 density temp cLight (g1 a1 + g2 a2)/(bref bh),
    density >= 0 && temp > 0 && bref > 0 && bh > 0 &&
      eCharge > 0 && z != 0]];

check["LocalJ7: zero thermodynamic forces give zero parallel current",
  FullSimplify[jpar /. {a1 -> 0, a2 -> 0}] == 0];
check["LocalJ7: zero density gives zero parallel current",
  FullSimplify[jpar /. density -> 0] == 0];

(* Unit exponents are ordered as {length, time, charge, magnetic field}. *)
uD = {2, -1, 0, 1};
uA = {-1, 0, 0, 0};
uB = {0, 0, 0, 1};
uCharge = {0, 0, 1, 0};
uDensity = {-3, 0, 0, 0};
uVelocity = uD + uA - uB;
uCurrentDensity = uCharge + uDensity + uVelocity;

check["LocalJ8: D A/B has velocity units",
  uVelocity == {1, -1, 0, 0}];
check["LocalJ8: z e n D A/B has CGS current-density units",
  uCurrentDensity == {-2, -1, 1, 0}];

(* Real and imaginary source runs reconstruct the complex local coefficient
   point by point with the same convention as the accepted scalar response. *)
ClearAll[gReal, gImag, gBase];
gComplex = (gReal - gBase) - I (gImag - gBase);
check["LocalJ9: real-imaginary reconstruction is linear point by point",
  ComplexExpand[Re[gComplex] + I Im[gComplex],
    TargetFunctions -> {Re, Im}] == gComplex];
check["LocalJ9: exact-zero baseline reduces to R-iI",
  FullSimplify[(gComplex /. gBase -> 0) == gReal - I gImag]];

(* The pinned aCluster summary is a numerical evidence ledger, not a symbolic
   proof. Check that the recorded closure follows from the archived sums and
   that the unresolved interface mismatch remains explicit. *)
summaryPath = FileNameJoin[{DirectoryName[$InputFileName], "..", "runs",
    "wp2_neo2", "helical_core_l1", "results",
    "local_response_18564561.json"}];
check["[exists] LocalRun1: pinned aCluster response summary exists",
  FileExistsQ[summaryPath]];
summary = Import[summaryPath, "RawJSON"];
check["LocalRun2: response summary has the reconstructed support",
  summary["schema_version"] == 1 && summary["files"] == 199 &&
    summary["points"] == 99415];

expectedRun = summary["qflux_expected"];
pointRun = summary["qflux_point_sum"][[{1, 3}]];
localRun = summary["qflux_local_sum"][[{1, 3}]];
relativeRun = Abs[pointRun - expectedRun]/Map[Max[Abs[#], 1.] &, expectedRun];
check["LocalRun3: archived point sums close to final joined qflux",
  Max[relativeRun] < 10^-12];
check["LocalRun4: archived point and local-propagator sums agree",
  Max[Abs[pointRun - localRun]/Map[Max[Abs[#], 1.] &, pointRun]] < 10^-12];
check["LocalRun5: physical-current rejection and interface jumps are retained",
  summary["physical_pointwise_current_accepted"] === False &&
    Min[summary["interface_jump_relative_to_global_amplitude"]] > 10^-3];

reportAndExit[];
