(* Signed-Jacobian flux-coordinate identities for both chart orientations. *)

ClearAll["Global`*"];

eps[i_, j_, k_] := Signature[{i, j, k}];

(* Explicit torus with the house poloidal angle increasing downward at the
   outboard midplane. sigmaTheta and sigmaZeta relabel the native angles. *)
xmap[r_, theta_, zeta_, sigmaTheta_, sigmaZeta_] := Module[
  {th = sigmaTheta theta, ph = sigmaZeta zeta, rr},
  rr = rMajor + r Cos[th];
  {rr Cos[ph], rr Sin[ph], -r Sin[th]}
];

vars = {r, theta, zeta};
jac[sigmaTheta_, sigmaZeta_] :=
  Det[Transpose[Table[D[xmap[r, theta, zeta, sigmaTheta, sigmaZeta], u], {u, vars}]]];

tests = Flatten@Table[
  Module[{x, e, recip, js, jv, bp, bt, bHouse, bNative, bcontra, qNative,
          psiPnative, psiTnative, phaseNative},
    x = xmap[r, theta, zeta, st, sz];
    e = Transpose[Table[D[x, u], {u, vars}]];
    recip = Inverse[e];
    js = Simplify[Det[e], Assumptions -> {r > 0, rMajor + r Cos[st theta] > 0}];
    jv = Simplify[Sqrt[Det[Transpose[e].e]],
      Assumptions -> {r > 0, rMajor + r Cos[st theta] > 0}];
    bp = psiP'[r]; bt = psiT'[r];
    bHouse = Cross[sz recip[[3]], bp recip[[1]]] +
      Cross[bt recip[[1]], st recip[[2]]];
    psiPnative = sz psiP[r];
    psiTnative = st psiT[r];
    bNative = Cross[recip[[3]], D[psiPnative, r] recip[[1]]] +
      Cross[D[psiTnative, r] recip[[1]], recip[[2]]];
    bcontra = Simplify[recip.bNative,
      Assumptions -> {r > 0, rMajor + r Cos[st theta] > 0}];
    qNative = Simplify[bcontra[[3]]/bcontra[[2]]];
    phaseNative = (st m) (st theta) - (sz n) (sz zeta);
    {
      VerificationTest[Simplify[js/jv], st sz,
        TestID -> StringTemplate["signed-over-volume-J-`1`-`2`"][st, sz]],
      VerificationTest[Simplify[Cross[e[[All, 1]], e[[All, 2]]] - js recip[[3]]],
        {0, 0, 0}, TestID -> StringTemplate["basis-cross-`1`-`2`"][st, sz]],
      VerificationTest[Simplify[bNative - bHouse], {0, 0, 0},
        TestID -> StringTemplate["complementary-flux-signs-`1`-`2`"][st, sz]],
      VerificationTest[Simplify[qNative], st/sz psiT'[r]/psiP'[r],
        TestID -> StringTemplate["q-angle-transform-`1`-`2`"][st, sz]],
      VerificationTest[Simplify[phaseNative], m theta - n zeta,
        TestID -> StringTemplate["fourier-covector-`1`-`2`"][st, sz]],
      VerificationTest[
        Simplify[{st torqueTheta, sz torqueZeta}.{st omegaTheta, sz omegaZeta}],
        torqueTheta omegaTheta + torqueZeta omegaZeta,
        TestID -> StringTemplate["power-invariant-`1`-`2`"][st, sz]]
    }
  ],
  {st, {-1, 1}}, {sz, {-1, 1}}
];

(* CHEASE internal COCOS 2 to the house/ITER COCOS 11.  CHEASE uses
   theta_CH counter-clockwise in (R,Z) and phi_CH clockwise from +Z, so both
   angles are negatives of the house angles used by xmap. *)
xChease[r_, thetaCH_, phiCH_] := {
  (rMajor + r Cos[thetaCH]) Cos[-phiCH],
  (rMajor + r Cos[thetaCH]) Sin[-phiCH],
  zAxis + r Sin[thetaCH]
};

cheaseTests = {
  VerificationTest[
    FullSimplify[
      Det[Transpose[Table[D[xChease[r, thetaCH, phiCH], u],
        {u, {r, thetaCH, phiCH}}]]],
      Assumptions -> {r > 0, rMajor + r Cos[thetaCH] > 0}],
    r (rMajor + r Cos[thetaCH]),
    TestID -> "chease-cocos2-flux-chart-is-right-handed"
  ],
  VerificationTest[
    FullSimplify[
      {-dPsiZ/R, -fCH/R, dPsiR/R} -
      {(-2 Pi dPsiZ)/(2 Pi R), (-fCH)/R,
        -(-2 Pi dPsiR)/(2 Pi R)},
      Assumptions -> R > 0],
    {0, 0, 0},
    TestID -> "chease-cocos2-to-11-preserves-cartesian-B"
  ],
  VerificationTest[
    FullSimplify[D[pFun[-psi11/(2 Pi)], psi11]],
    -pFun'[-psi11/(2 Pi)]/(2 Pi),
    TestID -> "chease-cocos2-to-11-pprime-chain-rule"
  ],
  VerificationTest[
    FullSimplify[D[fFun[-psi11/(2 Pi)]^2/2, psi11]],
    -fFun[-psi11/(2 Pi)] fFun'[-psi11/(2 Pi)]/(2 Pi),
    TestID -> "chease-cocos2-to-11-ffprime-chain-rule"
  ],
  VerificationTest[
    FullSimplify[(-torquePhiC) (-omegaPhiC)],
    torquePhiC omegaPhiC,
    TestID -> "chease-clockwise-toroidal-power-is-coordinate-invariant"
  ],
  VerificationTest[
    Det[DiagonalMatrix[{1, -1, -1}]],
    1,
    TestID -> "chease-cocos2-to-11-outward-radial-chart-remains-right-handed"
  ],
  VerificationTest[
    Det[DiagonalMatrix[{-1, -1, -1}]],
    -1,
    TestID -> "chease-same-field-cocos11-full-flux-jacobian-is-negative"
  ],
  VerificationTest[
    Cross[{1, 0, 0}, {0, 0, 1}],
    {0, -1, 0},
    TestID -> "chease-ccw-RZ-ampere-loop-normal-is-native-plus-phi"
  ]
};

(* Independent CHEASE output signs are component labels in the requested
   COCOS-11 chart.  Relative to the unconditional positive COCOS-2 file, the
   laboratory poloidal field/current factor is -SIGNIPXP and the laboratory
   toroidal-field factor is -SIGNB0XP. *)
