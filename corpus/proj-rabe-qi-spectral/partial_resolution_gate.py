"""Generated SymPy translation of ``corpus/proj-rabe-qi-spectral/partial_resolution_gate.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 30 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('okEqual', 'Module[{residual},\n  residual = FullSimplify[value - expected];\n  If[AllTrue[Flatten[{residual}], # === 0 || PossibleZeroQ[#] &],\n    Print["ok ", name, ": ", ToString[expected, InputForm]],\n    Print["FAIL ", name];\n    Print["  value=", ToString[value, InputForm],\n      " expected=", ToString[expected, InputForm],\n      " residual=", ToString[residual, InputForm]];\n    Exit[1]\n  ]\n]', ('name', 'value', 'expected')),
    ('okClose', 'Module[{residual},\n  residual = Abs[N[value - expected]];\n  If[residual <= tol,\n    Print["ok ", name, ": ", ToString[N[value], InputForm]],\n    Print["FAIL ", name];\n    Print["  value=", ToString[N[value], InputForm],\n      " expected=", ToString[N[expected], InputForm],\n      " residual=", ToString[residual, InputForm], " tol=", ToString[tol, InputForm]];\n    Exit[1]\n  ]\n]', ('name', 'value', 'expected', 'tol')),
    ('w', '1/2 (1 + Erf[s])', ('s',)),
    ('deltaEtaRef', 'DeltaEtaMax Sqrt[nu/nuCrit]', ('nu',)),
    ('gapq', 'DeltaEtaMax Sqrt[nuOnset/nuCrit]', ()),
    ('layerGapRatio', 'FullSimplify[deltaEtaRef[nu]/gapq,\n  Assumptions -> nu > 0 && nuOnset > 0 && nuCrit > 0 && DeltaEtaMax > 0]', ()),
    ('sq', '(aspect/Sqrt[2]) (Sqrt[nu/nuOnset] - 1)', ('nu',)),
    ('blend2', '(wBase lamBase + wFine lamFine)/(wBase + wFine)', ()),
    ('baseOnly', 'FullSimplify[blend2 /. {wBase -> 1, wFine -> 0}]', ()),
    ('fineOnly', 'FullSimplify[blend2 /. {wBase -> 0, wFine -> 1}]', ()),
    ('lamBaseOf', 'lobeBase + (Ujoin - lobeBase) (nu/nuCrit)^(2/5)', ('nu',)),
    ('inner', 'wFine lamFine', ()),
    ('outer', '(1 - wFine) lamBase', ()),
    ('overlap', '0', ()),
    ('composite', 'FullSimplify[inner + outer - overlap]', ()),
    ('blendComplement', 'FullSimplify[blend2 /. {wBase -> 1 - wFine}]', ()),
    ('correction', 'FullSimplify[composite - lamBase]', ()),
    ('sqNuOnset', '3.777346*^-7', ()),
    ('sqNuCrit', '5.07583008905939*^-6', ()),
    ('sqRatioAtOnset', 'Sqrt[sqNuOnset/sqNuOnset]', ()),
    ('sqNuOnsetFine', '2.790248*^-8', ()),
    ('sqRatioFine', 'Sqrt[(1.*^-7)/sqNuOnsetFine]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-rabe-qi-spectral/partial_resolution_gate.wl')
