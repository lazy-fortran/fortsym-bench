(* Algebraic checks for the NTV theory review.
   These tests verify identities after assumptions have been supplied; they do
   not establish the physical assumptions themselves. *)

ClearAll["Global`*"];

tests = {
  VerificationTest[
    FullSimplify[-(c/qs) (-(qs/c) psip + ms vpar Bphi/B)],
    psip - (ms c/qs) vpar Bphi/B,
    TestID -> "canonical-momentum-to-house-psi-star-cocos11"
  ],

  VerificationTest[
    FullSimplify[
      Integrate[
        ComplexExpand[Re[(ar + I ai) Exp[I chi]]]
          ComplexExpand[Re[(br + I bi) Exp[I chi]]],
        {chi, 0, 2 Pi}
      ]/(2 Pi),
      Assumptions -> Element[{ar, ai, br, bi}, Reals]
    ],
    (ar br + ai bi)/2,
    TestID -> "real-fourier-pair-normalized-angle-average"
  ],

  VerificationTest[
    FullSimplify[
      ComplexExpand[Re[(ar + I ai) Exp[I chi]]],
      Assumptions -> Element[{ar, ai, chi}, Reals]
    ],
    ar Cos[chi] - ai Sin[chi],
    TestID -> "half-lattice-real-field-reconstruction"
  ],

  VerificationTest[
    FullSimplify[
      (psiSource + (ms c/qs) vpar Bphi/B) /.
        psiSource -> -psip
    ],
    -(psip - (ms c/qs) vpar Bphi/B),
    TestID -> "conditional-potato-source-flux-sign-substitution"
  ],

  VerificationTest[
    FullSimplify[
      (ms c mu/qs) (qs bfield/(ms c)),
      Assumptions -> ms c qs != 0
    ],
    mu bfield,
    TestID -> "signed-gyroaction-times-signed-cyclotron-energy"
  ],

  VerificationTest[
    FullSimplify[
      2 H0 - 2 qs Phi - Jperp omegac /.
        H0 -> ms vpar^2/2 + Jperp omegac + qs Phi
    ],
    ms vpar^2 + Jperp omegac,
    TestID -> "hamiltonian-perturbation-coefficient"
  ],

  VerificationTest[
    D[-(qs/c) psi[r], r],
    -(qs/c) psi'[r],
    TestID -> "house-flux-force-canonical-momentum-sign"
  ],

  VerificationTest[
    FullSimplify[
      -D[Hk Exp[I (ell alpha - n phi - omega t)], phi]
    ],
    I n Hk Exp[I (ell alpha - n phi - omega t)],
    TestID -> "house-toroidal-harmonic-force-sign"
  ],

  VerificationTest[
    FullSimplify[
      (ell omegab + nsrc Omegaphi - omega) /. nsrc -> -n
    ],
    ell omegab - n Omegaphi - omega,
    TestID -> "albert-source-to-house-resonance-sign"
  ],

  VerificationTest[
    FullSimplify[
      Exp[I ((m - n q) theta + n alpha)] /.
        alpha -> q theta - phi
    ],
    Exp[I (m theta - n phi)],
    TestID -> "park-field-line-label-to-house-spatial-phase"
  ],

  VerificationTest[
    FullSimplify[
      Exp[I (m theta + nCC phi)] /. nCC -> -n
    ],
    Exp[I (m theta - n phi)],
    TestID -> "neo2-cc-boozer-to-house-spatial-phase"
  ],

  VerificationTest[
    FullSimplify[
      Exp[I (m theta + rntor phi)] /. rntor -> -n
    ],
    Exp[I (m theta - n phi)],
    TestID -> "conditional-mars-file-label-algebra"
  ],

  VerificationTest[
    FullSimplify[
      Exp[I (m chi + rntor phiM)] /. phiM -> -phi
    ],
    Exp[I (m chi - rntor phi)],
    TestID -> "mars-isolated-toroidal-coordinate-reversal"
  ],

  VerificationTest[
    D[-phiM[t], t] /. Derivative[1][phiM][t] -> OmegaM,
    -OmegaM,
    TestID -> "mars-to-house-angular-frequency-component-reversal"
  ],

  VerificationTest[
    FullSimplify[TM D[-phiN, phiN]],
    -TM,
    TestID -> "mars-to-house-generalized-torque-covector-reversal"
  ],

  VerificationTest[
    FullSimplify[TN OmegaN /. {TN -> -TM, OmegaN -> -OmegaM}],
    TM OmegaM,
    TestID -> "mars-to-house-torque-power-invariance"
  ],

  VerificationTest[
    FullSimplify[
      Exp[I (m theta - xn zeta)] /. {xn -> n, zeta -> phi}
    ],
    Exp[I (m theta - n phi)],
    TestID -> "vmec-wout-to-house-spatial-phase"
  ],

  VerificationTest[
    FullSimplify[
      Exp[2 Pi I (m thetaN - nn zetaN)] /.
        {thetaN -> theta/(2 Pi), zetaN -> phi/(2 Pi), nn -> n}
    ],
    Exp[I (m theta - n phi)],
    TestID -> "gpec-algebraic-normalized-angle-kernel"
  ],

  VerificationTest[
    FullSimplify[
      Exp[-I nn zeta] /. zeta -> -helicity phi
    ],
    Exp[I helicity nn phi],
    TestID -> "gpec-native-zeta-direction-is-minus-helicity-relative-to-ccw"
  ],

  VerificationTest[
    {ipd btd /. {ipd -> -1, btd -> -1},
     ipd btd /. {ipd -> 1, btd -> -1}},
    {1, -1},
    TestID -> "iter-standard-and-aug30835-helicity-products"
  ],

  VerificationTest[
    FullSimplify[
      Exp[I (m theta - nvmec nfp (zeta + 2 Pi/nfp))] /
        Exp[I (m theta - nvmec nfp zeta)],
      Assumptions -> Element[nvmec, Integers] && nfp != 0
    ],
    1,
    TestID -> "vmec-xn-includes-nfp-field-periodicity"
  ],

  VerificationTest[
    FullSimplify[
      Exp[I ((m - ntok q) theta + ntok alpha)] /.
        alpha -> q theta - phi
    ],
    Exp[I (m theta - ntok phi)],
    TestID -> "ntvtok-field-line-label-to-house-spatial-phase"
  ],

  VerificationTest[
    FullSimplify[
      ntok omegaAlpha + lsrc omegaB /.
        {omegaAlpha -> -omegaPhi, lsrc -> ell}
    ],
    ell omegaB - ntok omegaPhi,
    TestID -> "ntvtok-source-to-house-resonance"
  ],

  VerificationTest[
    FullSimplify[
      ntok omegaAlpha + lsrc omegaB /.
        {omegaAlpha -> -omegaPhi, lsrc -> 0}
    ],
    -ntok omegaPhi,
    TestID -> "ntvtok-l0-precession-resonance"
  ],

  VerificationTest[
    Sort[-Range[-5, 5]],
    Range[-5, 5],
    TestID -> "ntvtok-l5-invariant-under-bounce-index-reversal"
  ],

  VerificationTest[
    FullSimplify[
      Exp[I (ell - n q) (xi + 2 Pi)]/Exp[I (ell - n q) xi],
      Assumptions -> Element[{ell, n}, Integers] &&
        Element[{q, xi}, Reals]
    ],
    Exp[-2 I Pi n q],
    TestID -> "passing-phase-is-not-periodic-before-factoring"
  ],

  VerificationTest[
    FullSimplify[
      Exp[I ell (xi + 2 Pi)]/Exp[I ell xi],
      Assumptions -> Element[ell, Integers] && Element[xi, Reals]
    ],
    1,
    TestID -> "integer-residual-is-periodic-after-factoring"
  ],

  VerificationTest[
    Expand[
      sigma (ell - n q) omegat + n omegaE -
        (sigma ell omegat + n omegaE)
    ],
    -sigma n q omegat,
    TestID -> "shaing-passing-resonance-correction"
  ],

  VerificationTest[
    FullSimplify[
      (eps/32)^(-1/2)/(32 eps)^(-1/2),
      Assumptions -> eps > 0
    ],
    32,
    TestID -> "shaing-2003-corrected-factor-ratio"
  ],

  VerificationTest[
    FullSimplify[
      ComplexExpand[Re[2 I n (wr + I wi)]],
      Assumptions -> Element[{n, wr, wi}, Reals]
    ],
    -2 n wi,
    TestID -> "park-complex-energy-to-real-torque"
  ],

  VerificationTest[
    FullSimplify[
      D[Sqrt[2 (eng - muP bP)/massP], bP],
      Assumptions -> massP > 0 && eng - muP bP > 0
    ],
    FullSimplify[
      -muP/(massP Sqrt[2 (eng - muP bP)/massP]),
      Assumptions -> massP > 0 && eng - muP bP > 0
    ],
    TestID -> "park-fixed-energy-vparallel-variation"
  ],

  VerificationTest[
    FullSimplify[
      D[bP Sqrt[2 (eng - muP bP)/massP], bP],
      Assumptions -> massP > 0 && eng - muP bP > 0
    ],
    FullSimplify[
      (2 eng - 3 muP bP)/
        (massP Sqrt[2 (eng - muP bP)/massP]),
      Assumptions -> massP > 0 && eng - muP bP > 0
    ],
    TestID -> "park-fixed-energy-B-vparallel-variation"
  ],

  VerificationTest[
    FullSimplify[
      massP (2 (eng - muP bP)/massP) (dBLrel + divXi) -
        muP bP dBLrel ==
          (2 eng - 3 muP bP) dBLrel +
            (2 eng - 2 muP bP) divXi
    ],
    True,
    TestID -> "park-complete-action-integrand-from-arclength-and-field"
  ],

  VerificationTest[
    FullSimplify[
      {(2 eng - 3 muP bP)/eng, (2 eng - muP bP)/eng} /.
        muP bP -> etaB eng,
      Assumptions -> eng != 0
    ],
    {2 - 3 etaB, 2 - etaB},
    TestID -> "park-and-neort-eta-weight-rosetta"
  ],

  VerificationTest[
    FullSimplify[
      (2 eng - muP bP) - (2 eng - 3 muP bP)
    ],
    2 muP bP,
    TestID -> "park-neort-isolated-weight-difference"
  ],

  VerificationTest[
    FullSimplify[
      {2 - 3 etaB, 2 - etaB} /. etaB -> 1
    ],
    {-1, 1},
    TestID -> "park-neort-isolated-weight-turning-point-signs"
  ],

  VerificationTest[
    FullSimplify[
      -D[jPark[eng, epsP], epsP]/D[jPark[eng, epsP], eng] /.
        D[jPark[eng, epsP], eng] -> 2 Pi/omegaB
    ],
    -(omegaB/(2 Pi)) D[jPark[eng, epsP], epsP],
    TestID -> "park-fixed-action-energy-from-fixed-energy-action"
  ],

  VerificationTest[
    FullSimplify[
      Exp[I ((m - n q) theta + 2 Pi ell hPark)] /.
        hPark -> -sigma theta/(2 Pi)
    ],
    Exp[I (m - n q - sigma ell) theta],
    TestID -> "park-2009-phase-factor-to-2011-orbit-phase"
  ],

  VerificationTest[
    FullSimplify[
      Exp[I 2 Pi ell (hPark + 1)]/Exp[I 2 Pi ell hPark],
      Assumptions -> Element[ell, Integers] && Element[hPark, Reals]
    ],
    1,
    TestID -> "park-phase-factor-is-closed-orbit-periodic"
  ],

  VerificationTest[
    FullSimplify[
      n vdaAvg - 2 Pi ell/taub /.
        taub -> 2 Pi/omegaB
    ],
    n vdaAvg - ell omegaB,
    TestID -> "park-phase-factor-dke-resonance-frequency"
  ],

  VerificationTest[
    FullSimplify[
      ((2 - 3 pitchB) dBLrel + (2 - 2 pitchB) divXi)/
          (2 Sqrt[1 - pitchB]) ==
        (1 - 3 pitchB/2) dBLrel/Sqrt[1 - pitchB] +
          Sqrt[1 - pitchB] divXi,
      Assumptions -> 0 <= pitchB < 1
    ],
    True,
    TestID -> "park-action-weight-to-pentrc-code-integrand"
  ],

  VerificationTest[
    FullSimplify[
      ComplexExpand[
        Re[-I k (hr + I hi) Conjugate[(hr + I hi) aa/(dd - I nu)]]/2
      ],
      Assumptions -> Element[{k, hr, hi, aa, dd, nu}, Reals]
    ],
    -(k aa nu (hr^2 + hi^2))/(2 (dd^2 + nu^2)),
    TestID -> "quasilinear-action-flux-sign"
  ],

  VerificationTest[
    FullSimplify[
      (drphi/drab) residenceFraction /. drphi -> drab,
      Assumptions -> drab != 0
    ],
    residenceFraction,
    TestID -> "fow-equal-cell-width-cancellation"
  ],

  VerificationTest[
    FullSimplify[
      (dt1 + dt2 + (taub - dt1 - dt2))/taub,
      Assumptions -> taub != 0
    ],
    1,
    TestID -> "fow-residence-partition-conservation"
  ],

  VerificationTest[
    Assuming[nu > 0,
      Integrate[nu/(x^2 + nu^2), {x, -Infinity, Infinity}]
    ],
    Pi,
    TestID -> "causal-lorentzian-normalization"
  ],

  VerificationTest[
    Assuming[a != 0 && Element[{a, b}, Reals],
      FullSimplify[
        Integrate[DiracDelta[a x + b] f[x], {x, -Infinity, Infinity},
          GenerateConditions -> False] == f[-b/a]/Abs[a]
      ]
    ],
    True,
    TestID -> "delta-chain-rule"
  ],

  VerificationTest[
    FullSimplify[
      ComplexExpand[
        Abs[h1 Exp[I ph1] + h2 Exp[I ph2] + h3 Exp[I ph3]]^2
      ] == h1^2 + h2^2 + h3^2 +
        2 h1 h2 Cos[ph1 - ph2] +
        2 h1 h3 Cos[ph1 - ph3] +
        2 h2 h3 Cos[ph2 - ph3],
      Element[{h1, h2, h3, ph1, ph2, ph3}, Reals]
    ],
    True,
    TestID -> "coherent-three-coil-cross-terms"
  ],

  VerificationTest[
    Assuming[sigma > 0,
      {sigma^2/(sigma^2 + sigma^2),
       Limit[x^2/(x^2 + sigma^2), x -> 0],
       Limit[x^2/(x^2 + sigma^2), x -> Infinity]} // FullSimplify
    ],
    {1/2, 0, 1},
    TestID -> "gpec-rational-regularizer-limits"
  ],

  VerificationTest[
    Assuming[delta > 0,
      {Limit[x/(x^2 + delta^2), x -> 0],
       Limit[x x/(x^2 + delta^2), x -> Infinity],
       FullSimplify[(x/(x^2 + delta^2) /. x -> delta)]}
    ],
    {0, 1, 1/(2 delta)},
    TestID -> "sun-2012-symmetric-displacement-fill"
  ],

  VerificationTest[
    Assuming[delta > 0,
      FullSimplify[{
        (x + delta)/(x^2 + delta^2) /. x -> delta,
        (x - delta)/(x^2 + delta^2) /. x -> -delta,
        Limit[(x + delta)/(x^2 + delta^2), x -> 0,
          Direction -> "FromAbove"],
        Limit[(x - delta)/(x^2 + delta^2), x -> 0,
          Direction -> "FromBelow"]
      }]
    ],
    {1/delta, -1/delta, 1/delta, -1/delta},
    TestID -> "sun-2015-outer-match-and-one-sided-fill"
  ],

  VerificationTest[
    Assuming[delta > 0 && x > 0,
      FullSimplify[
        (-x - delta)/((-x)^2 + delta^2) ==
          -(x + delta)/(x^2 + delta^2)
      ]
    ],
    True,
    TestID -> "sun-2015-fill-is-odd-away-from-surface"
  ],

  VerificationTest[
    FullSimplify[
      Abs[nSigned] wmn Abs[qprime]/2 > 0,
      Assumptions -> Element[nSigned, Reals] && nSigned != 0 &&
        wmn > 0 && qprime != 0
    ],
    True,
    TestID -> "sun-rational-fill-width-is-positive"
  ],

  VerificationTest[
    FullSimplify[
      Sqrt[Te/me]/Sqrt[Ti/mi],
      Assumptions -> And @@ Thread[{Te, me, Ti, mi} > 0]
    ],
    Sqrt[(Te mi)/(Ti me)],
    TestID -> "electron-ion-bounce-frequency-ratio"
  ],

  VerificationTest[
    FullSimplify[
      (Sqrt[me Te]/qe)/(Sqrt[mi Ti]/qi),
      Assumptions -> And @@ Thread[{Te, me, Ti, mi, qe, qi} > 0]
    ],
    (qi/qe) Sqrt[(me Te)/(mi Ti)],
    TestID -> "electron-ion-orbit-width-ratio"
  ],

  VerificationTest[
    FullSimplify[
      (ns qs^4/(Sqrt[ms] Ts^(3/2)))/(Sqrt[Ts/ms]),
      Assumptions -> And @@ Thread[{ns, qs, ms, Ts} > 0]
    ],
    ns qs^4/Ts^2,
    TestID -> "self-collision-normalized-mass-cancellation"
  ],

  VerificationTest[
    FullSimplify[
      epsT/(kpar q R)^2 /. kpar -> nmag/R,
      Assumptions -> And @@ Thread[{epsT, q, R, nmag} > 0]
    ],
    epsT/(nmag^2 q^2),
    TestID -> "neo2-kasilov-41-geometric-kparallel-reduction"
  ],

  VerificationTest[
    FullSimplify[
      (nu/(kpar vT))^(2/3) /. kpar -> nmag/R,
      Assumptions -> And @@ Thread[{nu, vT, R, nmag} > 0]
    ],
    (nu R/(nmag vT))^(2/3),
    TestID -> "neo2-kasilov-41-collisional-kparallel-reduction"
  ],

  VerificationTest[
    FullSimplify[
      (epsT/(nmag q)^(1/6) (nu epsT^2 R^2/DB)^(2/3)) /.
        {nu -> 1/timeDim, R -> lengthDim,
         DB -> lengthDim^2/timeDim, epsT -> 1, nmag -> 1, q -> 1},
      Assumptions -> timeDim > 0 && lengthDim > 0
    ],
    1,
    TestID -> "neo2-kasilov-42-superbanana-bound-dimensionless"
  ],

  VerificationTest[
    FullSimplify[
      (scale/(DB/16))^(2/3)/(scale/DB)^(2/3),
      Assumptions -> scale > 0 && DB > 0
    ],
    16^(2/3),
    TestID -> "neo2-bohm-one-sixteenth-bound-scaling"
  ],

  VerificationTest[
    FullSimplify[
      ((rMajor + rMinor) - (rMajor - rMinor))/
        ((rMajor + rMinor) + (rMajor - rMinor)),
      Assumptions -> rMajor > rMinor > 0
    ],
    rMinor/rMajor,
    TestID -> "neo2-local-toroidicity-circular-limit"
  ],

  VerificationTest[
    FullSimplify[
      (32 Sqrt[Pi] dens charge^4 coulLog/(3 mass^2 vT^3)) *
        (3 mass^2 vT^3/(16 Sqrt[Pi] dens charge^4 coulLog)),
      Assumptions -> And @@ Thread[
        {dens, charge, coulLog, mass, vT} > 0]
    ],
    2,
    TestID -> "neo2-kasilov-thermal-deflection-rate-times-tau"
  ],

  VerificationTest[
    FullSimplify[
      (2/tauaa)/(vT (2/(vT tauaa))),
      Assumptions -> vT > 0 && tauaa > 0
    ],
    1,
    TestID -> "neo2-collision-rate-and-collpar-definitions"
  ],

  VerificationTest[
    FullSimplify[
      {
        (nu R/(nmag vT))^(2/3),
        Sqrt[epsT nu/omegaE]
      } /. {nu -> vT collpar, omegaE -> nmag mtOverR vT},
      Assumptions -> And @@ Thread[
        {R, nmag, vT, collpar, epsT, mtOverR} > 0]
    ],
    {(collpar R/nmag)^(2/3), Sqrt[(collpar epsT)/(mtOverR nmag)]},
    TestID -> "neo2-output-variables-to-kasilov-bounds"
  ],

  VerificationTest[
    {
      Coefficient[(eps dBphi) (eps f11), eps, 1],
      Coefficient[(eps dBphi) (eps f11), eps, 2]
    },
    {0, dBphi f11},
    TestID -> "neo2-quasilinear-flux-is-second-order"
  ],

  VerificationTest[
    ComplexExpand[Re[(bc - I bs) Exp[I (m theta + nCC phi)]]],
    bc Cos[m theta + nCC phi] + bs Sin[m theta + nCC phi],
    TestID -> "neo2-cc-boozer-complex-coefficient-map"
  ],

  VerificationTest[
    FullSimplify[(deltaB/bref) (bref/B0),
      Assumptions -> bref != 0 && B0 != 0],
    deltaB/B0,
    TestID -> "neo2-reference-to-local-field-normalization"
  ],

  VerificationTest[
    FullSimplify[
      D[
        amp[theta0 + iota phi] Exp[I n phi]/
          bzero[theta0 + iota phi], phi
      ] - Exp[I n phi]/bzero[theta0 + iota phi] *
        (iota amp'[theta0 + iota phi] +
          amp[theta0 + iota phi] *
            (I n - iota bzero'[theta0 + iota phi]/
              bzero[theta0 + iota phi])),
      Assumptions -> bzero[theta0 + iota phi] != 0
    ],
    0,
    TestID -> "neo2-fieldline-local-ripple-chain-rule"
  ],

  VerificationTest[
    FullSimplify[
      (dynUnit/cmUnit^2)/(newtonUnit meterUnit/meterUnit^3) /.
        {dynUnit -> 10^-5 newtonUnit, cmUnit -> 10^-2 meterUnit}
    ],
    1/10,
    TestID -> "neo2-torque-density-cgs-to-si"
  ],

  VerificationTest[
    FullSimplify[
      (xE^(3/2) detuning - I nu0 harmonicFactor)/xE^(3/2),
      Assumptions -> xE > 0
    ],
    detuning - I nu0 harmonicFactor/xE^(3/2),
    TestID -> "marsk-energy-dependent-krook-factorization"
  ],

  VerificationTest[
    FullSimplify[
      {
        nu0 (1 + (ell/2)^2)/xE^(3/2),
        nu0/xE^(3/2),
        nu0
      } /. {xE -> 1, ell -> 0}
    ],
    {nu0, nu0, nu0},
    TestID -> "marsk-inutype-rates-at-thermal-energy-zero-harmonic"
  ],

  VerificationTest[
    FullSimplify[
      (nu0 (1 + (ell/2)^2)/xE^(3/2))/(nu0/xE^(3/2)) ==
        1 + ell^2/4,
      Assumptions -> xE > 0 && nu0 != 0
    ],
    True,
    TestID -> "marsk-inutype-one-harmonic-factor"
  ],

  VerificationTest[
    FullSimplify[
      r0^3 b0^2/(mu0 aspect^2) /. aspect -> r0/a,
      Assumptions -> r0 != 0 && a != 0 && mu0 != 0
    ],
    a^2 b0^2 r0/mu0,
    TestID -> "marsk-integrated-torque-volume-factor"
  ],

  VerificationTest[
    FullSimplify[
      (1/10 Exp[-I kr] + 4/5 + 1/10 Exp[I kr])^5 ==
        (4/5 + 1/5 Cos[kr])^5,
      Assumptions -> Element[kr, Reals]
    ],
    True,
    TestID -> "marsk-five-pass-smoothing-transfer-function"
  ],

  VerificationTest[
    FullSimplify[
      D[Sqrt[st], st] /. st -> rho^2,
      Assumptions -> rho > 0
    ],
    1/(2 rho),
    TestID -> "sergei-radial-coordinate-derivative"
  ],

  VerificationTest[
    FullSimplify[
      bs D[Sqrt[st], st] /. st -> rho^2,
      Assumptions -> rho > 0
    ],
    bs/(2 rho),
    TestID -> "sergei-contravariant-radial-field-map"
  ],

  VerificationTest[
    D[iota[rho^2], rho],
    2 rho iota'[rho^2],
    TestID -> "sergei-iota-radial-derivative-map"
  ],

  VerificationTest[
    FullSimplify[
      (4 (bs/(2 rho))/(m bphi (2 rho iotaPrime)))/
        (4 bs/(m bphi iotaPrime)),
      Assumptions -> rho > 0 && m bphi iotaPrime bs != 0
    ],
    1/(4 rho^2),
    TestID -> "sergei-separatrix-displacement-coordinate-map"
  ],

  VerificationTest[
    FullSimplify[
      Limit[
        (Sqrt[sres + xsep/2] - Sqrt[sres - xsep/2])/xsep,
        xsep -> 0
      ],
      Assumptions -> sres > 0
    ],
    1/(2 Sqrt[sres]),
    TestID -> "sergei-exact-rho-exclusion-linearization"
  ],

  VerificationTest[
    FullSimplify[
      m (iotaRes + iotaPrime ds) - n /. n -> m iotaRes
    ],
    m iotaPrime ds,
    TestID -> "sergei-mde-pole-linearization"
  ],

  VerificationTest[
    FullSimplify[
      ComplexExpand[Re[bamp Exp[I bphase] Exp[-I bphase]]],
      Assumptions -> Element[{bamp, bphase}, Reals]
    ],
    bamp,
    TestID -> "sergei-real-single-helicity-rephasing"
  ],

  VerificationTest[
    FullSimplify[
      Abs[4 bamp Exp[I bphase]/den],
      Assumptions -> bamp > 0 && Element[{bphase, den}, Reals] && den != 0
    ],
    4 bamp/Abs[den],
    TestID -> "sergei-phase-invariant-maximum-width-squared"
  ],

  VerificationTest[
    TrigFactor[bamp^2 - (bamp Cos[bphase + chi])^2],
    bamp^2 Sin[bphase + chi]^2,
    TestID -> "sergei-real-phase-global-modulus-maximum-bound"
  ],

  VerificationTest[
    FullSimplify[
      -D[ws^2/(4 ds), ds] /. ds -> ws/2,
      Assumptions -> ws > 0
    ],
    1,
    TestID -> "sergei-nonoverlap-boundary-slope"
  ],

  VerificationTest[
    FullSimplify[
      ell omegab + nCC Omegaphi /. nCC -> -n
    ],
    ell omegab - n Omegaphi,
    TestID -> "neort-cc-mode-to-house-resonance"
  ],

  VerificationTest[
    FullSimplify[
      (2 kineticEnergy/bfield - muMoment) deltaBmode /. {
        muMoment -> eta kineticEnergy,
        deltaBmode -> relativeMode bfield
      }
    ],
    kineticEnergy relativeMode (2 - eta bfield),
    TestID -> "potato-to-local-hamiltonian-weight"
  ],

  VerificationTest[
    FullSimplify[
      (m3 deltaPhi + 2 Pi m2)/taub /. {
        deltaPhi -> Omegaphi taub,
        2 Pi -> omegab taub
      },
      Assumptions -> taub != 0
    ],
    m2 omegab + m3 Omegaphi,
    TestID -> "potato-native-closure-to-frequency-identity"
  ],

  VerificationTest[
    FullSimplify[
      Abs[dxdy]/Abs[dfdx] /. dfdx -> dfdy dxdy,
      Assumptions -> Element[{dfdy, dxdy}, Reals] &&
        dfdy != 0 && dxdy != 0
    ],
    1/Abs[dfdy],
    TestID -> "delta-root-jacobian-coordinate-invariance"
  ],

  VerificationTest[
    Limit[1/slope, slope -> 0, Direction -> "FromAbove"],
    Infinity,
    TestID -> "simple-root-weight-diverges-at-tangent-root"
  ],

  VerificationTest[
    FullSimplify[
      (collScale dres Sqrt[Abs[omegaPrime]]/hamp^(3/2))/
        (dres Sqrt[Abs[omegaPrime]]/hamp^(3/2)),
      Assumptions -> collScale > 0 && dres != 0 && hamp > 0
    ],
    collScale,
    TestID -> "neort-nonlinear-D-linear-in-resonant-diffusion"
  ],

  VerificationTest[
    FullSimplify[
      (dres Sqrt[Abs[omegaPrime]]/(amp hamp)^(3/2))/
        (dres Sqrt[Abs[omegaPrime]]/hamp^(3/2)),
      Assumptions -> amp > 0 && dres != 0 && hamp > 0
    ],
    amp^(-3/2),
    TestID -> "neort-nonlinear-D-finite-amplitude-scaling"
  ],

  VerificationTest[
    FullSimplify[(qlTorque thetaCoeff dnl)/qlTorque,
      Assumptions -> qlTorque != 0],
    thetaCoeff dnl,
    TestID -> "neort-low-D-torque-below-quasilinear-plateau"
  ],

  VerificationTest[
    FullSimplify[
      (deltaPhi/taub)/(2 Pi/taub),
      Assumptions -> taub > 0
    ],
    deltaPhi/(2 Pi),
    TestID -> "kinetic-q-frequency-ratio-toroidal-advance"
  ],

  VerificationTest[
    FullSimplify[
      ell omegab - n Omegaphi /. Omegaphi -> qkin omegab
    ],
    omegab (ell - n qkin),
    TestID -> "house-static-resonance-kinetic-q-factorization"
  ],

  VerificationTest[
    FullSimplify[
      nK Omegaphi + kK omegab - omega /. {nK -> -n, kK -> ell}
    ],
    ell omegab - n Omegaphi - omega,
    TestID -> "kominis-plus-n-phase-to-house-resonance"
  ],

  VerificationTest[
    FullSimplify[
      -kK/nK /. {nK -> -n, kK -> ell},
      Assumptions -> n != 0
    ],
    ell/n,
    TestID -> "kominis-rational-kinetic-q-to-house"
  ],

  VerificationTest[
    FullSimplify[
      deltaPhi/(2 Pi) /. deltaPhi -> -2 Pi m2/m3,
      Assumptions -> m3 != 0
    ],
    -m2/m3,
    TestID -> "potato-closure-is-rational-kinetic-q"
  ],

  VerificationTest[
    FullSimplify[
      -(dJdp /. dJdp -> -Omegaphi/omegab),
      Assumptions -> omegab != 0
    ],
    Omegaphi/omegab,
    TestID -> "kinetic-q-constant-energy-action-derivative"
  ],

  VerificationTest[
    Total[
      (LinearSolve[
          {{3/10, -1/5}, {-2/7, 4/9}},
          {{3/10, -1/5}, {-2/7, 4/9}} . {7/3, -5/4}
        ] - {7/3, -5/4})^2
    ],
    0,
    TestID -> "orbital-spectrum-three-orbit-frequency-reconstruction"
  ],

  VerificationTest[
    FullSimplify[
      D[qmin + qcurv (pp - p0)^2, pp] /. pp -> p0
    ],
    0,
    TestID -> "kinetic-shear-vanishes-at-qkin-extremum"
  ],

  VerificationTest[
    FullSimplify[
      qmin + qcurv (pp - p0)^2 /.
        pp -> p0 + Sqrt[(qrat - qmin)/qcurv],
      Assumptions -> qcurv > 0 && qrat > qmin
    ],
    qrat,
    TestID -> "kinetic-q-extremum-twin-rational-root"
  ],

  VerificationTest[
    D[ell omegab - n Omegaphi - omega, mSpatial],
    0,
    TestID -> "spatial-poloidal-mode-not-resonance-location"
  ],

  VerificationTest[
    FullSimplify[
      Sqrt[4 amp hres/shear]/Sqrt[amp hres/shear],
      Assumptions -> amp > 0 && hres > 0 && shear > 0
    ],
    2,
    TestID -> "orbit-island-width-square-root-amplitude"
  ],

  VerificationTest[
    FullSimplify[
      Transpose[Inverse[{{st, 0}, {0, sp}}]].{kth, kph} .
        ({{st, 0}, {0, sp}}.{Omth, Omph}),
      Assumptions -> st sp != 0
    ],
    kth Omth + kph Omph,
    TestID -> "angular-covector-frequency-pairing-invariant"
  ],

  VerificationTest[
    FullSimplify[
      Transpose[Inverse[{{st, 0}, {0, sp}}]].{Tth, Tph} .
        ({{st, 0}, {0, sp}}.{Omth, Omph}),
      Assumptions -> st sp != 0
    ],
    Tth Omth + Tph Omph,
    TestID -> "generalized-torque-power-pairing-invariant"
  ],

  VerificationTest[
    FullSimplify[(sp q)/st /. {st -> 1, sp -> -1}],
    -q,
    TestID -> "q-reverses-for-toroidal-only-angle-reversal"
  ],

  VerificationTest[
    FullSimplify[(sp q)/st /. {st -> -1, sp -> -1}],
    q,
    TestID -> "q-invariant-for-simultaneous-angle-reversal"
  ],

  VerificationTest[
    FullSimplify[
      phiPrime - qPrime thetaPrime /.
        {phiPrime -> -phi, thetaPrime -> theta, qPrime -> -q}
    ],
    -(phi - q theta),
    TestID -> "field-line-label-reverses-with-toroidal-angle-and-q"
  ],

  VerificationTest[
    D[-alphaE[t], t] /. Derivative[1][alphaE][t] -> OmegaE,
    -OmegaE,
    TestID -> "electric-field-line-label-frequency-reverses"
  ],

  VerificationTest[
    D[-alphaB[t], t] /. Derivative[1][alphaB][t] -> OmegaB,
    -OmegaB,
    TestID -> "magnetic-field-line-label-frequency-reverses"
  ],

  VerificationTest[
    FullSimplify[
      (-ncc) ((-OmegaE) + (-OmegaB))
    ],
    ncc (OmegaE + OmegaB),
    TestID -> "precession-resonance-invariant-under-complete-coordinate-map"
  ],

  VerificationTest[
    FullSimplify[
      ncc (OmegaECopied - OmegaB) - ncc (-OmegaE - OmegaB) /.
        OmegaECopied -> OmegaE
    ],
    2 ncc OmegaE,
    TestID -> "copied-electric-component-interface-error"
  ],

  VerificationTest[
    FullSimplify[
      Exp[I (m theta + rntor phiM)] /.
        {theta -> -thetaH, phiM -> -phiH}
    ],
    Exp[-I (m thetaH + rntor phiH)],
    TestID -> "conditional-cocos2-to-house-complete-phase-reversal"
  ],

  VerificationTest[
    FullSimplify[
      ComplexExpand[Re[(ar + I ai) Exp[-I phase]] -
        Re[(ar - I ai) Exp[I phase]]],
      Assumptions -> Element[{ar, ai, phase}, Reals]
    ],
    0,
    TestID -> "complete-phase-reversal-requires-coefficient-conjugation"
  ],

  VerificationTest[
    FullSimplify[
      {phi11, theta11, psi11, f11, ip11, bt11, q11} /.
        {phi11 -> -phi2, theta11 -> -theta2,
         psi11 -> -2 Pi psi2, f11 -> -f2,
         ip11 -> -ip2, bt11 -> -bt2, q11 -> q2}
    ],
    {-phi2, -theta2, -2 Pi psi2, -f2, -ip2, -bt2, q2},
    TestID -> "conditional-cocos2-to-cocos11-component-map"
  ],

  VerificationTest[
    FullSimplify[{
      (-1) dpsiZ2/R,
      -(-1) dpsiR2/R
    } - {
      (+1) (-2 Pi dpsiZ2)/(2 Pi R),
      -(+1) (-2 Pi dpsiR2)/(2 Pi R)
    }, Assumptions -> R != 0],
    {0, 0},
    TestID -> "cocos2-to-cocos11-cylindrical-poloidal-field-invariant"
  ],

  VerificationTest[
    FullSimplify[(-f2) (-ephi2) - f2 ephi2],
    0,
    TestID -> "cocos2-to-cocos11-toroidal-field-vector-invariant"
  ],

  VerificationTest[
    {
      Sign[0.0 - (-11.88279543)]/Sign[15563912.65],
      Sign[1.0]/(Sign[15563912.65] Sign[5.3])
    },
    {1, 1},
    TestID -> "tc24-ngfile-stored-signs-classify-cocos1"
  ],

  VerificationTest[
    {
      Sign[0.2993264352 - 12.22885744]/Sign[15000000.0],
      Sign[1.0]/(Sign[15000000.0] Sign[5.3])
    },
    {-1, 1},
    TestID -> "tc24-jintrac-header-flux-q-subtuple-selects-cocos7"
  ],

  VerificationTest[
    {
      Sign[-0.006109690776 - 0.1782056308]/Sign[801280.0889],
      Sign[-1.0]/(Sign[801280.0889] Sign[-1.707627383])
    },
    {-1, 1},
    TestID -> "aug30835-stored-signs-classify-cocos7"
  ],

  VerificationTest[
    FullSimplify[SignDeltaPsi/sigmaBp /. {SignDeltaPsi -> 1, sigmaBp -> -1}],
    -1,
    TestID -> "libneo-opposite-poloidal-field-formula-implies-negative-current"
  ],

  VerificationTest[
    FullSimplify[
      SignIp SignBt sigmaRho /.
        {SignIp -> -1, SignBt -> 1, sigmaRho -> -1}
    ],
    1,
    TestID -> "libneo-effective-cocos3-field-retains-positive-q"
  ],

  VerificationTest[
    FullSimplify[
      D[fFlux[psiPrime/a], psiPrime],
      Assumptions -> a != 0
    ],
    fFlux'[psiPrime/a]/a,
    TestID -> "signed-flux-derivative-covector-scaling"
  ],

  VerificationTest[
    FullSimplify[
      c Er/(iota sqrtgBphi) /.
        {Er -> sr Er0, iota -> si iota0,
         sqrtgBphi -> sb sqrtgBphi0}
    ],
    c Er0 sr/(iota0 si sqrtgBphi0 sb),
    TestID -> "neo2-electric-frequency-retains-all-signed-factors"
  ],

  VerificationTest[
    FullSimplify[
      ellEff omegab + nn (omegaE + omegaD x) /.
        {ellEff -> -ellEff0, omegab -> -omegab0,
         nn -> -nn0, omegaE -> -omegaE0, omegaD -> -omegaD0}
    ],
    ellEff0 omegab0 + nn0 (omegaE0 + omegaD0 x),
    TestID -> "pentrc-resonance-scalar-complete-reversal"
  ],

  VerificationTest[
    ellEff /. ellEff -> ell + nn q,
    ell + nn q,
    TestID -> "pentrc-current-source-passing-effective-harmonic-is-ell-plus-nq"
  ],

  VerificationTest[
    FullSimplify[
      (-helicity) ipd /. helicity -> ipd btd,
      Assumptions -> ipd^2 == 1
    ],
    -btd,
    TestID -> "gpec-positive-zeta-relative-to-current-depends-on-bt-not-helicity-alone"
  ],

  VerificationTest[
    FullSimplify[Tccw /. Tccw -> -helicity Tzeta],
    -helicity Tzeta,
    TestID -> "gpec-native-zeta-torque-to-ccw-cylindrical-component"
  ],

  VerificationTest[
    FullSimplify[
      -dpsiDr chargeFluxTotal / c /.
        {dpsiDr -> 1, chargeFluxTotal -> radialCurrent}
    ],
    -radialCurrent/c,
    TestID -> "ntvtok-published-flux-force-sign-under-house-conditional-map"
  ],

  VerificationTest[
    Sort[-Range[-7, 7]],
    Range[-7, 7],
    TestID -> "symmetric-bounce-harmonic-family-orientation-invariant"
  ],

  VerificationTest[
    FullSimplify[
      ncc (OmegaE + OmegaB) == 0,
      Assumptions -> ncc != 0
    ],
    OmegaE + OmegaB == 0,
    TestID -> "l0-root-independent-of-toroidal-harmonic-sign"
  ],

  VerificationTest[
    FullSimplify[
      R fphi /. fphi -> Tphi/R
    ],
    Tphi,
    TestID -> "ccw-cylindrical-torque-is-R-times-toroidal-force"
  ],

  VerificationTest[
    FullSimplify[
      Tnative /. Tnative -> -Tccw
    ],
    -Tccw,
    TestID -> "clockwise-native-torque-opposes-ccw-physical-component"
  ],

  VerificationTest[
    MapThread[
      {#1, #2, #1, #2} &,
      {{1, 1, -1, -1, 1, 1, -1, -1},
       {1, 1, -1, -1, -1, -1, 1, 1}}
    ],
    {{1, 1, 1, 1}, {1, 1, 1, 1},
     {-1, -1, -1, -1}, {-1, -1, -1, -1},
     {1, -1, 1, -1}, {1, -1, 1, -1},
     {-1, 1, -1, 1}, {-1, 1, -1, 1}},
    TestID -> "cocos-eight-row-sigmaBp-sigmaRho-sign-table"
  ],

  VerificationTest[
    FullSimplify[
      D[pProfile[-psiPrime], psiPrime]
    ],
    -pProfile'[-psiPrime],
    TestID -> "flux-reversal-requires-pprime-reversal"
  ],

  VerificationTest[
    FullSimplify[
      D[fProfile[-psiPrime]^2/2, psiPrime]
    ],
    -fProfile[-psiPrime] fProfile'[-psiPrime],
    TestID -> "flux-reversal-requires-ffprim-reversal"
  ],

  VerificationTest[
    FullSimplify[(-deltaStarPsi)/sourcePsi /. deltaStarPsi -> sourcePsi,
      Assumptions -> sourcePsi != 0],
    -1,
    TestID -> "partial-psi-flip-with-unflipped-gs-source-gives-negative-prefactor"
  ],

  VerificationTest[
    FullSimplify[
      (D[-psiZ[z]/r, z] - D[psiR[r]/r, r]) /
        (D[psiZ[z]/r, z] - D[-psiR[r]/r, r]),
      Assumptions -> r != 0 &&
        D[psiZ[z]/r, z] - D[-psiR[r]/r, r] != 0
    ],
    -1,
    TestID -> "libneo-poloidal-field-reversal-flips-cylindrical-jphi"
  ],

  VerificationTest[
    Cross[{Er, 0, 0}, {0, Bphi, Bz}],
    {0, -Er Bz, Er Bphi},
    TestID -> "cylindrical-exb-components-at-outboard-midplane"
  ],

  VerificationTest[
    Cross[{Rmajor, 0, 0}, {fR, fphi, fZ}],
    {0, -Rmajor fZ, Rmajor fphi},
    TestID -> "cylindrical-force-moment-about-upward-axis"
  ],

  VerificationTest[
    FullSimplify[
      {pPhiPrime, APhiPrime, bPhiPrime} /.
        {pPhiPrime -> -pPhi, APhiPrime -> -APhi,
         bPhiPrime -> -bPhi}
    ],
    {-pPhi, -APhi, -bPhi},
    TestID -> "canonical-toroidal-covectors-reverse-with-toroidal-angle"
  ]
};

report = TestReport[tests];
Print[report];
passed = Length[report["TestsSucceeded"]];
failed = Length[report["TestsFailedWrongResults"]] +
  Length[report["TestsFailedWithMessages"]] +
  Length[report["TestsFailedWithErrors"]];
Print["Tests passed: ", passed, "/", passed + failed];
Exit[If[failed == 0, 0, 1]];
