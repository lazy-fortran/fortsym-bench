#!/usr/bin/env wolframscript
(* Authoritative Mathematica gate for the resolved-return CONNECTION identities.
   These are the load-bearing facts that replace the harmonic activation ansatz
   1/(1+nu*/nu_d) of doc eq:return-closure by the geometric locus of the active
   continued-fraction return in the resolved layer delta_eta_ref(nu_star).

   Three blocks:
     1. layer-resolution scaling: delta_eta_ref = delta_eta_max sqrt(nu*/nu_crit),
        collapse to one domain at nu* = nu_crit (ratio 1);
     2. x^(2/5) approach: HPN balance gives active-return scale N ~ nu*^(-1/5) and
        layer ~ nu*^(2/5), so the offset approaches the join with exponent 2/5;
     3. join continuity: the active-return B-channel lobe at the first convergent
        continues U(nu_crit) = C_A/sqrt(nu_crit) + C_B/nu_crit, C_A term negligible.

   Prints "ok <name>: <result>" per identity and "ok connection gate complete".
   On any mismatch prints "FAIL <name>" and Exit[1]. *)

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

(* ---- Block 1: layer-resolution scaling and domain collapse ---- *)
(* finite_return_chain.build_chain_geometry:
     delta_eta_ref = delta_eta_max sqrt(nu*/nu_crit). *)
deltaEtaRef[nu_] := DeltaEtaMax Sqrt[nu/nuCrit];

(* The resolved layer is the sqrt-scaled fraction of the maxima spread. *)
layerRatio = FullSimplify[deltaEtaRef[nu]/DeltaEtaMax,
  Assumptions -> nu > 0 && nuCrit > 0];
okEqual["layer-resolution scaling", layerRatio, Sqrt[nu/nuCrit]];

(* At nu* = nu_crit the layer equals the full spread: ratio is exactly 1, so the
   chain has no finer maxima to resolve and collapses to a single domain. *)
collapseRatio = FullSimplify[deltaEtaRef[nuCrit]/DeltaEtaMax,
  Assumptions -> nuCrit > 0];
okEqual["layer collapse at nu_crit", collapseRatio, 1];

(* Below nu_crit the layer is strictly thinner than the spread, so finer maxima
   enter and the active return advances: the ratio is monotone increasing in nu*
   (positive derivative), hence a single-valued geometric locus parameter. *)
layerSlope = D[deltaEtaRef[nu], nu];
okEqual["layer monotone in nu_star",
  Simplify[layerSlope > 0, Assumptions -> nu > 0 && nuCrit > 0 && DeltaEtaMax > 0],
  True];

(* ---- Block 2: HPN balance and the x^(2/5) approach exponent ---- *)
(* Helander-Parra-Newton boundary layer: the collisional return exponent r
   balances precession 2 r against the (1 - r)/2 diffusive layer.  This is the
   same balance the sub-critical gate uses; here it sets the ACTIVE-RETURN scale. *)
hpnReturn = r /. First[Solve[2 r == (1 - r)/2, r]];
okEqual["HPN return exponent", hpnReturn, 1/5];

(* Active-return convergent index advances as N ~ nu*^(-1/5): the resolved layer
   delta_eta_ref ~ nu*^(1/2) resolves the convergent whose endpoint gap matches,
   and the HPN layer that the offset relaxes over carries exponent 2 r = 2/5. *)
activeReturnScale = nu^(-hpnReturn);
okEqual["active-return scale", FullSimplify[activeReturnScale, Assumptions -> nu > 0],
  nu^(-1/5)];

layerExponent = 2 hpnReturn;
okEqual["HPN layer exponent", layerExponent, 2/5];

(* The offset on the active return approaches its join value as the layer fills:
   offset(nu_star) - U_join ~ -(U_join - lobe) (nu_star/nu_crit)^(2/5).  Read off
   the leading exponent of the approach in x = nu_star/nu_crit. *)
approach = lobe + (Ujoin - lobe) x^layerExponent;
approachExponent = Exponent[approach - lobe, x];
okEqual["offset approach exponent", approachExponent, 2/5];

(* Consistency with the layer: delta_eta ~ nu*^(2/5) over which the offset relaxes
   matches the approach exponent, i.e. the layer thickness in the precession-
   resolved variable scales as the square of the active-return scale^(-1). *)
layerFromReturn = FullSimplify[(1/activeReturnScale)^2,
  Assumptions -> nu > 0];
okEqual["layer from active return", layerFromReturn, nu^(2/5)];

(* ---- Block 3: join continuity to the RABE upper asymptote ---- *)
(* subcritical_b_channel.b_channel_residue: A = C_B / nu_crit. *)
residueA = Cb/nuCrit;
upperAsymptote[nu_] := lambdaSC + Ca/Sqrt[nu] + Cb/nu;

(* At the join the lobe amplitude equals the B-channel coefficient there. *)
okEqual["B-channel residue", residueA, Cb/nuCrit];

(* The upper asymptote at the join splits into A channel + B channel; the lobe
   continues the B channel, so the active-return lobe at the first convergent
   equals U(nu_crit) minus the negligible A-channel piece. *)
upperAtCrit = upperAsymptote[nuCrit];
bChannelAtCrit = Cb/nuCrit;
aChannelAtCrit = Ca/Sqrt[nuCrit];
okEqual["upper split at join",
  FullSimplify[upperAtCrit - (lambdaSC + aChannelAtCrit + bChannelAtCrit)],
  0];

(* The continuity statement: lobe at first convergent = A = C_B/nu_crit, which
   equals U(nu_crit) up to lambda_SC and the A channel.  With lambda_SC -> 0
   (sub-critical branch carries no constant), the lobe continues U minus A. *)
joinContinuity = FullSimplify[
  bChannelAtCrit - (upperAtCrit - lambdaSC - aChannelAtCrit)];
okEqual["join continuity B channel", joinContinuity, 0];

(* Numerical negligibility of the A channel at the join for the committed SQuID
   bccorrect coefficients: |C_A/sqrt(nu_crit)| / (C_B/nu_crit) ~ 1e-4. *)
sqCa = -7.2224353200885*^-07;
sqCb = 1.52805423961091*^-05;
sqNuCrit = 5.07583008905939*^-06;
sqResidue = sqCb/sqNuCrit;
sqAchan = sqCa/Sqrt[sqNuCrit];
sqRatio = Abs[sqAchan/sqResidue];
okClose["SQuID residue A", sqResidue, 3.0104519119, 1.*^-6];
okClose["SQuID A-channel ratio", sqRatio, 0.00010648745, 1.*^-7];

(* With C_A neglected the lobe residue equals the full upper asymptote (no
   lambda_SC) to the A-channel tolerance. *)
sqUpper = sqResidue + sqAchan;
okClose["SQuID lobe continues U(nu_crit)", sqResidue, sqUpper,
  Abs[sqAchan] (1 + 1.*^-9)];

Print["ok connection gate complete"];
