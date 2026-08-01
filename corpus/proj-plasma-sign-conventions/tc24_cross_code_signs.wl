(* Exact sign contract for the compared ITER TC24 code paths. *)

report = TestReport[{
  VerificationTest[
    (rntor phiM) /. {rntor -> -n, phiM -> -phiCCW},
    n phiCCW,
    TestID -> "mars-native-mode-is-physical-plus-n"
  ],

  VerificationTest[
    Expand[(-nn phiG) /.
      {nn -> n, phiG -> -phiCCW - deltaPhi}],
    Expand[n phiCCW + n deltaPhi],
    TestID -> "gpec-helicity-plus-mode-is-physical-plus-n"
  ],

  VerificationTest[
    Expand[ellP wbP + n (eP + dP x) /. {
      ellP -> -ellN, wbP -> wbN, eP -> -eN, dP -> -dN
    }],
    Expand[-(ellN wbN + n (eN + dN x))],
    TestID -> "pentrc-neo-opposite-electric-map-closes"
  ],

  VerificationTest[
    Expand[
      (ellP wbP + n (eP + dP x)) +
      (ellN wbN + n (eN + dN x)) /. {
        ellP -> -ellN, wbP -> wbN, eP -> eN, dP -> -dN
      }
    ],
    2 n eN,
    TestID -> "copied-electric-sign-leaves-two-n-omegaE"
  ],

  VerificationTest[
    Simplify[
      tCCW omegaCCW /. {
        tCCW -> -tM, omegaCCW -> -omegaM
      }
    ],
    tM omegaM,
    TestID -> "mars-coordinate-reversal-preserves-power"
  ],

  VerificationTest[
    {-c phiPrime/chiPrime, chiPrime} /. {
      phiPrime -> -phi0, chiPrime -> chi0
    },
    {c phi0/chi0, chi0},
    TestID -> "documented-neort-electric-map-for-tc24-positive-chi-prime"
  ],

  VerificationTest[
    ntvtokNativeSign,
    ntvtokNativeSign,
    TestID -> "ntvtok-sign-remains-symbolic-without-deck"
  ]
}];

If[report["TestsFailed"] =!= 0,
  Print[report];
  Exit[1]
];
Print[report];
Exit[0];
