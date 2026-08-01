"""Generated SymPy translation of ``corpus/proj-plasma-sign-conventions/tc24_cross_code_signs.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 3 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('report', 'TestReport[{\n  VerificationTest[\n    (rntor phiM) /. {rntor -> -n, phiM -> -phiCCW},\n    n phiCCW,\n    TestID -> "mars-native-mode-is-physical-plus-n"\n  ],\n\n  VerificationTest[\n    Expand[(-nn phiG) /.\n      {nn -> n, phiG -> -phiCCW - deltaPhi}],\n    Expand[n phiCCW + n deltaPhi],\n    TestID -> "gpec-helicity-plus-mode-is-physical-plus-n"\n  ],\n\n  VerificationTest[\n    Expand[ellP wbP + n (eP + dP x) /. {\n      ellP -> -ellN, wbP -> wbN, eP -> -eN, dP -> -dN\n    }],\n    Expand[-(ellN wbN + n (eN + dN x))],\n    TestID -> "pentrc-neo-opposite-electric-map-closes"\n  ],\n\n  VerificationTest[\n    Expand[\n      (ellP wbP + n (eP + dP x)) +\n      (ellN wbN + n (eN + dN x)) /. {\n        ellP -> -ellN, wbP -> wbN, eP -> eN, dP -> -dN\n      }\n    ],\n    2 n eN,\n    TestID -> "copied-electric-sign-leaves-two-n-omegaE"\n  ],\n\n  VerificationTest[\n    Simplify[\n      tCCW omegaCCW /. {\n        tCCW -> -tM, omegaCCW -> -omegaM\n      }\n    ],\n    tM omegaM,\n    TestID -> "mars-coordinate-reversal-preserves-power"\n  ],\n\n  VerificationTest[\n    {-c phiPrime/chiPrime, chiPrime} /. {\n      phiPrime -> -phi0, chiPrime -> chi0\n    },\n    {c phi0/chi0, chi0},\n    TestID -> "documented-neort-electric-map-for-tc24-positive-chi-prime"\n  ],\n\n  VerificationTest[\n    ntvtokNativeSign,\n    ntvtokNativeSign,\n    TestID -> "ntvtok-sign-remains-symbolic-without-deck"\n  ]\n}]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-plasma-sign-conventions/tc24_cross_code_signs.wl')