cheaseQuadrantTests = Flatten[
  Table[
    {
      VerificationTest[
        FullSimplify[
          {ipSign dPsiZ/R, bSign fCH/R, -ipSign dPsiR/R} -
            DiagonalMatrix[{-ipSign, -bSign, -ipSign}].
              {-dPsiZ/R, -fCH/R, dPsiR/R},
          Assumptions -> R > 0],
        {0, 0, 0},
        TestID -> StringTemplate["chease-cocos11-cartesian-quadrant-ip`1`-b`2`"][
          ipSign, bSign]
      ],
      VerificationTest[
        FullSimplify[
          {
            D[pFun[psi11/(ipSign 2 Pi)], psi11],
            D[fFun[psi11/(ipSign 2 Pi)]^2/2, psi11],
            ipSign bSign qCH,
            ipSign currentCH,
            bSign fCH
          } - {
            ipSign pFun'[psi11/(ipSign 2 Pi)]/(2 Pi),
            ipSign fFun[psi11/(ipSign 2 Pi)]
              fFun'[psi11/(ipSign 2 Pi)]/(2 Pi),
            ipSign bSign qCH,
            ipSign currentCH,
            bSign fCH
          }],
        {0, 0, 0, 0, 0},
        TestID -> StringTemplate["chease-cocos11-tuple-quadrant-ip`1`-b`2`"][
          ipSign, bSign]
      ],
      VerificationTest[
        FullSimplify[
          (ipSign bSign qCH) (ipSign dPsiCH) - bSign qCH dPsiCH],
        0,
        TestID -> StringTemplate[
          "chease-cocos11-toroidal-flux-quadrant-ip`1`-b`2`"][
          ipSign, bSign]
      ]
    },
    {ipSign, {-1, 1}}, {bSign, {-1, 1}}
  ]
];

(* STELLOPT's bundled classic NEO.  This is the effective-ripple code, not
   NEO-2 or NEO-RT.  Its native Fourier kernel uses m theta_B-n phi_B and
   reconstructs the standard cylindrical angle from the booz_xform shift. *)
xNeo[r_, thetaB_, phiB_] := {
  (rMajor + r Cos[thetaB]) Cos[phiB],
  (rMajor + r Cos[thetaB]) Sin[phiB],
  zAxis + r Sin[thetaB]
};

stelloptNeoTests = Module[
  {x = xNeo[r, thetaB, phiB], er, et, ep, jNeo, bNeo, iNeo, gNeo,
   bSquared},
  er = D[x, r]; et = D[x, thetaB]; ep = D[x, phiB];
  jNeo = FullSimplify[Det[Transpose[{er, et, ep}]],
    Assumptions -> {r > 0, rMajor + r Cos[thetaB] > 0}];
  bNeo = (iotaNeo et + ep)/jNeo;
  iNeo = FullSimplify[bNeo.et];
  gNeo = FullSimplify[bNeo.ep];
  bSquared = FullSimplify[bNeo.bNeo];
  {
    VerificationTest[
      FullSimplify[
        Cos[m thetaB] Cos[n phiB] + Sin[m thetaB] Sin[n phiB] -
          Cos[m thetaB - n phiB]],
      0,
      TestID -> "stellopt-neo-native-fourier-kernel-is-mtheta-minus-nphi"
    ],
    VerificationTest[
      FullSimplify[phiB + (2 Pi/nfp) (-nfp pmns/(2 Pi))],
      phiB - pmns,
      TestID -> "stellopt-neo-booz-xform-shift-reconstructs-cylindrical-phi"
    ],
    VerificationTest[
      FullSimplify[
        Det[{{et.et, et.ep}, {ep.et, ep.ep}}],
        Assumptions -> {r > 0, rMajor + r Cos[thetaB] > 0}],
      r^2 (rMajor + r Cos[thetaB])^2,
      TestID -> "stellopt-neo-native-surface-metric-matches-cartesian-embedding"
    ],
    VerificationTest[
      FullSimplify[bSquared/(gNeo + iotaNeo iNeo) - 1/jNeo,
        Assumptions -> {r > 0, rMajor + r Cos[thetaB] > 0}],
      0,
      TestID -> "stellopt-neo-reciprocal-jacobian-is-B2-over-G-plus-iota-I"
    ],
    VerificationTest[
      FullSimplify[
        D[b0 + bh Cos[m thetaB - n phiB], phiB] +
          iotaNeo D[b0 + bh Cos[m thetaB - n phiB], thetaB] -
          bh (n - iotaNeo m) Sin[m thetaB - n phiB]],
      0,
      TestID -> "stellopt-neo-parallel-B-derivative-has-native-phase-sign"
    ]
  }
];

(* FIRM3D/CATAPULT.  Its VMEC/booz_xform adapter deliberately defines the
   toroidal-flux-per-radian coordinate with the opposite sign to bx.phi.  The
   resulting normalized (s,theta_B,zeta_B) chart may therefore have negative
   signed Jacobian even though the volume element is positive. *)
xFirm[s_, thetaB_, zetaB_] := {
  (rMajor + a Sqrt[s] Cos[thetaB]) Cos[zetaB],
  (rMajor + a Sqrt[s] Cos[thetaB]) Sin[zetaB],
  a Sqrt[s] Sin[thetaB]
};

firm3dTests = Module[
  {x = xFirm[s, thetaB, zetaB], es, et, ez, js, phase, phiWave,
   alphaWave, bDotGradPhi, drift, streaming},
  es = D[x, s]; et = D[x, thetaB]; ez = D[x, zetaB];
  js = FullSimplify[Det[Transpose[{es, et, ez}]],
    Assumptions -> {s > 0, a > 0, rMajor + a Sqrt[s] Cos[thetaB] > 0}];
  phase = m thetaB - n zetaB + omega time + phase0;
  phiWave = phiHat Sin[phase];
  alphaWave = -phiWave (iotaNeo m - n)/(omega (gFirm + iotaNeo iFirm));
  bDotGradPhi = bFirm^2/(gFirm + iotaNeo iFirm) *
    (iotaNeo D[phiWave, thetaB] + D[phiWave, zetaB]);
  drift[q_] = -bTheta hPrime/(q psi0Firm);
  streaming[v_] = v bFirm/gFirm;
  {
    VerificationTest[
      js,
      -a^2 (rMajor + a Sqrt[s] Cos[thetaB])/2,
      TestID -> "firm3d-normalized-boozer-chart-can-have-negative-signed-J"
    ],
    VerificationTest[
      FullSimplify[D[Cos[m thetaB - n zetaB], {thetaB, 1}] +
        m Sin[m thetaB - n zetaB]],
      0,
      TestID -> "firm3d-equilibrium-fourier-poloidal-derivative-sign"
    ],
    VerificationTest[
      FullSimplify[D[Cos[m thetaB - n zetaB], {zetaB, 1}] -
        n Sin[m thetaB - n zetaB]],
      0,
      TestID -> "firm3d-equilibrium-fourier-toroidal-derivative-sign"
    ],
    VerificationTest[
      FullSimplify[bDotGradPhi + bFirm^2 D[alphaWave, time]],
      0,
      TestID -> "firm3d-wave-alpha-sign-satisfies-ideal-ohm-law"
    ],
    VerificationTest[
      FullSimplify[{drift[-q], streaming[v]} - {-drift[q], streaming[v]}],
      {0, 0},
      TestID -> "firm3d-charge-reversal-flips-drift-not-streaming"
    ],
    VerificationTest[
      FullSimplify[D[psi0Firm (iota0 s + iota1 s^2/2), s]/psi0Firm],
      iota0 + iota1 s,
      TestID -> "firm3d-poloidal-flux-derivative-is-iota"
    ]
  }
];

