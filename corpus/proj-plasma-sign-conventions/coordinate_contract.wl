(* Exact manufactured-coordinate identities.  These tests prove the algebra
   after the explicit physical and code-chart assumptions in case.json; they
   do not replace executable reconstruction of each native file. *)

ClearAll["Global`*"];

eR[ph_] := {Cos[ph], Sin[ph], 0};
ePhi[ph_] := {-Sin[ph], Cos[ph], 0};
eZ = {0, 0, 1};
xCyl[R_, ph_, Z_] := {R Cos[ph], R Sin[ph], Z};
vCart[vR_, vPhi_, vZ_, ph_] := vR eR[ph] + vPhi ePhi[ph] + vZ eZ;
rotZ[a_] := {{Cos[a], -Sin[a], 0}, {Sin[a], Cos[a], 0}, {0, 0, 1}};
sMat = {{s11, s12}, {s21, s22}};
kVec = {k1, k2};
omegaVec = {omega1, omega2};
torqueVec = {torque1, torque2};

tests = {
  VerificationTest[
    FullSimplify[Cross[eR[ph], ePhi[ph]], Element[ph, Reals]],
    eZ,
    TestID -> "laboratory-cylindrical-basis-is-right-handed"
  ],

  VerificationTest[
    FullSimplify[D[xCyl[R, ph, Z], ph],
      Assumptions -> Element[{R, ph, Z}, Reals]],
    R ePhi[ph],
    TestID -> "toroidal-coordinate-tangent-is-R-ephi"
  ],

  VerificationTest[
    FullSimplify[
      {vCart[vR, vPhi, vZ, ph].eR[ph],
       vCart[vR, vPhi, vZ, ph].ePhi[ph],
       vCart[vR, vPhi, vZ, ph].eZ},
      Assumptions -> Element[{vR, vPhi, vZ, ph}, Reals]
    ],
    {vR, vPhi, vZ},
    TestID -> "cartesian-cylindrical-vector-roundtrip"
  ],

  VerificationTest[
    FullSimplify[
      Cross[{0, 1/R, 0}, {psiR, 0, psiZ}]/(2 Pi) + {0, F/R, 0},
      Assumptions -> R != 0
    ],
    {psiZ/(2 Pi R), F/R, -psiR/(2 Pi R)},
    TestID -> "cocos11-flux-form-to-cylindrical-components"
  ],

  VerificationTest[
    FullSimplify[
      {-(-psiZ/(2 Pi))/R, -(-F/R), (-psiR/(2 Pi))/R},
      Assumptions -> R != 0
    ],
    {psiZ/(2 Pi R), F/R, -psiR/(2 Pi R)},
    TestID -> "complete-cocos2-to-cocos11-field-map-preserves-vector"
  ],

  VerificationTest[
    FullSimplify[
      xCyl[R, ph, Z] /. ph -> -phM,
      Assumptions -> Element[{R, phM, Z}, Reals]
    ],
    {R Cos[phM], -R Sin[phM], Z},
    TestID -> "clockwise-mars-angle-to-laboratory-cartesian-position"
  ],

  VerificationTest[
    FullSimplify[-D[xCyl[R, ph, Z], ph] /. ph -> phc,
      Assumptions -> Element[{R, phc, Z}, Reals]],
    -R ePhi[phc],
    TestID -> "clockwise-angle-tangent-opposes-laboratory-ephi"
  ],

  VerificationTest[
    FullSimplify[
      Cross[vCart[ER, EPhi, EZ, ph], vCart[BR, BPhi, BZ, ph]] -
        vCart[EPhi BZ - EZ BPhi, EZ BR - ER BZ, ER BPhi - EPhi BR, ph],
      Assumptions -> Element[{ER, EPhi, EZ, BR, BPhi, BZ, ph}, Reals]
    ],
    {0, 0, 0},
    TestID -> "exb-cross-product-is-one-cartesian-vector"
  ],

  VerificationTest[
    FullSimplify[
      Cross[xCyl[R, ph, Z], vCart[fR, fPhi, fZ, ph]].eZ,
      Assumptions -> Element[{R, ph, Z, fR, fPhi, fZ}, Reals]
    ],
    R fPhi,
    TestID -> "cartesian-force-moment-is-R-fphi"
  ],

  VerificationTest[
    FullSimplify[
      D[xCyl[R[t], ph[t], Z[t]], t].ePhi[ph[t]],
      Assumptions -> Element[{R[t], ph[t], Z[t]}, Reals]
    ],
    R[t] ph'[t],
    TestID -> "physical-toroidal-speed-is-R-times-angular-rate"
  ],

  VerificationTest[
    FullSimplify[
      {(-OmegaPhi) (-TPhi), (-n) (-OmegaPhi)},
      Assumptions -> Element[{OmegaPhi, TPhi, n}, Reals]
    ],
    {OmegaPhi TPhi, n OmegaPhi},
    TestID -> "angle-reversal-preserves-power-and-resonance-contraction"
  ],

  VerificationTest[
    {Inverse[Transpose[{{-1, 0}, {0, -1}}]].{m, -n},
     Inverse[Transpose[{{1, 0}, {0, -1}}]].{m, -n}},
    {{-m, n}, {m, n}},
    TestID -> "fourier-covector-transforms-by-inverse-transpose"
  ],

  VerificationTest[
    FullSimplify[
      (Inverse[Transpose[sMat]].kVec).(sMat.omegaVec),
      Assumptions -> Det[sMat] != 0
    ],
    kVec.omegaVec,
    TestID -> "general-coordinate-map-preserves-resonance-phase-rate"
  ],

  VerificationTest[
    FullSimplify[
      (Inverse[Transpose[sMat]].torqueVec).(sMat.omegaVec),
      Assumptions -> Det[sMat] != 0
    ],
    torqueVec.omegaVec,
    TestID -> "general-coordinate-map-preserves-mechanical-power"
  ],

  VerificationTest[
    FullSimplify[
      Re[(ar - I ai) Exp[-I chi]],
      Assumptions -> Element[{ar, ai, chi}, Reals]
    ],
    ar Cos[chi] - ai Sin[chi],
    TestID -> "full-fourier-phase-reversal-requires-coefficient-conjugation"
  ],

  VerificationTest[
    FullSimplify[
      Re[(ac - I as) Exp[I chi]],
      Assumptions -> Element[{ac, as, chi}, Reals]
    ],
    ac Cos[chi] + as Sin[chi],
    TestID -> "cosine-sine-pair-equals-complex-amplitude-ac-minus-i-as"
  ],

  VerificationTest[
    FullSimplify[
      {Cos[-chi], Sin[-chi], Conjugate[ac - I as]},
      Assumptions -> Element[{ac, as, chi}, Reals]
    ],
    {Cos[chi], -Sin[chi], ac + I as},
    TestID -> "kernel-reversal-keeps-cosine-flips-sine-and-conjugates-amplitude"
  ],

  VerificationTest[
    FullSimplify[
      Exp[I (m theta - ixn zeta)] /. ixn -> nn nfp
    ],
    Exp[I (m theta - nn nfp zeta)],
    TestID -> "vmec-and-booz-xform-packed-toroidal-mode-includes-nfp"
  ],

  VerificationTest[
    FullSimplify[
      Exp[I (m theta - nn nfp (zeta + 2 Pi/nfp))],
      Assumptions -> Element[nn, Integers] && nfp != 0
    ],
    Exp[I (m theta - nn nfp zeta)],
    TestID -> "packed-vmec-harmonic-repeats-after-one-field-period"
  ],

  VerificationTest[
    FullSimplify[
      rotZ[a].xCyl[R, zeta, Z],
      Assumptions -> Element[{R, zeta, Z, a}, Reals]
    ],
    xCyl[R, zeta + a, Z],
    TestID -> "field-period-cartesian-position-is-rotation-covariant"
  ],

  VerificationTest[
    FullSimplify[
      rotZ[a].vCart[BR, BPhi, BZ, zeta],
      Assumptions -> Element[{BR, BPhi, BZ, zeta, a}, Reals]
    ],
    vCart[BR, BPhi, BZ, zeta + a],
    TestID -> "field-period-cartesian-vector-is-rotation-covariant"
  ],

  VerificationTest[
    FullSimplify[
      Det[D[{rho^2, -orient thetaB/(2 Pi), orient zetaB/(2 Pi)},
        {{rho, thetaB, zetaB}}]],
      Assumptions -> orient^2 == 1
    ],
    -rho/(2 Pi^2),
    TestID -> "gliss-gvec-to-cas3d-coordinate-map-is-left-handed"
  ],

  VerificationTest[
    FullSimplify[
      Exp[2 Pi I (m thetaTurn - nn nfp (zetaTurn + 1/nfp))],
      Assumptions -> Element[nn, Integers] && nfp != 0
    ],
    Exp[2 Pi I (m thetaTurn - nn nfp zetaTurn)],
    TestID -> "gliss-cas3d-turn-coordinate-harmonic-repeats-after-one-period"
  ],

  VerificationTest[
    FullSimplify[
      {-nfp jac (-chiSlope/(nfp jac)),
       -jac (-phiSlope/jac)},
      Assumptions -> nfp jac != 0
    ],
    {chiSlope, phiSlope},
    TestID -> "gliss-contravariant-field-reconstructs-signed-flux-slopes"
  ],

  VerificationTest[
    FullSimplify[
      4 Pi^2 (nfp jac/(4 Pi^2)) - nfp jac
    ],
    0,
    TestID -> "gliss-terpsichore-bjac-preserves-full-volume-measure"
  ],

  VerificationTest[
    FullSimplify[
      {zetaV + p, thetaV + lambdaV + iota p, -p} /. p -> zetaB - zetaV
    ],
    {zetaB, thetaV + lambdaV + iota (zetaB - zetaV), zetaV - zetaB},
    TestID -> "booz-xform-pmn-is-minus-native-p"
  ],

  VerificationTest[
    FullSimplify[zetaB + pmn /. pmn -> zetaV - zetaB],
    zetaV,
    TestID -> "booz-xform-stored-pmn-recovers-physical-vmec-azimuth-by-plus"
  ],

  VerificationTest[
    FullSimplify[
      mB thetaB - (nredB nfpB) (zetaB + 2 Pi/nfpB) -
        (mB thetaB - (nredB nfpB) zetaB),
      Assumptions -> Element[nredB, Integers] && nfpB != 0
    ],
    -2 Pi nredB,
    TestID -> "booz-xform-packed-n-repeats-after-one-field-period"
  ],

  VerificationTest[
    FullSimplify[
      (bmagB^2/(gB + iotaB iB)) (gB + iotaB iB),
      Assumptions -> gB + iotaB iB != 0
    ],
    bmagB^2,
    TestID -> "booz-xform-covariant-and-contravariant-field-contract"
  ],

  VerificationTest[
    FullSimplify[
      (-phiEdgeB/(2 Pi)) ((gB + iotaB iB)/bmagB^2)
    ],
    -phiEdgeB (gB + iotaB iB)/(2 Pi bmagB^2),
    TestID -> "booz-xform-full-toroidal-flux-fixes-normalized-s-jacobian-sign"
  ],

  VerificationTest[
    FullSimplify[
      (-(-phiEdgeB)/(2 Pi)) ((-gB + iotaB (-iB))/bmagB^2) -
        (-phiEdgeB/(2 Pi)) ((gB + iotaB iB)/bmagB^2)
    ],
    0,
    TestID -> "booz-xform-whole-field-reversal-preserves-normalized-chart-jacobian"
  ],

  VerificationTest[
    FullSimplify[
      {-aZetaPrime/jOriented, aThetaPrime/jOriented} /.
        aThetaPrime -> -phiPrime
    ],
    {-aZetaPrime/jOriented, -phiPrime/jOriented},
    TestID -> "left-handed-vmec-chart-requires-Atheta-prime-minus-Phi-prime"
  ],

  VerificationTest[
    Det[DiagonalMatrix[{1, -1, 1}]],
    -1,
    TestID -> "vmec-theta-relabel-reverses-coordinate-jacobian"
  ],

  VerificationTest[
    Transpose[DiagonalMatrix[{1, -1, 1}]].{aS, aTheta, aZeta},
    {aS, -aTheta, aZeta},
    TestID -> "vmec-theta-relabel-covector-components"
  ],

  VerificationTest[
    Inverse[DiagonalMatrix[{1, -1, 1}]].{bS, bTheta, bZeta},
    {bS, -bTheta, bZeta},
    TestID -> "vmec-theta-relabel-contravariant-vector-components"
  ],

  VerificationTest[
    FullSimplify[
      m (-thetaPrime) - n zeta /. n -> -nPrime
    ],
    -(m thetaPrime - nPrime zeta),
    TestID -> "vmec-theta-relabel-reverses-packed-fourier-phase"
  ],

  VerificationTest[
    FullSimplify[
      {c Cos[-chi] + s Sin[-chi],
       -lc Cos[-chi] - ls Sin[-chi]},
      Assumptions -> Element[{c, s, lc, ls, chi}, Reals]
    ],
    {c Cos[chi] - s Sin[chi], -lc Cos[chi] + ls Sin[chi]},
    TestID -> "vmec-theta-relabel-scalar-and-angular-fourier-parity"
  ],

  VerificationTest[
    FullSimplify[
      {signgs phiEdge/(2 Pi), (-signgs) phiEdge/(2 Pi)}
    ],
    {signgs phiEdge/(2 Pi), -signgs phiEdge/(2 Pi)},
    TestID -> "signgs-aware-torflux-is-poloidal-covector"
  ],

  VerificationTest[
    FullSimplify[
      {-aZetaPrime/jOriented, aThetaPrime/jOriented, ax,
       -(-aZetaPrime)/(-jOriented), (-aThetaPrime)/(-jOriented)}
    ],
    {-aZetaPrime/jOriented, aThetaPrime/jOriented, ax,
     -aZetaPrime/jOriented, aThetaPrime/jOriented},
    TestID -> "correct-flux-relabel-gives-Btheta-opposite-and-Bzeta-same"
  ],

  VerificationTest[
    FullSimplify[
      (-bTheta) (-eTheta) + bZeta eZeta -
        (bTheta eTheta + bZeta eZeta)
    ],
    0,
    TestID -> "theta-relabel-preserves-physical-cartesian-vector"
  ],

  VerificationTest[
    FullSimplify[
      bTheta (-eTheta) + (-bZeta) eZeta
    ],
    -(bTheta eTheta + bZeta eZeta),
    TestID -> "hardcoded-torflux-under-theta-relabel-reverses-physical-B"
  ],

  VerificationTest[
    FullSimplify[
      Integrate[aThetaPrime, {ss, s1, s2},
        Assumptions -> Element[{aThetaPrime, s1, s2}, Reals]] *
        Integrate[1, {tt, 0, 2 Pi}]
    ],
    2 Pi aThetaPrime (s2 - s1),
    TestID -> "oriented-toroidal-disk-flux-is-integral-ds-wedge-dtheta"
  ],

  VerificationTest[
    FullSimplify[
      Integrate[aZetaPrime, {ss, s1, s2},
        Assumptions -> Element[{aZetaPrime, s1, s2}, Reals]] *
        Integrate[1, {zz, 0, 2 Pi}]
    ],
    2 Pi aZetaPrime (s2 - s1),
    TestID -> "oriented-poloidal-ribbon-flux-is-integral-ds-wedge-dzeta"
  ],

  VerificationTest[
    FullSimplify[
      {jOriented (aThetaPrime/jOriented),
       -jOriented (-aZetaPrime/jOriented)}
    ],
    {aThetaPrime, aZetaPrime},
    TestID -> "curl-components-reproduce-disk-and-ribbon-flux-densities"
  ],

  VerificationTest[
    FullSimplify[
      Exp[I (m theta + nCC ph)] /. nCC -> -n
    ],
    Exp[I (m theta - n ph)],
    TestID -> "neo2-and-neort-cc-kernel-map"
  ],

  VerificationTest[
    FullSimplify[
      Exp[2 Pi I (m thetaN - nn zetaN)] /.
        {thetaN -> theta/(2 Pi), zetaN -> ph/(2 Pi), nn -> n}
    ],
    Exp[I (m theta - n ph)],
    TestID -> "gpec-normalized-angle-kernel-map"
  ],

  VerificationTest[
    FullSimplify[
      (Conjugate[ar + I ai] Exp[I (mM chiM + rntor phM)] /.
         {mM -> m, rntor -> -n, chiM -> -theta, phM -> -ph}) -
        Conjugate[(ar + I ai) Exp[I (m theta - n ph)]],
      Assumptions -> Element[{ar, ai, m, n, theta, ph}, Reals]
    ],
    0,
    TestID -> "conditional-mars-cocos2-full-phase-is-house-conjugate"
  ],

  VerificationTest[
    FullSimplify[
      ell omegaB + nCC OmegaPhi /. nCC -> -n
    ],
    ell omegaB - n OmegaPhi,
    TestID -> "neo-resonance-maps-to-house-canonical-resonance"
  ],

  VerificationTest[
    FullSimplify[
      (ell omegaB - n OmegaPhi) /. {ell -> 0, OmegaPhi -> OmegaE + OmegaBmag}
    ],
    -n (OmegaE + OmegaBmag),
    TestID -> "ell0-resonance-tests-relative-electric-and-magnetic-drift-sign"
  ],

  VerificationTest[
    FullSimplify[
      {-Er, -Er} /. Er -> PhiPrime gradRNorm
    ],
    {-PhiPrime gradRNorm, -PhiPrime gradRNorm},
    TestID -> "radial-electric-field-scalar-does-not-flip-with-toroidal-chart"
  ],

  VerificationTest[
    FullSimplify[
      {OmegaEPrime, OmegaBPrime} /.
        {OmegaEPrime -> -OmegaE, OmegaBPrime -> -OmegaBmag}
    ],
    {-OmegaE, -OmegaBmag},
    TestID -> "electric-and-magnetic-angular-components-transform-alike"
  ],

  VerificationTest[
    FullSimplify[
      (nM (OmegaEM + OmegaBM) + ellM omegaBM - omegaMode) -
        (nM (-OmegaEM + OmegaBM) + ellM omegaBM - omegaMode)
    ],
    2 nM OmegaEM,
    TestID -> "mars-profile-reversal-at-fixed-chart-changes-only-electric-term"
  ],

  VerificationTest[
    FullSimplify[
      (-nM) ((-OmegaEM) + (-OmegaBM)) +
        ellM omegaBM - omegaMode
    ],
    nM (OmegaEM + OmegaBM) + ellM omegaBM - omegaMode,
    TestID -> "complete-mars-toroidal-chart-reversal-preserves-precession-contraction"
  ],

  VerificationTest[
    FullSimplify[(lagb - (eulb + advb)) /. lagb -> eulb + advb],
    0,
    TestID -> "gpec-lagb-contains-eulerian-plus-advective-exactly-once"
  ],

  VerificationTest[
    FullSimplify[
      {rho dPhi, (-rho) (-dPhi), rho (-dPhi)},
      Assumptions -> Element[{rho, dPhi}, Reals]
    ],
    {rho dPhi, rho dPhi, -rho dPhi},
    TestID -> "potato-electric-drift-charge-conjugation-versus-profile-reversal"
  ],

  VerificationTest[
    FullSimplify[
      {SeriesCoefficient[rho dPhi/(1 + rho hc), {rho, 0, 1}],
       SeriesCoefficient[(-rho) (-dPhi)/(1 - rho hc), {rho, 0, 1}]}
    ],
    {dPhi, dPhi},
    TestID -> "potato-electric-drift-is-charge-even-to-first-gyroradius-order"
  ],

  VerificationTest[
    FullSimplify[
      {SeriesCoefficient[rho magneticKernel/(1 + rho hc), {rho, 0, 1}],
       SeriesCoefficient[(-rho) magneticKernel/(1 - rho hc), {rho, 0, 1}]}
    ],
    {magneticKernel, -magneticKernel},
    TestID -> "potato-magnetic-drift-is-charge-odd-to-first-gyroradius-order"
  ],

  VerificationTest[
    FullSimplify[
      vCart[
        (R hPhi pZ)/R,
        R (hZ pR - hR pZ)/R,
        (-R hPhi pR)/R,
        ph
      ] - Cross[vCart[hR, hPhi, hZ, ph], vCart[pR, 0, pZ, ph]],
      Assumptions -> Element[{R, hR, hPhi, hZ, pR, pZ, ph}, Reals] && R != 0
    ],
    {0, 0, 0},
    TestID -> "potato-cylindrical-electric-cofactor-is-cartesian-h-cross-gradphi"
  ],

  VerificationTest[
    FullSimplify[
      (-R phPrime) (-ePhi[ph]) - R phPrime ePhi[ph],
      Assumptions -> Element[{R, phPrime, ph}, Reals]
    ],
    {0, 0, 0},
    TestID -> "toroidal-coordinate-reversal-flips-component-and-basis-not-vector"
  ],

  VerificationTest[
    FullSimplify[(-h Tzeta) (-h Omegazeta), Assumptions -> h^2 == 1],
    Tzeta Omegazeta,
    TestID -> "gpec-helicity-angle-map-preserves-power"
  ],

  VerificationTest[
    FullSimplify[
      (-sI sB) sI,
      Assumptions -> {sI^2 == 1, sB^2 == 1}
    ],
    -sB,
    TestID -> "gpec-native-zeta-relative-to-current-depends-on-bt-direction"
  ],

  VerificationTest[
    FullSimplify[
      ((wpfac (welec + diamag) - diamag)/welec) welec,
      Assumptions -> welec != 0
    ],
    diamag (-1 + wpfac) + welec wpfac,
    TestID -> "pentrc-rotation-scaling-has-division-free-continuation"
  ],

  VerificationTest[
    FullSimplify[
      (-diamag + wpfac (diamag + welec)) /. {welec -> 0, wpfac -> 1}
    ],
    0,
    TestID -> "pentrc-exact-zero-omegaE-is-algebraically-well-defined"
  ],

  VerificationTest[
    {Det[{{1, 2}, {2, 5}}], {{1, 2}, {2, 5}}.{1, -1}},
    {1, {-1, -3}},
    TestID -> "positive-definite-metric-can-reverse-covariant-component-signs"
  ],

  VerificationTest[
    FullSimplify[
      {D[pressure[-psi], psi],
       field[-psi] D[field[-psi], psi]},
      Assumptions -> Element[psi, Reals]
    ],
    {-pressure'[-psi], -field[-psi] field'[-psi]},
    TestID -> "flux-reversal-chain-rule-flips-pprime-and-ffprim"
  ],

  VerificationTest[
    FullSimplify[
      SeriesCoefficient[
        scalarField[x + eps displacement] + eps eulerianScalar[x + eps displacement],
        {eps, 0, 1}
      ]
    ],
    displacement scalarField'[x] + eulerianScalar[x],
    TestID -> "lagrangian-scalar-is-eulerian-plus-advective"
  ],

  VerificationTest[
    FullSimplify[
      D[Exp[I (m theta + n z/R0 - omega t)], t] /
        Exp[I (m theta + n z/R0 - omega t)]
    ],
    -I omega,
    TestID -> "kilca-kernel-is-exp-i-mtheta-plus-nz-over-R-minus-omega-t"
  ],

  VerificationTest[
    FullSimplify[
      {D[Exp[I (m theta + n z/R0)], theta]/
          (I r Exp[I (m theta + n z/R0)]),
       D[Exp[I (m theta + n z/R0)], z]/
          (I Exp[I (m theta + n z/R0)])}
    ],
    {m/r, n/R0},
    TestID -> "kilca-cylindrical-wavevector-is-m-over-r-and-n-over-R"
  ],

  VerificationTest[
    FullSimplify[
      (m Btheta/r + n Bz/R0) /.
        Btheta -> Bz r/(q R0) /. q -> -m/n,
      Assumptions -> m n R0 != 0
    ],
    0,
    TestID -> "kilca-resonance-is-m-plus-nq-zero"
  ],

  VerificationTest[
    FullSimplify[
      Cross[{Er, 0, 0}, {0, B0 htheta, B0 hz}] c/B0^2,
      Assumptions -> B0 != 0
    ],
    {0, -c Er hz/B0, c Er htheta/B0},
    TestID -> "kamel-cylinder-outward-Er-gives-signed-ExB-components"
  ],

  VerificationTest[
    FullSimplify[
      {0, m/r, n/R0} .
          ({0, -c Er hz/B0, c Er htheta/B0}) +
        (c Er/B0) (hz m/r - htheta n/R0),
      Assumptions -> B0 r R0 != 0
    ],
    0,
    TestID -> "kim-electric-frequency-uses-ks-hz-m-over-r-minus-htheta-n-over-R"
  ],

  VerificationTest[
    FullSimplify[
      scale (hz m/(scale r) - htheta n/(scale R0)) -
        (hz m/r - htheta n/R0),
      Assumptions -> scale r R0 != 0
    ],
    0,
    TestID -> "correct-kim-ks-is-homogeneous-in-inverse-length"
  ],

  VerificationTest[
    FullSimplify[
      {-(-echarge) fluxFactor gammaElectron,
       -(zcharge echarge) fluxFactor gammaIon}
    ],
    {echarge fluxFactor gammaElectron,
     -zcharge echarge fluxFactor gammaIon},
    TestID -> "qlbalance-electron-and-ion-flux-force-signs-follow-species-charge"
  ],

  VerificationTest[
    FullSimplify[{
      Cross[
        {r Cos[theta], r Sin[theta], 0},
        {fr Cos[theta] - ftheta Sin[theta],
         fr Sin[theta] + ftheta Cos[theta], fz}
      ].{0, 0, 1},
      D[{r Cos[theta], r Sin[theta], R0 phiK}, phiK].
        {fr Cos[theta] - ftheta Sin[theta],
         fr Sin[theta] + ftheta Cos[theta], fz}
    }],
    {r ftheta, R0 fz},
    TestID -> "kilca-torques-follow-cartesian-moment-and-periodic-virtual-work"
  ],

  VerificationTest[
    FullSimplify[
      {Bx dxXiX + By dyXiX - Bx divXi,
       Bx dxXiY + By dyXiY - By divXi}
    ],
    {Bx (dxXiX - divXi) + By dyXiX,
     Bx dxXiY + By (dyXiY - divXi)},
    TestID -> "ideal-mhd-lagrangian-vector-change-is-deformation-not-scalar-copy"
  ],

  VerificationTest[
    FullSimplify[
      Cross[Cos[theta] eR[ph] - Sin[theta] eZ,
        -Sin[theta] eR[ph] - Cos[theta] eZ],
      Assumptions -> Element[{theta, ph}, Reals]
    ],
    ePhi[ph],
    TestID -> "house-minor-toroidal-frame-is-right-handed"
  ],

  VerificationTest[
    FullSimplify[
      xCyl[R0 + r Cos[theta], ph, -r Sin[theta]] -
        ((R0 + r Cos[theta]) eR[ph] - r Sin[theta] eZ),
      Assumptions -> Element[{R0, r, theta, ph}, Reals]
    ],
    {0, 0, 0},
    TestID -> "house-toroidal-chart-has-explicit-cartesian-embedding"
  ],

  VerificationTest[
    FullSimplify[
      (D[r (R0 + r Cos[theta]) 0, r] +
        D[(R0 + r Cos[theta]) cc r/(R0 + r Cos[theta]), theta] +
        D[r ff/(R0 + r Cos[theta]), ph]) /
          (r (R0 + r Cos[theta])),
      Assumptions -> r (R0 + r Cos[theta]) != 0
    ],
    0,
    TestID -> "manufactured-axisymmetric-field-is-solenoidal"
  ],

  VerificationTest[
    FullSimplify[
      D[Pi cc r^2, r]/(2 Pi (R0 + r Cos[theta])),
      Assumptions -> R0 + r Cos[theta] != 0
    ],
    cc r/(R0 + r Cos[theta]),
    TestID -> "full-poloidal-flux-definition-has-explicit-two-pi"
  ],

  VerificationTest[
    FullSimplify[
      {
        1/(r (R0 + r Cos[theta])) (
          D[cc r xiFun[r] Exp[I (m theta - n ph)], theta] -
          D[-r ff xiFun[r] Exp[I (m theta - n ph)]/
            (R0 + r Cos[theta]), ph]),
        -1/(R0 + r Cos[theta])
          D[cc r xiFun[r] Exp[I (m theta - n ph)], r],
        1/r D[-r ff xiFun[r] Exp[I (m theta - n ph)]/
          (R0 + r Cos[theta]), r]
      } - {
      I xiFun[r] Exp[I (m theta - n ph)]
        (m cc - n ff/(R0 + r Cos[theta]))/(R0 + r Cos[theta]),
      -cc (xiFun[r] + r xiFun'[r]) Exp[I (m theta - n ph)]/
        (R0 + r Cos[theta]),
      -ff (xiFun[r] + r xiFun'[r]) Exp[I (m theta - n ph)]/
        (r (R0 + r Cos[theta])) +
        ff xiFun[r] Cos[theta] Exp[I (m theta - n ph)]/
          (R0 + r Cos[theta])^2
      },
      Assumptions -> r (R0 + r Cos[theta]) != 0
    ],
    {0, 0, 0},
    TestID -> "manufactured-ideal-mhd-perturbation-is-curl-xi-cross-B0"
  ],

  VerificationTest[
    FullSimplify[
      D[Sqrt[ff^2 + cc^2 r^2]/(R0 + r Cos[theta]), r] -
        (cc^2 r/((R0 + r Cos[theta]) Sqrt[ff^2 + cc^2 r^2]) -
        Sqrt[ff^2 + cc^2 r^2] Cos[theta]/(R0 + r Cos[theta])^2),
      Assumptions -> {r > 0, R0 + r Cos[theta] > 0,
        ff^2 + cc^2 r^2 > 0, Element[{ff, cc, R0, theta}, Reals]}
    ],
    0,
    TestID -> "advective-scalar-uses-physical-radial-Bmod-gradient"
  ],

  VerificationTest[
    FullSimplify[
      Cross[{er, 0, 0}, {0, cc r/rr, ff/rr}]/
        ((cc r/rr)^2 + (ff/rr)^2),
      Assumptions -> rr (ff^2 + cc^2 r^2) != 0
    ],
    {0, -er ff rr/(ff^2 + cc^2 r^2), er cc r rr/(ff^2 + cc^2 r^2)},
    TestID -> "manufactured-electric-drift-is-one-physical-cross-product"
  ],

  VerificationTest[
    FullSimplify[
      (R0 - Sqrt[R0^2 - aa^2])/(R0 - Sqrt[R0^2 - aa^2]),
      Assumptions -> {R0 > aa > 0}
    ],
    1,
    TestID -> "manufactured-toroidal-flux-coordinate-has-unit-edge"
  ],

  VerificationTest[
    Inverse[Transpose[DiagonalMatrix[{-1, -1}]]].{m, -n},
    {-m, n},
    TestID -> "mars-clockwise-chart-direct-plus-plus-covector"
  ],

  VerificationTest[
    Inverse[Transpose[DiagonalMatrix[{-1, 1}]]].{m, -n},
    {-m, -n},
    TestID -> "neo-cc-left-handed-plus-plus-covector"
  ],

  VerificationTest[
    FullSimplify[
      Re[(ampR - I ampI) Exp[I (m (-theta) - n (-ph))]] -
        Re[(ampR + I ampI) Exp[I (m theta - n ph)]],
      Assumptions -> Element[{ampR, ampI, theta, ph, m, n}, Reals]
    ],
    0,
    TestID -> "gpec-positive-helicity-conjugate-representative-is-same-real-mode"
  ],

  VerificationTest[
    FullSimplify[
      (Inverse[Transpose[DiagonalMatrix[{-1, 1}]]].{tt, tp}).
        (DiagonalMatrix[{-1, 1}].{ot, op})
    ],
    tt ot + tp op,
    TestID -> "neo-chart-torque-power-is-invariant"
  ],

  VerificationTest[
    FullSimplify[
      Det[Transpose[{
        D[xCyl[R0 + aa Sqrt[s] Cos[theta], ph,
          aa Sqrt[s] Sin[theta]], s],
        D[xCyl[R0 + aa Sqrt[s] Cos[theta], ph,
          aa Sqrt[s] Sin[theta]], theta],
        D[xCyl[R0 + aa Sqrt[s] Cos[theta], ph,
          aa Sqrt[s] Sin[theta]], ph]
      }]],
      Assumptions -> {s > 0, aa > 0,
        R0 + aa Sqrt[s] Cos[theta] > 0,
        Element[{s, aa, R0, theta, ph}, Reals]}
    ],
    -aa^2 (R0 + aa Sqrt[s] Cos[theta])/2,
    TestID -> "gorilla-signgs-minus-one-vmec-cartesian-jacobian-is-negative"
  ],

  VerificationTest[
    FullSimplify[
      (R0 + aa Sqrt[s] Cos[theta]) *
        (D[R0 + aa Sqrt[s] Cos[theta], theta] *
           D[aa Sqrt[s] Sin[theta], s] -
         D[R0 + aa Sqrt[s] Cos[theta], s] *
           D[aa Sqrt[s] Sin[theta], theta]),
      Assumptions -> {s > 0, aa > 0,
        R0 + aa Sqrt[s] Cos[theta] > 0,
        Element[{s, aa, R0, theta, ph}, Reals]}
    ],
    -aa^2 (R0 + aa Sqrt[s] Cos[theta])/2,
    TestID -> "gorilla-sqgV-equals-signed-vmec-cartesian-jacobian"
  ],

  VerificationTest[
    FullSimplify[
      {tor iota/(-JV/(1 + ltheta)),
       tor/(-JV/(1 + ltheta)),
       (tor iota/(-JV/(1 + ltheta)) -
         lphi tor/(-JV/(1 + ltheta)))/(1 + ltheta)},
      Assumptions -> JV (1 + ltheta) != 0
    ],
    {-tor iota (1 + ltheta)/JV,
     -tor (1 + ltheta)/JV,
     (-iota + lphi) tor/JV},
    TestID -> "gorilla-lambda-basis-map-reconstructs-vmec-contravariants"
  ],

  VerificationTest[
    FullSimplify[
      ({tor iota/sqg, tor/sqg} /. tor -> -tor) +
        {tor iota/sqg, tor/sqg},
      Assumptions -> sqg != 0
    ],
    {0, 0},
    TestID -> "gorilla-signed-toroidal-flux-reversal-flips-magnetic-field"
  ],

  VerificationTest[
    FullSimplify[
      mass/(mass cLight/q),
      Assumptions -> mass cLight q != 0
    ],
    q/cLight,
    TestID -> "gorilla-canonical-momentum-mass-over-cm-over-e-is-q-over-c"
  ],

  VerificationTest[
    FullSimplify[
      (-q) Cross[-{v1, v2, v3}, {b1, b2, b3}] -
        q Cross[{v1, v2, v3}, {b1, b2, b3}]
    ],
    {0, 0, 0},
    TestID -> "simple-lorentz-charge-velocity-reversal-is-time-reversal"
  ],

  VerificationTest[
    FullSimplify[
      (-q) Cross[{v1, v2, v3}, {b1, b2, b3}] -
        q Cross[{v1, v2, v3}, -{b1, b2, b3}]
    ],
    {0, 0, 0},
    TestID -> "simple-charge-and-whole-B-reversal-are-lorentz-degenerate"
  ],

  VerificationTest[
    FullSimplify[
      (-chargeInternal)/(-ro0Simple massSimple) -
        chargeInternal/(ro0Simple massSimple),
      Assumptions -> ro0Simple massSimple != 0
    ],
    0,
    TestID -> "simple-joint-internal-charge-ro0-reversal-is-double-flip"
  ],

  VerificationTest[
    FreeQ[vParallelSimple^2/2 + muSimple bSimple, phiSimple],
    True,
    TestID -> "simple-active-canonical-Hamiltonian-has-no-electrostatic-potential"
  ],

  VerificationTest[
    FullSimplify[
      sMat.{-bThetaSimple, -bZetaSimple} +
        sMat.{bThetaSimple, bZetaSimple}
    ],
    {0, 0},
    TestID -> "simple-whole-field-covariant-reversal-flips-physical-vector"
  ],

  VerificationTest[
    FullSimplify[
      {-torfluxSimple sSimple, torfluxSimple iotaIntegralSimple} +
        {torfluxSimple sSimple, -torfluxSimple iotaIntegralSimple}
    ],
    {0, 0},
    TestID -> "simple-signed-flux-reversal-flips-vector-potential-covariants"
  ],

  VerificationTest[
    FullSimplify[
      ({xGc1, xGc2, xGc3} +
          epsilonLarmor {rhoL1, rhoL2, rhoL3}) -
        epsilonLarmor {rhoL1, rhoL2, rhoL3} -
        {xGc1, xGc2, xGc3}
    ],
    {0, 0, 0},
    TestID -> "simple-full-orbit-seed-and-guiding-center-reduction-are-inverse"
  ],

  VerificationTest[
    FullSimplify[
      D[
        ({xGc1, xGc2, xGc3} +
            epsilonLarmor {rhoL1, rhoL2, rhoL3}) -
          {xGc1, xGc2, xGc3},
        epsilonLarmor
      ]
    ],
    {rhoL1, rhoL2, rhoL3},
    TestID -> "simple-larmor-offset-is-first-order-in-small-parameter"
  ],

  VerificationTest[
    FullSimplify[
      Cross[-{e1, e2, e3}, {b1, b2, b3}] +
        Cross[{e1, e2, e3}, {b1, b2, b3}]
    ],
    {0, 0, 0},
    TestID -> "gorilla-electric-field-reversal-reverses-exb-drift"
  ],

  VerificationTest[
    FullSimplify[
      Cross[-{e1, e2, e3}, -{b1, b2, b3}] -
        Cross[{e1, e2, e3}, {b1, b2, b3}]
    ],
    {0, 0, 0},
    TestID -> "gorilla-joint-electric-magnetic-reversal-preserves-exb-drift"
  ],

  VerificationTest[
    FreeQ[Cross[{e1, e2, e3}, {b1, b2, b3}]/bmag^2, q],
    True,
    TestID -> "gorilla-exb-drift-is-independent-of-charge-sign"
  ],

  VerificationTest[
    FullSimplify[
      Cross[{b1, b2, b3}, {g1, g2, g3}]/(-q) +
        Cross[{b1, b2, b3}, {g1, g2, g3}]/q,
      Assumptions -> q != 0
    ],
    {0, 0, 0},
    TestID -> "gorilla-charge-reversal-reverses-gradB-drift"
  ],

  VerificationTest[
    FullSimplify[
      Cross[-{b1, b2, b3}, {g1, g2, g3}]/q +
        Cross[{b1, b2, b3}, {g1, g2, g3}]/q,
      Assumptions -> q != 0
    ],
    {0, 0, 0},
    TestID -> "gorilla-magnetic-field-reversal-reverses-gradB-drift"
  ],

  VerificationTest[
    FullSimplify[
      Cross[-{b1, b2, b3}, {g1, g2, g3}]/(-q) -
        Cross[{b1, b2, b3}, {g1, g2, g3}]/q,
      Assumptions -> q != 0
    ],
    {0, 0, 0},
    TestID -> "gorilla-joint-charge-magnetic-reversal-preserves-gradB-drift"
  ],

  VerificationTest[
    FullSimplify[(-eps) (-aPhi) - eps aPhi],
    0,
    TestID -> "gorilla-B-and-eps-reversal-preserves-native-potential"
  ],

  VerificationTest[
    FullSimplify[eps (-aPhi) + eps aPhi],
    0,
    TestID -> "gorilla-B-reversal-at-fixed-eps-reverses-native-potential"
  ],

  VerificationTest[
    FullSimplify[
      2 Re[(ampR + I ampI) Exp[I n ph]] -
        2 (ampR Cos[n ph] - ampI Sin[n ph]),
      Assumptions -> Element[{ampR, ampI, n, ph}, Reals]
    ],
    0,
    TestID -> "mephit-gorilla-plus-phase-complex-synthesis"
  ],

  VerificationTest[
    FullSimplify[
      D[(ampR + I ampI) Exp[I n ph], ph]/R -
        I n/R (ampR + I ampI) Exp[I n ph],
      Assumptions -> {R != 0, Element[{ampR, ampI, n, ph, R}, Reals]}
    ],
    0,
    TestID -> "mephit-physical-phi-derivative-is-plus-i-n-over-R"
  ],

  VerificationTest[
    FullSimplify[
      Conjugate[(ampR + I ampI)],
      Assumptions -> Element[{ampR, ampI}, Reals]
    ],
    ampR - I ampI,
    TestID -> "mephit-real-field-negative-mode-is-positive-mode-conjugate"
  ],

  VerificationTest[
    FullSimplify[
      R vPhysicalPhi - vCovariantPhi /.
        vCovariantPhi -> R vPhysicalPhi
    ],
    0,
    TestID -> "mephit-physical-to-gorilla-covariant-phi-component-needs-R"
  ],

  VerificationTest[
    FullSimplify[Cross[eR[ph], eZ], Element[ph, Reals]],
    -ePhi[ph],
    TestID -> "positive-visual-RZ-loop-normal-is-minus-ephi"
  ],

  VerificationTest[
    FullSimplify[
      (sigmaZeta bZeta)/(sigmaTheta bTheta) -
        (sigmaZeta/sigmaTheta) (bZeta/bTheta),
      Assumptions -> {bTheta != 0, sigmaTheta != 0}
    ],
    0,
    TestID -> "signed-q-transforms-as-relative-angle-orientation"
  ],

  VerificationTest[
    FullSimplify[R (bPhysicalPhi/R) - bPhysicalPhi, R != 0],
    0,
    TestID -> "physical-cylindrical-to-contravariant-phi-needs-inverse-R"
  ],

  VerificationTest[
    FullSimplify[
      With[{
        psiSolovev = a/8 ((R^2 - R0^2)^2 + 4 R^2 Z^2),
        pPrimeSolovev = -a/(2 Pi)
      },
        cLight/(4 Pi) (
          D[-D[psiSolovev, Z]/R, Z] -
          D[D[psiSolovev, R]/R, R]
        ) - cLight pPrimeSolovev R
      ],
      Assumptions -> R != 0
    ],
    0,
    TestID -> "analytic-geqdsk-curlB-and-grad-shafranov-toroidal-current-close"
  ],

  VerificationTest[
    FullSimplify[
      1/R D[R (-D[psiM[R, Z], Z]/R), R] +
        D[D[psiM[R, Z], R]/R, Z],
      Assumptions -> R != 0
    ],
    0,
    TestID -> "m3dc1-axisymmetric-poloidal-B-is-divergence-free"
  ],

  VerificationTest[
    FullSimplify[
      D[-D[psiM[R, Z], Z]/R, Z] -
        D[D[psiM[R, Z], R]/R, R] +
        (R D[D[psiM[R, Z], R]/R, R] + D[psiM[R, Z], {Z, 2}])/R,
      Assumptions -> R != 0
    ],
    0,
    TestID -> "m3dc1-toroidal-current-is-minus-delta-star-psi-over-R"
  ],

  VerificationTest[
    FullSimplify[{
      -D[fM[R, Z]/R, Z] + D[fM[R, Z], Z]/R,
      1/R D[R (fM[R, Z]/R), R] - D[fM[R, Z], R]/R
    }, Assumptions -> R != 0],
    {0, 0},
    TestID -> "m3dc1-poloidal-current-from-F-has-minus-Z-plus-R-signs"
  ],

  VerificationTest[
    FullSimplify[
      D[ampM Exp[I nM ph], ph] - I nM ampM Exp[I nM ph],
      Assumptions -> Element[{nM, ph}, Reals]
    ],
    0,
    TestID -> "m3dc1-complex-mode-uses-plus-i-n-toroidal-derivative"
  ],

  VerificationTest[
    FullSimplify[
      Cross[-phiPrimeM {psiRM, 0, psiZM},
          {-psiZM/R, fM/R, psiRM/R}]/
          ((psiRM^2 + psiZM^2 + fM^2)/R^2) -
        ({0, R phiPrimeM, 0} -
          phiPrimeM R^2 fM/(psiRM^2 + psiZM^2 + fM^2)
            {-psiZM/R, fM/R, psiRM/R}),
      Assumptions -> {R > 0, psiRM^2 + psiZM^2 + fM^2 != 0}],
    {0, 0, 0},
    TestID -> "m3dc1-ExB-coefficient-is-plus-electrostatic-potential-derivative"
  ],

  VerificationTest[
    FullSimplify[
      Cross[{-psiZM/R, fM/R, psiRM/R},
          pPrimeM {psiRM, 0, psiZM}]/
          (chargeM densityM (psiRM^2 + psiZM^2 + fM^2)/R^2) -
        ({0, R pPrimeM/(chargeM densityM), 0} -
          pPrimeM R^2 fM/(chargeM densityM
            (psiRM^2 + psiZM^2 + fM^2))
            {-psiZM/R, fM/R, psiRM/R}),
      Assumptions -> {R > 0, chargeM densityM != 0,
        psiRM^2 + psiZM^2 + fM^2 != 0}],
    {0, 0, 0},
    TestID -> "m3dc1-ion-diamagnetic-coefficient-is-plus-p-prime-over-qn"
  ],

  VerificationTest[
    FullSimplify[
      omegaExBM + omegaStarIM -
        (omegaExBM - omegaStarIM),
      Assumptions -> omegaStarIM != 0],
    2 omegaStarIM,
    TestID -> "m3dc1-profile-reader-minus-sign-is-distinguishable-from-documented-plus"
  ],

  VerificationTest[
    FullSimplify[Table[
      (-1)^vFlipM (omegaInputM - (-1)^(jFlipM + vFlipM) diaTermM) -
        ((-1)^vFlipM omegaInputM - (-1)^jFlipM diaTermM),
      {jFlipM, 0, 1}, {vFlipM, 0, 1}]],
    {{0, 0}, {0, 0}},
    TestID -> "m3dc1-executable-iflip-quadrants-separate-input-and-diamagnetic-components"
  ],

  VerificationTest[
    FullSimplify[Table[
      (-1)^vFlipM (omegaInputM + (-1)^(jFlipM + vFlipM) diaTermM) -
        ((-1)^vFlipM omegaInputM + (-1)^jFlipM diaTermM),
      {jFlipM, 0, 1}, {vFlipM, 0, 1}]],
    {{0, 0}, {0, 0}},
    TestID -> "m3dc1-corrected-iflip-quadrants-preserve-component-state-separation"
  ],

  VerificationTest[
    FullSimplify[
      D[bmn Cos[mR thetaR - nfpR nR zetaR], thetaR] +
        mR bmn Sin[mR thetaR - nfpR nR zetaR],
      Assumptions -> Element[{bmn, mR, nR, nfpR, thetaR, zetaR}, Reals]
    ],
    0,
    TestID -> "rabe-minus-phase-poloidal-derivative"
  ],

  VerificationTest[
    FullSimplify[
      D[bmn Cos[mR thetaR - nfpR nR zetaR], zetaR] -
        nfpR nR bmn Sin[mR thetaR - nfpR nR zetaR],
      Assumptions -> Element[{bmn, mR, nR, nfpR, thetaR, zetaR}, Reals]
    ],
    0,
    TestID -> "rabe-minus-phase-toroidal-derivative-is-plus-nfp-n-sine"
  ],

  VerificationTest[
    FullSimplify[
      Cos[mR thetaR - nfpR nR (zetaR + 2 Pi/nfpR)] -
        Cos[mR thetaR - nfpR nR zetaR],
      Assumptions -> {Element[nR, Integers], nfpR != 0,
        Element[{mR, nfpR, thetaR, zetaR}, Reals]}
    ],
    0,
    TestID -> "rabe-normalized-n-is-one-field-period-periodic"
  ],

  VerificationTest[
    FullSimplify[
      D[theta0R + iotaR (zetaR - zeta0R), zetaR] - iotaR,
      Assumptions -> Element[{theta0R, iotaR, zetaR, zeta0R}, Reals]
    ],
    0,
    TestID -> "rabe-fieldline-slope-is-iota"
  ],

  VerificationTest[
    FullSimplify[
      (-iotaR) (-{et1, et2, et3}) + {ez1, ez2, ez3} -
        (iotaR {et1, et2, et3} + {ez1, ez2, ez3})
    ],
    {0, 0, 0},
    TestID -> "rabe-theta-relabel-preserves-fieldline-tangent"
  ],

  VerificationTest[
    FullSimplify[
      ((-iotaR) (-bthetaR) + bzetaR) -
        (iotaR bthetaR + bzetaR)
    ],
    0,
    TestID -> "rabe-theta-relabel-preserves-iota-Btheta-plus-Bzeta"
  ],

  VerificationTest[
    FullSimplify[
      ((-bphiR) (-mHelR) + bthetaR nHelR)/
          ((-mHelR) (-iotaR) - nHelR) -
        (bphiR mHelR + bthetaR nHelR)/(mHelR iotaR - nHelR),
      Assumptions -> mHelR iotaR != nHelR
    ],
    0,
    TestID -> "rabe-joint-B-and-theta-reversal-preserves-helical-factor"
  ],

  VerificationTest[
    FullSimplify[
      1/2 Sqrt[1 - etaR bR]/bR^3 (3 + 1 - etaR bR) (-dBdthetaR) +
        1/2 Sqrt[1 - etaR bR]/bR^3 (3 + 1 - etaR bR) dBdthetaR
    ],
    0,
    TestID -> "rabe-theta-relabel-flips-local-radial-drift-proxy"
  ],

  VerificationTest[
    FullSimplify[
      (-signgsR)/(gradSR (-psiEdgeR)) -
        signgsR/(gradSR psiEdgeR),
      Assumptions -> gradSR psiEdgeR != 0
    ],
    0,
    TestID -> "rabe-theta-relabel-keeps-dr-dAtheta-when-signgs-and-flux-reverse"
  ],

  VerificationTest[
    FullSimplify[
      (bzetaR (-mHelR) + (-bthetaR) nHelR)/
          ((-mHelR) (-iotaR) - nHelR) +
        (bzetaR mHelR + bthetaR nHelR)/(mHelR iotaR - nHelR),
      Assumptions -> mHelR iotaR != nHelR
    ],
    0,
    TestID -> "rabe-theta-relabel-flips-helical-factor"
  ],

  VerificationTest[
    FullSimplify[(-deviationR) drdAR + deviationR drdAR],
    0,
    TestID -> "rabe-theta-relabel-flips-LambdaA-and-LambdaB-covectors"
  ],

  VerificationTest[
    FullSimplify[
      (-(-helicalR) drdAR positiveR) +
        (-helicalR drdAR positiveR)
    ],
    0,
    TestID -> "rabe-theta-relabel-flips-LambdaS-covector"
  ],

  VerificationTest[
    FullSimplify[
      ((-helicalR) drdAR trappedR) +
        (helicalR drdAR trappedR)
    ],
    0,
    TestID -> "rabe-theta-relabel-flips-Landreman-Catto-covector"
  ],

  VerificationTest[
    FullSimplify[
      (-helicalR drdAR positiveR) +
        (helicalR drdAR positiveR)
    ],
    0,
    TestID -> "rabe-LambdaS-has-explicit-minus-relative-to-positive-helical-product"
  ],

  VerificationTest[
    FullSimplify[
      (drdAR helicalR trappedR) -
        (helicalR drdAR trappedR)
    ],
    0,
    TestID -> "rabe-Landreman-Catto-factor-has-positive-helical-product"
  ],

  VerificationTest[
    FullSimplify[
      2 Pi/periodSimple > 0,
      Assumptions -> periodSimple > 0
    ],
    True,
    TestID -> "simple-bounce-frequency-is-positive-for-positive-measured-period"
  ],

  VerificationTest[
    FullSimplify[
      (-deltaPhiSimple)/periodSimple +
        deltaPhiSimple/periodSimple,
      Assumptions -> periodSimple > 0
    ],
    0,
    TestID -> "simple-toroidal-frequency-reverses-with-signed-displacement"
  ],

  VerificationTest[
    FullSimplify[
      (Sqrt[2 diffusionSimple (1 - (-lambdaSimple)^2) dtSimple]
          (-kickSimple) -
          2 (-lambdaSimple) diffusionSimple dtSimple) +
        (Sqrt[2 diffusionSimple (1 - lambdaSimple^2) dtSimple]
          kickSimple -
          2 lambdaSimple diffusionSimple dtSimple),
      Assumptions -> {
        diffusionSimple >= 0,
        dtSimple >= 0,
        -1 <= lambdaSimple <= 1,
        Element[kickSimple, Reals]
      }
    ],
    0,
    TestID -> "simple-pitch-collision-step-is-covariant-under-lambda-kick-reversal"
  ],

  VerificationTest[
    FullSimplify[
      ((1 - (-lambdaSimple)^2) bmaxSimple/bSimple - 1)
          bminSimple/(bmaxSimple - bminSimple) -
        ((1 - lambdaSimple^2) bmaxSimple/bSimple - 1)
          bminSimple/(bmaxSimple - bminSimple),
      Assumptions -> {
        bSimple != 0,
        bmaxSimple != bminSimple
      }
    ],
    0,
    TestID -> "simple-trap-parameter-is-even-under-pitch-reversal"
  ],

  VerificationTest[
    FullSimplify[
      pSimple^2 (1 - (-lambdaSimple)^2)/bSimple -
        pSimple^2 (1 - lambdaSimple^2)/bSimple,
      Assumptions -> bSimple != 0
    ],
    0,
    TestID -> "simple-perpendicular-invariant-is-even-under-pitch-reversal"
  ],

  VerificationTest[
    FullSimplify[
      (-lambdaSimple)^2 dtSimple - lambdaSimple^2 dtSimple
    ],
    0,
    TestID -> "simple-Jparallel-increment-is-even-under-pitch-reversal"
  ],

  VerificationTest[
    FullSimplify[
      (-deltaTheta1Simple) (-deltaTheta2Simple) -
        deltaTheta1Simple deltaTheta2Simple
    ],
    0,
    TestID -> "simple-recurrence-crossing-product-is-orientation-even"
  ],

  VerificationTest[
    FullSimplify[
      ((originSimple - xSimple) - (originSimple - xmaxSimple))/
          ((originSimple - xminSimple) - (originSimple - xmaxSimple)) -
        (1 - (xSimple - xminSimple)/(xmaxSimple - xminSimple)),
      Assumptions -> xmaxSimple != xminSimple
    ],
    0,
    TestID -> "simple-fractal-minmax-coordinate-reflects-as-one-minus-u"
  ]
};

report = TestReport[tests];
passed = Length[report["TestsSucceeded"]];
failed = Length[report["TestsFailedWrongResults"]] +
  Length[report["TestsFailedWithMessages"]] +
  Length[report["TestsFailedWithErrors"]];
Print["Tests passed: ", passed, "/", passed + failed];
If[failed != 0,
  Print["Wrong results: ", report["TestsFailedWrongResults"]];
  Print["Messages: ", report["TestsFailedWithMessages"]];
  Print["Errors: ", report["TestsFailedWithErrors"]]
];
Exit[If[failed == 0, 0, 1]];
