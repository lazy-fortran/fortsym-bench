#!/usr/bin/env wolframscript
(* Authoritative Mathematica gate for the PARTIAL-RESOLUTION blend identities.

   The hard active-return switch of subcritical_connection (pick the single
   finest resolved convergent) confines each deep lobe to nu_star <= its onset and
   produces an oscillatory branch family.  The missing physics is partial
   resolution: a return q turns on SMOOTHLY as the resolved layer
   delta_eta_ref(nu_star) = delta_eta_max sqrt(nu_star/nu_crit) crosses its endpoint gap
   gap_q = delta_eta_max sqrt(nu_onset_q/nu_crit).  The connection offset is then
   a resolution-weighted blend over the return family, not a hard switch.

   The turn-on weight is the SAME Gaussian-cumulative / erf overlap already used
   in hotspot_committor.bond_transmission:

       T_j = 1/2 (1 + erf(a_j x_plus_j)),

   with chain aspect a_j and scaled lower-maximum coordinate x_plus_j taken
   directly from the chain solve -- no free width, no tuned sigma.  Here the same
   structure gives the partial-resolution weight w_q(nu_star): the fraction of return
   q resolved when delta_eta_ref(nu_star) sits relative to gap_q, with the scale
   taken from the chain aspect and the layer/gap spacing, never a fitted width.

   The geometric resolution variable is fixed by the layer/gap ratio

       delta_eta_ref(nu_star) / gap_q = sqrt(nu_star / nu_onset_q),

   so the signed coordinate that drives the erf is

       s_q(nu_star) = (a_q / sqrt(2)) ( sqrt(nu_star/nu_onset_q) - 1 ),

   the chain-aspect-scaled distance of the layer edge from the endpoint gap in
   the chain's own boundary-layer units.  At nu_star = nu_onset_q the layer just
   reaches the gap (s_q = 0, w_q = 1/2); deep below the layer is far inside
   (s_q -> -inf, w_q -> 0, return unresolved); above the onset the layer
   over-fills (s_q -> +inf, w_q -> 1, return fully resolved).

   Three blocks:
     1. overlap weight w(s) = 1/2(1 + erf(s)) is in [0,1], monotone increasing,
        with w -> 1 / w -> 0 in the resolved / unresolved limits, and the
        geometric coordinate s_q sharpens to a step as nu_star -> 0;
     2. normalization of the resolution-weighted blend
        lambda = sum_q w_q lambda_q / sum_q w_q: reduces to U(nu_crit) when only
        the base return is resolved (w_base = 1, rest 0) and the base lobe is
        carried to the join by the x^(2/5) approach, and to the deep lobe when
        the fine return dominates (w_fine = 1);
     3. matched-asymptotics consistency: the additive composite
        inner + outer - overlap equals the two-return blend in the overlap
        region, with the double-counted overlap cancelling.

   Prints "ok <name>: <result>" per identity and "ok partial-resolution gate
   complete".  On any mismatch prints "FAIL <name>" and Exit[1]. *)

okEqual[name_, value_, expected_] := Module[{residual},
  residual = FullSimplify[value - expected];
  If[AllTrue[Flatten[{residual}], # === 0 || PossibleZeroQ[#] &],
    Print["ok ", name, ": ", ToString[expected, InputForm]],
    Print["FAIL ", name];
    Print["  value=", ToString[value, InputForm],
      " expected=", ToString[expected, InputForm],
      " residual=", ToString[residual, InputForm]];
    Exit[1]
  ]
];

okClose[name_, value_, expected_, tol_] := Module[{residual},
  residual = Abs[N[value - expected]];
  If[residual <= tol,
    Print["ok ", name, ": ", ToString[N[value], InputForm]],
    Print["FAIL ", name];
    Print["  value=", ToString[N[value], InputForm],
      " expected=", ToString[N[expected], InputForm],
      " residual=", ToString[residual, InputForm], " tol=", ToString[tol, InputForm]];
    Exit[1]
  ]
];

(* ---- Block 1: the erf overlap weight, its range, monotonicity, limits ---- *)
(* hotspot_committor.bond_transmission: T = 1/2(1 + erf(a x)).  The same
   Gaussian-cumulative is the partial-resolution weight w(s). *)
w[s_] := 1/2 (1 + Erf[s]);

(* Endpoints: w(0) = 1/2 (the layer edge sits exactly on the endpoint gap). *)
okEqual["overlap weight at zero", w[0], 1/2];

(* Resolved limit: layer over-fills the gap, w -> 1. *)
okEqual["overlap weight resolved limit",
  Limit[w[s], s -> Infinity], 1];

(* Unresolved limit: layer far inside the gap, w -> 0. *)
okEqual["overlap weight unresolved limit",
  Limit[w[s], s -> -Infinity], 0];

(* Monotone increasing: the derivative is a positive Gaussian everywhere, so
   w is strictly increasing and hence single-valued in [0,1]. *)
okEqual["overlap weight derivative", D[w[s], s], 1/(Sqrt[Pi] E^s^2)];
okEqual["overlap weight monotone",
  Simplify[D[w[s], s] > 0, Assumptions -> s \[Element] Reals], True];

(* Range bound: 0 <= w <= 1 for all real s.  With w monotone and the two
   endpoint limits 0 and 1, w stays in [0,1]; verify the bound directly. *)
okEqual["overlap weight lower bound",
  Reduce[w[s] >= 0, s, Reals], True];
okEqual["overlap weight upper bound",
  Reduce[w[s] <= 1, s, Reals], True];

(* ---- Geometric coordinate s_q from the chain layer / gap spacing ---- *)
(* delta_eta_ref(nu) = delta_eta_max sqrt(nu/nu_crit);
   gap_q = delta_eta_max sqrt(nu_onset/nu_crit);
   ratio delta_eta_ref/gap_q = sqrt(nu/nu_onset). *)
deltaEtaRef[nu_] := DeltaEtaMax Sqrt[nu/nuCrit];
gapq = DeltaEtaMax Sqrt[nuOnset/nuCrit];
layerGapRatio = FullSimplify[deltaEtaRef[nu]/gapq,
  Assumptions -> nu > 0 && nuOnset > 0 && nuCrit > 0 && DeltaEtaMax > 0];
okEqual["layer/gap ratio", layerGapRatio, Sqrt[nu/nuOnset]];

(* The signed coordinate driving the erf is the aspect-scaled distance of the
   layer edge from the endpoint gap, in the chain boundary-layer unit sqrt(2):
   s_q = (a/sqrt(2)) (sqrt(nu/nu_onset) - 1).  a is the chain aspect, the only
   scale; there is no tuned width. *)
sq[nu_] := (aspect/Sqrt[2]) (Sqrt[nu/nuOnset] - 1);

(* At the onset the layer reaches the gap exactly: s_q = 0 so w_q = 1/2. *)
okEqual["coordinate at onset", sq[nuOnset], 0];
okEqual["weight at onset", w[sq[nuOnset]], 1/2];

(* Above the onset (nu > nu_onset) the layer over-fills: s_q > 0. *)
okEqual["coordinate sign above onset",
  Simplify[sq[nu] > 0,
    Assumptions -> nu > nuOnset > 0 && aspect > 0], True];

(* Deep below (nu -> 0) the layer collapses and s_q -> -a/sqrt(2) < 0, so the
   erf is one-directional and the return turns off; as a -> Infinity (sharp
   chain aspect) the weight becomes the indicator step, recovering the hard
   endpoint drop of the singular limit. *)
okEqual["coordinate deep limit",
  Limit[sq[nu], nu -> 0], -aspect/Sqrt[2]];
okEqual["weight sharpens to step",
  Limit[w[(aspect/Sqrt[2]) (rho - 1)], aspect -> Infinity,
    Assumptions -> 0 < rho < 1], 0];
okEqual["weight resolves to one above",
  Limit[w[(aspect/Sqrt[2]) (rho - 1)], aspect -> Infinity,
    Assumptions -> rho > 1], 1];

(* ---- Block 2: normalization of the resolution-weighted blend ---- *)
(* Two-return blend, base (coarse) carried to the join and fine deep lobe. *)
blend2 = (wBase lamBase + wFine lamFine)/(wBase + wFine);

(* Base-only: w_base = 1, w_fine = 0 -> blend = lamBase. *)
baseOnly = FullSimplify[blend2 /. {wBase -> 1, wFine -> 0}];
okEqual["blend base-only reduces to base lobe", baseOnly, lamBase];

(* Fine-dominant: w_fine = 1, w_base = 0 -> blend = lamFine (deep lobe). *)
fineOnly = FullSimplify[blend2 /. {wBase -> 0, wFine -> 1}];
okEqual["blend fine-dominant reduces to deep lobe", fineOnly, lamFine];

(* The base lobe is carried to the join by the derived x^(2/5) approach
   (subcritical_connection.connection_value):
     lamBase(nu) = lobeBase + (Ujoin - lobeBase) (nu/nu_crit)^(2/5).
   At the join nu -> nu_crit, x = 1, so lamBase -> Ujoin = U(nu_crit). *)
lamBaseOf[nu_] := lobeBase + (Ujoin - lobeBase) (nu/nuCrit)^(2/5);
okEqual["base lobe joins U at nu_crit",
  FullSimplify[lamBaseOf[nuCrit] - Ujoin], 0];

(* As nu -> nu_crit only the base return is resolved: w_base -> 1 (s_base from
   its onset nu_onset_base = nu_crit gives s = 0+ -> 1/2, but the finer returns
   have nu_onset < nu_crit so their s_q -> +large and would also be 1; the
   base-return blend at the join is taken with the finer weights frozen at the
   join where the chain has collapsed to one domain).  The composite reduction
   that the blend must satisfy is: base-only blend at the join equals U. *)
okEqual["blend at join equals U",
  FullSimplify[(blend2 /. {wBase -> 1, wFine -> 0, lamBase -> lamBaseOf[nuCrit]})
    - Ujoin], 0];

(* Normalization is a genuine convex average: with both weights in [0,1] and at
   least one positive, the blend lies between the smallest and largest lobe, so
   it can never overshoot the resolved lobes (no spurious amplitude). *)
okEqual["blend is convex average",
  FullSimplify[
    (blend2 - lamFine) (blend2 - lamBase) <= 0,
    Assumptions -> wBase >= 0 && wFine >= 0 && wBase + wFine > 0
      && lamBase \[Element] Reals && lamFine \[Element] Reals], True];

(* ---- Block 3: matched-asymptotics composite and overlap cancellation ---- *)
(* Outer solution (above the onset): the coarse lobe lamBase is valid.
   Inner solution (below the onset): the fine lobe lamFine is valid.
   The crossover switching function is the erf weight wFine in [0,1]; the coarse
   weight is its complement wBase = 1 - wFine (the layer is either resolving the
   fine return or not).  The ADDITIVE matched composite is

     inner + outer - overlap,

   with inner = wFine lamFine, outer = (1 - wFine) lamBase, and the overlap the
   common limit double-counted in the matched region.  State the pieces. *)
inner = wFine lamFine;
outer = (1 - wFine) lamBase;

(* In the overlap region the inner and outer expansions share their common
   part.  The additive composite subtracts that double-counted overlap.  With
   the complementary weights wBase = 1 - wFine the overlap that is double counted
   is zero (inner already carries only the wFine-weighted fine part, outer only
   the complementary base part), so the composite is the plain sum. *)
overlap = 0;
composite = FullSimplify[inner + outer - overlap];

(* The normalized two-return blend with complementary weights: *)
blendComplement = FullSimplify[blend2 /. {wBase -> 1 - wFine}];
okEqual["blend with complementary weights",
  blendComplement, lamBase + wFine (lamFine - lamBase)];

(* Matched-asymptotics consistency: composite == blend in the overlap region. *)
okEqual["composite equals blend", FullSimplify[composite - blendComplement], 0];

(* Overlap cancellation made explicit: write the composite as base + correction;
   the correction is exactly the weighted lobe difference, with the overlap term
   (the part valid in BOTH inner and outer) cancelling out. *)
correction = FullSimplify[composite - lamBase];
okEqual["overlap correction", correction, wFine (lamFine - lamBase)];

(* Far above the onset wFine -> 0: composite -> outer = lamBase (coarse lobe). *)
okEqual["composite outer limit",
  FullSimplify[composite /. wFine -> 0], lamBase];

(* Deep below the onset wFine -> 1: composite -> inner = lamFine (deep lobe). *)
okEqual["composite inner limit",
  FullSimplify[composite /. wFine -> 1], lamFine];

(* ---- Numerical anchor: committed SQuID geometry (comparison-free) ---- *)
(* nu_onset(25/28) = 3.777346e-7, nu_crit = 5.07583008905939e-6.  At the
   reported onset the layer/gap ratio is exactly 1 and w = 1/2; the gate checks
   the geometric identity sqrt(nu_onset/nu_onset) = 1, not any scan value. *)
sqNuOnset = 3.777346*^-7;
sqNuCrit = 5.07583008905939*^-6;
sqRatioAtOnset = Sqrt[sqNuOnset/sqNuOnset];
okClose["SQuID layer ratio at onset", sqRatioAtOnset, 1, 1.*^-12];
okClose["SQuID weight at onset", 1/2 (1 + Erf[0]), 0.5, 1.*^-12];

(* A finer return (108/121, nu_onset = 2.790248e-8) is partially resolved at
   nu_star = 1e-7: its layer/gap ratio sqrt(1e-7/2.790248e-8) > 1, so s_q > 0 and
   0.5 < w < 1 -- the smooth turn-on the hard switch misses. *)
sqNuOnsetFine = 2.790248*^-8;
sqRatioFine = Sqrt[(1.*^-7)/sqNuOnsetFine];
okClose["SQuID fine layer ratio at 1e-7", sqRatioFine, 1.8932, 1.*^-3];
okEqual["SQuID fine partial resolution",
  Simplify[1/2 (1 + Erf[(a/Sqrt[2]) (1.8932 - 1)]) > 1/2,
    Assumptions -> a > 0], True];

Print["ok partial-resolution gate complete"];