(* SIMSOPT is an interface graph.  Its Cartesian surface chart is ordered
   (u_phi,u_theta), while SPEC normal-field coefficients use the opposite
   oriented surface element.  Its current VMEC/Boozer adapter also supplies a
   positive psi0 where the signed Cartesian map requires a negative one. *)
xSims[uPhi_, uTheta_] := {
  (rMajor + a Cos[2 Pi uTheta]) Cos[2 Pi uPhi],
  (rMajor + a Cos[2 Pi uTheta]) Sin[2 Pi uPhi],
  a Sin[2 Pi uTheta]
};

simsoptTests = Module[
  {x = xSims[uPhi, uTheta], ePhi, eTheta, nSims, nSpec,
   chiPerRad, psiCurrent, psiCorrected, phaseSims},
  ePhi = D[x, uPhi]; eTheta = D[x, uTheta];
  nSims = FullSimplify[Cross[ePhi, eTheta]];
  nSpec = FullSimplify[Cross[eTheta, ePhi]];
  chiPerRad = -iotaNeo phiEdge s/(2 Pi);
  psiCurrent = phiEdge s/(2 Pi);
  psiCorrected = -phiEdge s/(2 Pi);
  phaseSims = m thetaB - n nfp zetaB;
  {
    VerificationTest[
      FullSimplify[nSims /. {uPhi -> 0, uTheta -> 0},
        Assumptions -> {a > 0, rMajor + a > 0}],
      {4 Pi^2 a (rMajor + a), 0, 0},
      TestID -> "simsopt-surface-normal-is-uphi-cross-utheta-and-outward"
    ],
    VerificationTest[
      FullSimplify[nSpec + nSims],
      {0, 0, 0},
      TestID -> "simsopt-spec-normal-field-area-vector-is-opposite-surface-normal"
    ],
    VerificationTest[
      FullSimplify[D[Cos[phaseSims], thetaB] + m Sin[phaseSims]],
      0,
      TestID -> "simsopt-surface-and-spec-fourier-poloidal-sign"
    ],
    VerificationTest[
      FullSimplify[D[Cos[phaseSims], zetaB] - n nfp Sin[phaseSims]],
      0,
      TestID -> "simsopt-surface-and-spec-fourier-toroidal-sign"
    ],
    VerificationTest[
      FullSimplify[D[chiPerRad, s]/D[psiCurrent, s]],
      -iotaNeo,
      TestID -> "simsopt-current-positive-psi0-gives-minus-iota"
    ],
    VerificationTest[
      FullSimplify[D[chiPerRad, s]/D[psiCorrected, s]],
      iotaNeo,
      TestID -> "simsopt-corrected-negative-psi0-gives-plus-iota"
    ],
    VerificationTest[
      FullSimplify[Cross[{vX, 0, 0}, {0, bY, 0}] q/massParticle],
      {0, 0, bY q vX/massParticle},
      TestID -> "simsopt-full-orbit-lorentz-sign-is-q-v-cross-B"
    ]
  }
];

(* SPECTRE's toroidal geometry is ordered (s,theta,zeta), with zeta equal to
   the physical CCW cylindrical angle.  Its positive-J requirement therefore
   selects the house poloidal sense Z=-r sin(theta).  A_theta and A_zeta are
   covariant one-form components in the A_s=0 gauge. *)
rSpectre[s_] := rInner + (s + 1) (rOuter - rInner)/2;
xSpectre[s_, thetaS_, zetaS_] := {
  (rMajor + rSpectre[s] Cos[thetaS]) Cos[zetaS],
  (rMajor + rSpectre[s] Cos[thetaS]) Sin[zetaS],
  -rSpectre[s] Sin[thetaS]
};

spectreTests = Module[
  {x = xSpectre[s, thetaS, zetaS], es, et, ez, jS, alphaS,
   aTheta, aZeta, curlNumerators, phaseVmec},
  es = D[x, s]; et = D[x, thetaS]; ez = D[x, zetaS];
  jS = FullSimplify[Det[Transpose[{es, et, ez}]],
    Assumptions -> {rOuter > rInner > 0,
      rMajor + rSpectre[s] Cos[thetaS] > 0}];
  alphaS = m thetaS - nRed nfp zetaS;
  aTheta = ate[s] Cos[alphaS];
  aZeta = aze[s] Cos[alphaS];
  curlNumerators = {
    D[aZeta, thetaS] - D[aTheta, zetaS],
    -D[aZeta, s],
    D[aTheta, s]
  };
  phaseVmec = (m thetaS - (-nRed) nfp zetaS) /.
    thetaS -> -thetaVmec;
  {
    VerificationTest[
      FullSimplify[jS - (rOuter - rInner) rSpectre[s]
        (rMajor + rSpectre[s] Cos[thetaS])/2,
        Assumptions -> {rOuter > rInner > 0,
          rMajor + rSpectre[s] Cos[thetaS] > 0}],
      0,
      TestID -> "spectre-positive-jacobian-selects-house-poloidal-angle"
    ],
    VerificationTest[
      FullSimplify[curlNumerators -
      {-(m aze[s] + nRed nfp ate[s]) Sin[alphaS],
         -aze'[s] Cos[alphaS], ate'[s] Cos[alphaS]}],
      {0, 0, 0},
      TestID -> "spectre-As-zero-covariant-vector-potential-curl"
    ],
    VerificationTest[
      FullSimplify[
        Exp[I (alphaS /. zetaS -> zetaS + 2 Pi/nfp)] - Exp[I alphaS],
        Assumptions -> Element[nRed, Integers]],
      0,
      TestID -> "spectre-reduced-n-is-periodic-over-one-field-period"
    ],
    VerificationTest[
      FullSimplify[
        Integrate[ateOuter - ateInner, {thetaLoop, 0, 2 Pi}]/(2 Pi)],
      ateOuter - ateInner,
      TestID -> "spectre-toroidal-full-flux-over-two-pi-is-delta-Atheta"
    ],
    VerificationTest[
      FullSimplify[
        -Integrate[azeOuter - azeInner, {zetaLoop, 0, 2 Pi}]/(2 Pi)],
      -(azeOuter - azeInner),
      TestID -> "spectre-poloidal-full-flux-over-two-pi-is-minus-delta-Azeta"
    ],
    VerificationTest[
      FullSimplify[phaseVmec + (m thetaVmec - nRed nfp zetaS)],
      0,
      TestID -> "spectre-vmec-theta-and-mode-map-is-full-phase-conjugation"
    ],
    VerificationTest[
      FullSimplify[
        (bContravZeta ez).{-Sin[zetaS], Cos[zetaS], 0} -
          (rMajor + rSpectre[s] Cos[thetaS]) bContravZeta],
      0,
      TestID -> "spectre-physical-Bphi-is-R-times-contravariant-Bzeta"
    ]
  }
];

