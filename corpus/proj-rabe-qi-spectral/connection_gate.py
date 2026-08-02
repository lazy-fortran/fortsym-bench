"""Generated SymPy translation of ``corpus/proj-rabe-qi-spectral/connection_gate.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 16 non-assignment statement(s) remain.
COMPARE = {
    'okClose': 'numeric',
}
_ASSIGNMENTS = [
    ('okEqual', 'Module[{residual},\n  residual = FullSimplify[value - expected];\n  If[AllTrue[Flatten[{residual}], # === 0 || PossibleZeroQ[#] &],\n    Print["ok ", name, ": ", ToString[expected, InputForm]],\n    Print["FAIL ", name];\n    Print["  value=", ToString[value, InputForm],\n      " expected=", ToString[expected, InputForm],\n      " residual=", ToString[residual, InputForm]];\n    Exit[1]\n  ]\n]', ('name', 'value', 'expected')),
    ('okClose', 'Module[{residual},\n  residual = Abs[N[value - expected]];\n  If[residual <= tol,\n    Print["ok ", name, ": ", ToString[N[value], InputForm]],\n    Print["FAIL ", name];\n    Print["  value=", ToString[N[value], InputForm],\n      " expected=", ToString[N[expected], InputForm],\n      " residual=", ToString[residual, InputForm], " tol=", ToString[tol, InputForm]];\n    Exit[1]\n  ]\n]', ('name', 'value', 'expected', 'tol')),
    ('deltaEtaRef', 'DeltaEtaMax Sqrt[nu/nuCrit]', ('nu',)),
    ('layerRatio', 'FullSimplify[deltaEtaRef[nu]/DeltaEtaMax,\n  Assumptions -> nu > 0 && nuCrit > 0]', ()),
    ('collapseRatio', 'FullSimplify[deltaEtaRef[nuCrit]/DeltaEtaMax,\n  Assumptions -> nuCrit > 0]', ()),
    ('layerSlope', 'D[deltaEtaRef[nu], nu]', ()),
    ('hpnReturn', 'r /. First[Solve[2 r == (1 - r)/2, r]]', ()),
    ('activeReturnScale', 'nu^(-hpnReturn)', ()),
    ('layerExponent', '2 hpnReturn', ()),
    ('approach', 'lobe + (Ujoin - lobe) x^layerExponent', ()),
    ('approachExponent', 'Exponent[approach - lobe, x]', ()),
    ('layerFromReturn', 'FullSimplify[(1/activeReturnScale)^2,\n  Assumptions -> nu > 0]', ()),
    ('residueA', 'Cb/nuCrit', ()),
    ('upperAsymptote', 'lambdaSC + Ca/Sqrt[nu] + Cb/nu', ('nu',)),
    ('upperAtCrit', 'upperAsymptote[nuCrit]', ()),
    ('bChannelAtCrit', 'Cb/nuCrit', ()),
    ('aChannelAtCrit', 'Ca/Sqrt[nuCrit]', ()),
    ('joinContinuity', 'FullSimplify[\n  bChannelAtCrit - (upperAtCrit - lambdaSC - aChannelAtCrit)]', ()),
    ('sqCa', '-7.2224353200885*^-07', ()),
    ('sqCb', '1.52805423961091*^-05', ()),
    ('sqNuCrit', '5.07583008905939*^-06', ()),
    ('sqResidue', 'sqCb/sqNuCrit', ()),
    ('sqAchan', 'sqCa/Sqrt[sqNuCrit]', ()),
    ('sqRatio', 'Abs[sqAchan/sqResidue]', ()),
    ('sqUpper', 'sqResidue + sqAchan', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-rabe-qi-spectral/connection_gate.wl')
