"""Generated SymPy translation of ``corpus/proj-rabe-qi-spectral/b_channel_gate.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 12 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('okEqual', 'Module[{residual},\n  residual = FullSimplify[value - expected];\n  If[AllTrue[Flatten[{residual}], # === 0 || PossibleZeroQ[#] &],\n    Print["ok ", name, ": ", ToString[expected, InputForm]],\n    Print["FAIL ", name];\n    Print["  value=", ToString[value, InputForm],\n      " expected=", ToString[expected, InputForm],\n      " residual=", ToString[residual, InputForm]];\n    Exit[1]\n  ]\n]', ('name', 'value', 'expected')),
    ('hilbertSign', 'FullSimplify[HilbertTransform[Sign[y], y, x]]', ()),
    ('singularKernel', 'FullSimplify[D[(2 Log[Abs[x]])/Pi, x], Assumptions -> x > 0]', ()),
    ('poleResidue', 'FullSimplify[x singularKernel, Assumptions -> x > 0]', ()),
    ('logLobe', 'Integrate[A/z, {z, Dp, Dm}, Assumptions -> 0 < Dp < Dm]', ()),
    ('scaledLobe', 'FullSimplify[logLobe /. {Dp -> s Dp, Dm -> s Dm},\n  Assumptions -> 0 < Dp < Dm && s > 0]', ()),
    ('upperJoin', 'CA/Sqrt[nuCrit] + CB/nuCrit', ()),
    ('upperJoinNoA', 'upperJoin /. CA -> 0', ()),
    ('residueA', 'A /. First[Solve[A == upperJoinNoA, A]]', ()),
    ('continuityGap', 'FullSimplify[(lambda + residueA) - (lambda + CB/nuCrit)]', ()),
    ('channelRatio', 'FullSimplify[(CB/nu)/(CA/Sqrt[nu]), Assumptions -> nu > 0]', ()),
    ('ratioLimit', 'Limit[1/Sqrt[nu], nu -> 0, Direction -> "FromAbove"]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-rabe-qi-spectral/b_channel_gate.wl')