(* Legacy SPEC is tested independently of SPECTRE.  For Igeometry=3 it uses
   the physical CCW cylindrical zeta and the same positive-J toroidal chart,
   but it has its own Fortran evaluator, flux constraints, field-line solver,
   and HDF5 output contract. *)
rSpec[s_] := rInner + (s + 1) (rOuter - rInner)/2;
xSpec[s_, thetaOld_, zetaOld_] := {
  (rMajor + rSpec[s] Cos[thetaOld]) Cos[zetaOld],
  (rMajor + rSpec[s] Cos[thetaOld]) Sin[zetaOld],
  -rSpec[s] Sin[thetaOld]
};

specTests = Module[
  {x = xSpec[s, thetaOld, zetaOld], es, et, ez, jOld, alphaOld,
   aThetaOld, aZetaOld, curlOld, poincareVector},
  es = D[x, s]; et = D[x, thetaOld]; ez = D[x, zetaOld];
  jOld = FullSimplify[Det[Transpose[{es, et, ez}]],
    Assumptions -> {rOuter > rInner > 0,
      rMajor + rSpec[s] Cos[thetaOld] > 0}];
  alphaOld = m thetaOld - nRed nfp zetaOld;
  aThetaOld = ateOld[s] Cos[alphaOld];
  aZetaOld = azeOld[s] Cos[alphaOld];
  curlOld = {
    D[aZetaOld, thetaOld] - D[aThetaOld, zetaOld],
    -D[aZetaOld, s],
    D[aThetaOld, s]
  };
  poincareVector = {bSpecS/bSpecZeta, bSpecTheta/bSpecZeta};
  {
    VerificationTest[
      FullSimplify[jOld - (rOuter - rInner) rSpec[s]
        (rMajor + rSpec[s] Cos[thetaOld])/2,
        Assumptions -> {rOuter > rInner > 0,
          rMajor + rSpec[s] Cos[thetaOld] > 0}],
      0,
      TestID -> "spec-positive-jacobian-selects-house-poloidal-angle"
    ],
    VerificationTest[
      FullSimplify[curlOld -
        {-(m azeOld[s] + nRed nfp ateOld[s]) Sin[alphaOld],
          -azeOld'[s] Cos[alphaOld], ateOld'[s] Cos[alphaOld]}],
      {0, 0, 0},
      TestID -> "spec-As-zero-covariant-vector-potential-curl"
    ],
    VerificationTest[
      FullSimplify[
        Exp[I (alphaOld /. zetaOld -> zetaOld + 2 Pi/nfp)] -
          Exp[I alphaOld],
        Assumptions -> Element[nRed, Integers]],
      0,
      TestID -> "spec-reduced-n-is-periodic-over-one-field-period"
    ],
    VerificationTest[
      FullSimplify[Integrate[ateOldOuter - ateOldInner,
        {thetaLoop, 0, 2 Pi}]/(2 Pi)],
      ateOldOuter - ateOldInner,
      TestID -> "spec-toroidal-full-flux-over-two-pi-is-delta-Atheta"
    ],
    VerificationTest[
      FullSimplify[-Integrate[azeOldOuter - azeOldInner,
        {zetaLoop, 0, 2 Pi}]/(2 Pi)],
      -(azeOldOuter - azeOldInner),
      TestID -> "spec-poloidal-ribbon-flux-over-two-pi-is-minus-delta-Azeta"
    ],
    VerificationTest[
      FullSimplify[
        (bSpecZeta ez).{-Sin[zetaOld], Cos[zetaOld], 0} -
          (rMajor + rSpec[s] Cos[thetaOld]) bSpecZeta],
      0,
      TestID -> "spec-physical-Bphi-is-R-times-contravariant-Bzeta"
    ],
    VerificationTest[
      FullSimplify[bSpecZeta poincareVector - {bSpecS, bSpecTheta}],
      {0, 0},
      TestID -> "spec-increasing-zeta-field-line-slopes"
    ],
    VerificationTest[
      FullSimplify[nfp (2 Pi/nfp) helicityDensity],
      2 Pi helicityDensity,
      TestID -> "spec-full-device-helicity-is-Nfp-times-one-period"
    ],
    VerificationTest[
      FullSimplify[Integrate[bThetaLoop rLoop,
        {thetaLoop, 0, 2 Pi}]],
      2 Pi rLoop bThetaLoop,
      TestID -> "spec-positive-theta-loop-fixes-signed-toroidal-current"
    ]
  }
];

(* M3D-C1's physical cylindrical anchor and axisymmetric magnetic
   representation.  These identities are independent of GEQDSK ingestion;
   the latter is now fixed independently by the native four-quadrant
   discriminator. *)
m3dc1Tests = Module[
  {eR, ePhi, eZ, b, divB, curlB, deltaStar, phase, bFlip, jFlip,
   psiRhat, psiZhat, iRhat, iZhat, fpRhat, fpZhat, iHat,
   bHat, jHat, sourceTorque, lorentzTorque, localTorque,
   stressTorque, rmsProduct, hermiteM3, phaseDerivativeM3,
   gradPsiM3, bSqM3, eFieldM3, vExBM3, vStarIM3,
   exbParallelM3, starParallelM3},
  eR = {Cos[phiM3], Sin[phiM3], 0};
  ePhi = {-Sin[phiM3], Cos[phiM3], 0};
  eZ = {0, 0, 1};
  b = {-D[psiM3[R, Z], Z]/R, fM3[R, Z]/R,
    D[psiM3[R, Z], R]/R};
  divB = FullSimplify[D[R b[[1]], R]/R + D[b[[3]], Z],
    Assumptions -> R > 0];
  curlB = FullSimplify[{
      -D[R b[[2]], Z]/R,
      D[b[[1]], Z] - D[b[[3]], R],
      D[R b[[2]], R]/R
    }, Assumptions -> R > 0];
  deltaStar = D[psiM3[R, Z], {R, 2}] -
    D[psiM3[R, Z], R]/R + D[psiM3[R, Z], {Z, 2}];
  phase = ampM3[R, Z] Exp[I nM3 phiM3];
  bFlip = {-D[psiM3[R, Z], Z]/R, -fM3[R, Z]/R,
    D[psiM3[R, Z], R]/R};
  jFlip = {D[psiM3[R, Z], Z]/R, fM3[R, Z]/R,
    -D[psiM3[R, Z], R]/R};
  psiRhat = psiRr + I psiRi; psiZhat = psiZr + I psiZi;
  iRhat = iRr + I iRi; iZhat = iZr + I iZi;
  fpRhat = fpRr + I fpRi; fpZhat = fpZr + I fpZi;
  iHat = iFr + I iFi;
  bHat = {-psiZhat/R - fpRhat, iHat/R,
    psiRhat/R - fpZhat};
  jHat = {(I nM3 bHat[[3]] - iZhat)/R, jPhiHat,
    (iRhat - I nM3 bHat[[1]])/R};
  sourceTorque = ComplexExpand[Re[
    psiRhat Conjugate[iZhat]/R - psiZhat Conjugate[iRhat]/R -
    fpRhat Conjugate[iRhat] - fpZhat Conjugate[iZhat]]];
  lorentzTorque = ComplexExpand[
    R Re[Cross[jHat, Conjugate[bHat]][[2]]]];
  localTorque = R (
    ((D[R bPhiFun[R, Z, phiM3], R] -
        D[bRFun[R, Z, phiM3], phiM3])/R) bRFun[R, Z, phiM3] -
    ((D[bZFun[R, Z, phiM3], phiM3] -
        D[R bPhiFun[R, Z, phiM3], Z])/R) bZFun[R, Z, phiM3]);
  stressTorque = bRFun[R, Z, phiM3] D[R bPhiFun[R, Z, phiM3], R] +
    bZFun[R, Z, phiM3] D[R bPhiFun[R, Z, phiM3], Z] -
    D[(bRFun[R, Z, phiM3]^2 + bZFun[R, Z, phiM3]^2)/2,
      phiM3];
  rmsProduct = FullSimplify[
    Integrate[
      2 Re[(uR + I uI) Exp[I phiM3]]
        Re[(vR + I vI) Exp[I phiM3]],
      {phiM3, 0, 2 Pi}]/(2 Pi),
    Element[{uR, uI, vR, vI}, Reals]];
  hermiteM3 = f0M3 + fp0M3 zM3 +
    (3 (f1M3 - f0M3)/dM3 - 2 fp0M3 - fp1M3) zM3^2/dM3 +
    (2 (f0M3 - f1M3)/dM3 + fp0M3 + fp1M3) zM3^3/dM3^2;
  phaseDerivativeM3 = ComplexExpand[
    Re[I kM3 (uR + I uI)],
    TargetFunctions -> {Re, Im}];
  gradPsiM3 = {psiRM3, 0, psiZM3};
  bSqM3 = (psiRM3^2 + psiZM3^2 + fM3c^2)/R^2;
  eFieldM3 = -phiPrimeM3 gradPsiM3;
  vExBM3 = FullSimplify[Cross[eFieldM3,
      {-psiZM3/R, fM3c/R, psiRM3/R}]/bSqM3,
    Assumptions -> {R > 0, bSqM3 != 0}];
  vStarIM3 = FullSimplify[Cross[
      {-psiZM3/R, fM3c/R, psiRM3/R}, pPrimeIM3 gradPsiM3]/
      (chargeIM3 densityIM3 bSqM3),
    Assumptions -> {R > 0, bSqM3 != 0, chargeIM3 densityIM3 != 0}];
  exbParallelM3 = -phiPrimeM3 R^2 fM3c/
    (psiRM3^2 + psiZM3^2 + fM3c^2);
  starParallelM3 = -(pPrimeIM3/(chargeIM3 densityIM3)) R^2 fM3c/
    (psiRM3^2 + psiZM3^2 + fM3c^2);
  {
    VerificationTest[
      FullSimplify[Cross[eR, ePhi] - eZ],
      {0, 0, 0},
      TestID -> "m3dc1-physical-cylindrical-basis-is-right-handed"
    ],
    VerificationTest[
      FullSimplify[D[phase, phiM3] - I nM3 phase],
      0,
      TestID -> "m3dc1-plus-phase-has-plus-i-n-toroidal-derivative"
    ],
    VerificationTest[
      FullSimplify[
        {hermiteM3 /. zM3 -> 0,
          D[hermiteM3, zM3] /. zM3 -> 0,
          hermiteM3 /. zM3 -> dM3,
          D[hermiteM3, zM3] /. zM3 -> dM3} -
        {f0M3, fp0M3, f1M3, fp1M3},
        Assumptions -> dM3 != 0],
      {0, 0, 0, 0},
      TestID -> "m3dc1-full3d-cubic-hermite-preserves-plane-values-and-derivatives"
    ],
    VerificationTest[
      FullSimplify[phaseDerivativeM3 + kM3 uI,
        Element[{kM3, uR, uI}, Reals]],
      0,
      TestID -> "m3dc1-plus-phase-derivative-at-zero-is-minus-k-imaginary-amplitude"
    ],
    VerificationTest[
      ComplexExpand[Re[(uR + I uI) Exp[I kM3 phiM3]] /. phiM3 -> 0] - uR,
      0,
      TestID -> "m3dc1-linear-complex-to-full3d-map-has-no-sqrt-two"
    ],
    VerificationTest[
      divB,
      0,
      TestID -> "m3dc1-axisymmetric-potential-field-is-divergence-free"
    ],
    VerificationTest[
      FullSimplify[curlB - {
        -D[fM3[R, Z], Z]/R,
        -deltaStar/R,
        D[fM3[R, Z], R]/R
      }, Assumptions -> R > 0],
      {0, 0, 0},
      TestID -> "m3dc1-axisymmetric-curl-fixes-all-current-signs"
    ],
    VerificationTest[
      FullSimplify[bFlip - {b[[1]], -b[[2]], b[[3]]}],
      {0, 0, 0},
      TestID -> "m3dc1-iflip-b-is-independent-toroidal-field-reversal"
    ],
    VerificationTest[
      FullSimplify[jFlip - {-b[[1]], b[[2]], -b[[3]]}],
      {0, 0, 0},
      TestID -> "m3dc1-iflip-j-is-independent-poloidal-field-reversal"
    ],
    VerificationTest[
      FullSimplify[Cross[eZ, eR] - ePhi],
      {0, 0, 0},
      TestID -> "m3dc1-clockwise-RZ-loop-has-plus-ephi-normal"
    ],
    VerificationTest[
      Table[-ipM3^2, {ipM3, {-1, 1}}],
      {-1, -1},
      TestID -> "m3dc1-default-negative-header-map-canonicalizes-internal-psi"
    ],
    VerificationTest[
      FullSimplify[{1/(nwM3 - 1), nwM3/(nwM3 - 1)} -
        {1/(nwM3 - 1), 1 + 1/(nwM3 - 1)},
        Assumptions -> nwM3 > 1],
      {0, 0},
      TestID -> "m3dc1-current-q-spline-grid-misses-zero-and-one"
    ],
    VerificationTest[
      FullSimplify[{(1 - 1)/(nwM3 - 1), (nwM3 - 1)/(nwM3 - 1)},
        Assumptions -> nwM3 > 1],
      {0, 1},
      TestID -> "m3dc1-corrected-q-spline-grid-closes-zero-and-one"
    ],
    VerificationTest[
      Table[Sign[bPhiM3/(-ipM3)] + bPhiM3 ipM3,
        {ipM3, {-1, 1}}, {bPhiM3, {-1, 1}}],
      {{0, 0}, {0, 0}},
      TestID -> "m3dc1-signed-q-is-minus-Ip-times-Bphi"
    ],
    VerificationTest[
      FullSimplify[lorentzTorque - sourceTorque,
        Assumptions -> {R > 0, Element[nM3, Reals]}],
      0,
      TestID -> "m3dc1-complex-torque-is-plus-Z-cartesian-lorentz-torque"
    ],
    VerificationTest[
      FullSimplify[localTorque - stressTorque, Assumptions -> R > 0],
      0,
      TestID -> "m3dc1-omitted-pressure-term-is-toroidal-total-derivative"
    ],
    VerificationTest[
      rmsProduct - (uR vR + uI vI),
      0,
      TestID -> "m3dc1-sqrt-two-real-reconstruction-fixes-quadratic-normalization"
    ],
    VerificationTest[
      FullSimplify[
        (fBoundary/R) (nZBoundary psiRBoundary -
            nRBoundary psiZBoundary) -
          R (fBoundary/R) ((-psiZBoundary/R) nRBoundary +
            (psiRBoundary/R) nZBoundary),
        Assumptions -> R > 0],
      0,
      TestID -> "m3dc1-boundary-torque-kernel-is-plus-Z-Maxwell-stress"
    ],
    VerificationTest[
      ComplexExpand[
        Re[((uR + I uI) Exp[I alphaM3])
            Conjugate[(vR + I vI) Exp[I alphaM3]]] -
          Re[(uR + I uI) Conjugate[vR + I vI]],
        TargetFunctions -> {Re, Im}],
      0,
      TestID -> "m3dc1-conjugated-boundary-quadratic-is-phase-origin-invariant"
    ],
    VerificationTest[
      ComplexExpand[
        Re[(1 + I) (2 - I) Exp[2 I Pi/4]] -
          Re[(1 + I) (2 - I)]],
      -4,
      TestID -> "m3dc1-current-unconjugated-boundary-scalar-is-phase-dependent-negative-control"
    ],
    VerificationTest[
      FullSimplify[
        {forceR, forcePhi, forceZ}.{0, omegaM3 R, 0} -
          omegaM3 R forcePhi],
      0,
      TestID -> "m3dc1-rigid-toroidal-lorentz-power-is-omega-times-torque"
    ],
    VerificationTest[
      FullSimplify[vExBM3 - ({0, R phiPrimeM3, 0} +
          exbParallelM3 {-psiZM3/R, fM3c/R, psiRM3/R}),
        Assumptions -> {R > 0,
          psiRM3^2 + psiZM3^2 + fM3c^2 != 0}],
      {0, 0, 0},
      TestID -> "m3dc1-ExB-nonorthogonal-toroidal-coefficient-is-plus-Phi-prime"
    ],
    VerificationTest[
      FullSimplify[vStarIM3 -
          ({0, R pPrimeIM3/(chargeIM3 densityIM3), 0} +
           starParallelM3 {-psiZM3/R, fM3c/R, psiRM3/R}),
        Assumptions -> {R > 0, chargeIM3 densityIM3 != 0,
          psiRM3^2 + psiZM3^2 + fM3c^2 != 0}],
      {0, 0, 0},
      TestID -> "m3dc1-positive-ion-diamagnetic-toroidal-coefficient-is-plus-p-prime-over-qn"
    ],
    VerificationTest[
      FullSimplify[(phiPrimeM3 + pPrimeIM3/(chargeIM3 densityIM3)) -
        (omegaExBM3 + omegaStarIM3) /.
          {omegaExBM3 -> phiPrimeM3,
           omegaStarIM3 -> pPrimeIM3/(chargeIM3 densityIM3)},
        Assumptions -> chargeIM3 densityIM3 != 0],
      0,
      TestID -> "m3dc1-ion-rotation-is-ExB-plus-ion-diamagnetic-frequency"
    ],
    VerificationTest[
      FullSimplify[Table[
        (-1)^vfM3 (omegaInputM3 - (-1)^(jfM3 + vfM3) diaTermM3) -
          ((-1)^vfM3 omegaInputM3 - (-1)^jfM3 diaTermM3),
        {jfM3, 0, 1}, {vfM3, 0, 1}]],
      {{0, 0}, {0, 0}},
      TestID -> "m3dc1-executable-iflip-quadrants-separate-input-and-diamagnetic-components"
    ],
    VerificationTest[
      FullSimplify[Table[
        (-1)^vfM3 (omegaInputM3 + (-1)^(jfM3 + vfM3) diaTermM3) -
          ((-1)^vfM3 omegaInputM3 + (-1)^jfM3 diaTermM3),
        {jfM3, 0, 1}, {vfM3, 0, 1}]],
      {{0, 0}, {0, 0}},
      TestID -> "m3dc1-corrected-iflip-quadrants-preserve-component-state-separation"
    ],
    VerificationTest[
      FullSimplify[(1/deltaPsiM3) (deltaPsiM3 pPrimePhysicalM3) -
        pPrimePhysicalM3, Assumptions -> deltaPsiM3 != 0],
      0,
      TestID -> "m3dc1-dpsii-converts-normalized-flux-profile-derivative-once"
    ]
  }
];

(* JOREK uses a clockwise toroidal angle but orders its native coordinates as
   (R,Z,phi_J).  The two reversals relative to (R,phi_CCW,Z) leave a positive
   coordinate Jacobian.  The same physical axisymmetric state in M3D-C1
   requires both magnetic potentials to reverse. *)
jorekTests = Module[
  {xJ, ePhiJ, jacJ, bJNative, bJLab, bM3Lab, phaseJ,
   phaseM3, periodJ, rotClockwise},
  xJ = {rJ Cos[phiJ], -rJ Sin[phiJ], zJ};
  ePhiJ = FullSimplify[D[xJ, phiJ]/rJ, Assumptions -> rJ > 0];
  jacJ = FullSimplify[Det[Transpose[{D[xJ, rJ], D[xJ, zJ],
      D[xJ, phiJ]}]], Assumptions -> rJ > 0];
  bJNative = {psiJZ/rJ, -psiJR/rJ, f0J/rJ};
  bJLab = {bJNative[[1]], -bJNative[[3]], bJNative[[2]]};
  bM3Lab = {-(-psiJZ)/rJ, (-f0J)/rJ, (-psiJR)/rJ};
  phaseJ = aCosJ Cos[nPhysJ phiJ] - aSinJ Sin[nPhysJ phiJ];
  phaseM3 = ComplexExpand[Re[(aCosJ - I aSinJ)
      Exp[I nPhysJ phiC]]];
  periodJ = 2 Pi/nfpJ;
  rotClockwise = {{Cos[periodJ], Sin[periodJ], 0},
    {-Sin[periodJ], Cos[periodJ], 0}, {0, 0, 1}};
  {
    VerificationTest[
      FullSimplify[(xJ /. phiJ -> -phiC) -
        {rJ Cos[phiC], rJ Sin[phiC], zJ}],
      {0, 0, 0}, TestID -> "jorek-phi-is-minus-laboratory-ccw"],
    VerificationTest[
      FullSimplify[ePhiJ + {-Sin[-phiJ], Cos[-phiJ], 0}],
      {0, 0, 0}, TestID -> "jorek-toroidal-unit-is-minus-ccw-unit"],
    VerificationTest[jacJ, rJ,
      TestID -> "jorek-R-Z-phi-chart-has-positive-jacobian"],
    VerificationTest[
      FullSimplify[bJLab - bM3Lab],
      {0, 0, 0},
      TestID -> "jorek-M3DC1-axisymmetric-field-needs-psi-and-F0-reversal"],
    VerificationTest[
      FullSimplify[(phaseJ /. phiJ -> -phiC) - phaseM3,
        Assumptions -> Element[{aCosJ, aSinJ, nPhysJ, phiC}, Reals]],
      0, TestID -> "jorek-sine-slot-to-M3DC1-complex-amplitude"],
    VerificationTest[
      FullSimplify[
        Cos[nRedJ nfpJ (phiJ + periodJ)] -
          Cos[nRedJ nfpJ phiJ],
        Assumptions -> Element[{nRedJ, nfpJ}, Integers] && nfpJ > 0],
      0, TestID -> "jorek-nfp-cosine-field-period"],
    VerificationTest[
      FullSimplify[
        Sin[nRedJ nfpJ (phiJ + periodJ)] -
          Sin[nRedJ nfpJ phiJ],
        Assumptions -> Element[{nRedJ, nfpJ}, Integers] && nfpJ > 0],
      0, TestID -> "jorek-nfp-sine-field-period"],
    VerificationTest[
      FullSimplify[rotClockwise.xJ - (xJ /. phiJ -> phiJ + periodJ),
        Assumptions -> Element[{rJ, zJ, phiJ, nfpJ}, Reals] && nfpJ > 0],
      {0, 0, 0}, TestID -> "jorek-field-period-is-clockwise-cartesian-rotation"],
    VerificationTest[
      FullSimplify[(-2 Pi psiJPerRad)/(2 Pi) + psiJPerRad],
      0, TestID -> "jorek-IMAS-full-poloidal-flux-map"],
    VerificationTest[
      FullSimplify[(-f0J) (-ipJ) - f0J ipJ],
      0, TestID -> "jorek-cocos8-to-17-Bphi-Ip-product-is-invariant"],
    VerificationTest[
      FullSimplify[
        Sign[f0J Sign[dPsiJ]] - Sign[f0J kIpJ dPsiJ],
        Assumptions -> Element[{f0J, dPsiJ, kIpJ}, Reals] &&
          f0J != 0 && dPsiJ != 0 && kIpJ > 0],
      0, TestID -> "jorek-native-q-sign-is-F0-times-current-sign"],
    VerificationTest[
      FullSimplify[
        -D[-phiTorJ[-psiC/(2 Pi)], psiC] -
          (-(phiTorJ'[psiJ])/(2 Pi)) /. psiC -> -2 Pi psiJ],
      0, TestID -> "jorek-cocos8-to-17-q-flux-derivative-is-invariant"],
    VerificationTest[
      FullSimplify[(-dPhiJ)/(-dThetaJ) - dPhiJ/dThetaJ,
        Assumptions -> dThetaJ != 0],
      0, TestID -> "jorek-cocos8-to-17-q-angle-ratio-is-invariant"],
    VerificationTest[
      FullSimplify[
        {f0J/rJ, ipJ} {-1, -1} - {-f0J/rJ, -ipJ}],
      {0, 0}, TestID -> "jorek-clockwise-to-ccw-field-and-current-components"],
    VerificationTest[
      FullSimplify[
        {psi11Z/(2 Pi rJ), -psi11R/(2 Pi rJ)} -
          {(psi11Z/(2 Pi))/rJ, -(psi11R/(2 Pi))/rJ}],
      {0, 0}, TestID -> "jorek-cocos11-to-native-per-radian-poloidal-field"],
    VerificationTest[
      FullSimplify[(-dPhi1)/(-dTheta1) - dPhi1/dTheta1,
        Assumptions -> dTheta1 != 0],
      0, TestID -> "jorek-cocos1-to-8-reverses-both-angles-and-preserves-q"],
    VerificationTest[
      FullSimplify[
        {psi11Z/rJ, -psi11R/rJ} -
          2 Pi {psi11Z/(2 Pi rJ), -psi11R/(2 Pi rJ)}],
      {0, 0}, TestID -> "jorek-direct-cocos11-input-is-two-pi-too-large"]
  }
];

(* A rigid toroidal-origin rotation of a VMEC input must transform both the
   boundary and magnetic-axis Fourier tuples.  It manufactures a genuinely
   LASYM case without changing the physical equilibrium.  These are the exact
   input and Cartesian oracles used by verify_vmec_origin_rotation.py. *)
vmecLasymTests = Module[
  {phase = mV thetaV - nV nfpV zetaV,
   shift = nV nfpV zeta0V,
   rotMinus, xShifted, xRotated, cRot, sRot},
  cRot = cV Cos[shift] - sV Sin[shift];
  sRot = cV Sin[shift] + sV Cos[shift];
  rotMinus = {
    {Cos[zeta0V], Sin[zeta0V], 0},
    {-Sin[zeta0V], Cos[zeta0V], 0},
    {0, 0, 1}
  };
  xShifted = {
    rV Cos[zetaV + zeta0V], rV Sin[zetaV + zeta0V], zV};
  xRotated = {rV Cos[zetaV], rV Sin[zetaV], zV};
  {
    VerificationTest[
      FullSimplify[
        rCosV Cos[shift] Cos[phase] +
          rCosV Sin[shift] Sin[phase] - rCosV Cos[phase - shift],
        Assumptions -> Element[{phase, shift, rCosV}, Reals]],
      0,
      TestID -> "vmec-lasym-rbc-rbs-toroidal-origin-rotation"
    ],
    VerificationTest[
      FullSimplify[
        -zSinV Sin[shift] Cos[phase] +
          zSinV Cos[shift] Sin[phase] - zSinV Sin[phase - shift],
        Assumptions -> Element[{phase, shift, zSinV}, Reals]],
      0,
      TestID -> "vmec-lasym-zbc-zbs-toroidal-origin-rotation"
    ],
    VerificationTest[
      FullSimplify[
        (phase - shift) -
          (mV thetaV - nV nfpV (zetaV + zeta0V))],
      0,
      TestID -> "vmec-lasym-rotated-coefficients-evaluate-at-shifted-zeta"
    ],
    VerificationTest[
      FullSimplify[
        cRot Cos[phase] + sRot Sin[phase] -
          (cV Cos[phase - shift] + sV Sin[phase - shift]),
        Assumptions -> Element[{cV, sV, phase, shift}, Reals]],
      0,
      TestID -> "vmec-full-cosine-sine-tuple-origin-rotation"
    ],
    VerificationTest[
      FullSimplify[
        (cRot Cos[phase] + sRot Sin[phase]) /. mV -> 0] -
          FullSimplify[
            cV Cos[-nV nfpV (zetaV + zeta0V)] +
              sV Sin[-nV nfpV (zetaV + zeta0V)]],
      0,
      TestID -> "vmec-magnetic-axis-tuple-must-rotate-with-boundary"
    ],
    VerificationTest[
      FullSimplify[rotMinus.xShifted - xRotated,
        Assumptions -> Element[{rV, zetaV, zeta0V}, Reals]],
      {0, 0, 0},
      TestID -> "vmec-lasym-toroidal-origin-shift-is-cartesian-active-rotation"
    ],
    VerificationTest[
      FullSimplify[rotMinus.{bRV Cos[zetaV + zeta0V] -
            bPhiV Sin[zetaV + zeta0V],
          bRV Sin[zetaV + zeta0V] + bPhiV Cos[zetaV + zeta0V], bZV} -
        {bRV Cos[zetaV] - bPhiV Sin[zetaV],
          bRV Sin[zetaV] + bPhiV Cos[zetaV], bZV},
        Assumptions -> Element[{bRV, bPhiV, bZV, zetaV, zeta0V}, Reals]],
      {0, 0, 0},
      TestID -> "vmec-origin-shift-rotates-full-cartesian-B"
    ]
  }
];

(* booz_xform's C++ VMEC ingress and classic boozmn writer.  PhiEdge is the
   signed full toroidal flux; nPacked=nReduced*NFP is already packed. *)
boozXformTests = Module[
  {phase = mBX thetaBX - nReducedBX nfpBX zetaBX,
   gmn = (gBX + iotaBX iBX)/bmagBX^2,
   js, bZeta},
  js = -phiEdgeBX gmn/(2 Pi);
  bZeta = bmagBX^2/(gBX + iotaBX iBX);
  {
    VerificationTest[
      FullSimplify[zetaBX + pmnBX /. pmnBX -> zetaVBX - zetaBX],
      zetaVBX,
      TestID -> "booz-xform-plus-pmn-recovers-physical-vmec-azimuth"],
    VerificationTest[
      FullSimplify[
        {Cos[phase /. zetaBX -> zetaBX + 2 Pi/nfpBX] - Cos[phase],
         Sin[phase /. zetaBX -> zetaBX + 2 Pi/nfpBX] - Sin[phase]},
        Assumptions -> Element[{nReducedBX, nfpBX}, Integers] && nfpBX > 0],
      {0, 0},
      TestID -> "booz-xform-packed-n-repeats-after-one-field-period"],
    VerificationTest[
      FullSimplify[bZeta (gBX + iotaBX iBX),
        Assumptions -> gBX + iotaBX iBX != 0],
      bmagBX^2,
      TestID -> "booz-xform-covariant-contravariant-field-contraction"],
    VerificationTest[
      FullSimplify[
        ((-(-phiEdgeBX))/(2 Pi))
          ((-gBX + iotaBX (-iBX))/bmagBX^2) - js],
      0,
      TestID -> "booz-xform-whole-field-reversal-preserves-normalized-J"]
  }
];

(* NEMEC uses phi_cyl=zeta, reduced toroidal n with explicit NFP, and the
   left-handed (s,theta,zeta) chart.  These identities are the exact oracle for
   the retained AUG and W7-X native-output gates. *)
nemecTests = Module[
  {period = 2 Pi/nfpN, phase = mN thetaN - nN nfpN zetaN,
   rot, es, et, ez},
  rot = {{Cos[period], -Sin[period], 0},
    {Sin[period], Cos[period], 0}, {0, 0, 1}};
  es = {rsN Cos[zetaN], rsN Sin[zetaN], zsN};
  et = {rtN Cos[zetaN], rtN Sin[zetaN], ztN};
  ez = {-rN Sin[zetaN], rN Cos[zetaN], 0};
  {
    VerificationTest[
      FullSimplify[Cos[phase /. zetaN -> zetaN + period] - Cos[phase],
        Assumptions -> Element[{nN, nfpN}, Integers] && nfpN > 0],
      0, TestID -> "nemec-nfp-cosine-field-period"],
    VerificationTest[
      FullSimplify[Sin[phase /. zetaN -> zetaN + period] - Sin[phase],
        Assumptions -> Element[{nN, nfpN}, Integers] && nfpN > 0],
      0, TestID -> "nemec-nfp-sine-field-period"],
    VerificationTest[
      FullSimplify[rot.{rN Cos[zetaN], rN Sin[zetaN], zN} -
        {rN Cos[zetaN + period], rN Sin[zetaN + period], zN},
        Assumptions -> Element[{rN, zN, zetaN, nfpN}, Reals] && nfpN > 0],
      {0, 0, 0}, TestID -> "nemec-cartesian-field-period-rotation"],
    VerificationTest[
      FullSimplify[Det[Transpose[{es, et, ez}]] -
        rN (rtN zsN - rsN ztN),
        Assumptions -> Element[{rN, rsN, rtN, zsN, ztN, zetaN}, Reals]],
      0, TestID -> "nemec-oriented-cylindrical-jacobian"]
  }
];

tests = Join[tests, cheaseTests, cheaseQuadrantTests, stelloptNeoTests, firm3dTests, simsoptTests,
  spectreTests, specTests, m3dc1Tests, jorekTests, vmecLasymTests,
  boozXformTests, nemecTests];

report = TestReport[tests];
nRun = Length[report["TestResults"]];
nSucceeded = Length[report["TestsSucceededKeys"]];
nFailed = Length[report["TestsFailedWrongResultsKeys"]] +
  Length[report["TestsFailedWithMessagesKeys"]] +
  Length[report["TestsNotEvaluatedKeys"]];
Print["Flux-coordinate handedness CAS: ", nSucceeded, "/", nRun, " passed"];
If[nFailed > 0,
  Print["Wrong results: ", report["TestsFailedWrongResults"]];
  Print["Messages: ", report["TestsFailedWithMessages"]];
  Print["Not evaluated: ", report["TestsNotEvaluated"]];
  Exit[1],
  Exit[0]
];
