"""Generated SymPy translation of ``corpus/proj-rabe-qi-spectral/subcritical_gate.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 26 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('okEqual', 'Module[{residual},\n  residual = FullSimplify[value - expected];\n  If[AllTrue[Flatten[{residual}], # === 0 || PossibleZeroQ[#] &],\n    Print["ok ", name, ": ", ToString[expected, InputForm]],\n    Print["FAIL ", name];\n    Print["  value=", ToString[value, InputForm],\n      " expected=", ToString[expected, InputForm],\n      " residual=", ToString[residual, InputForm]];\n    Exit[1]\n  ]\n]', ('name', 'value', 'expected')),
    ('hpnReturn', 'r /. First[Solve[2 r == (1 - r)/2, r]]', ()),
    ('logKernel', 'Integrate[1/z, {z, Dp, Dm}, Assumptions -> 0 < Dp < Dm]', ()),
    ('scaledKernel', 'FullSimplify[logKernel /. {Dp -> s Dp, Dm -> s Dm},\n  Assumptions -> 0 < Dp < Dm && s > 0]', ()),
    ('mismatch', 'FullSimplify[(K thetaN^2 - K theta0^2)/K, Assumptions -> K > 0]', ()),
    ('weightPotential', '(1 - eta B)^(3/2)/B^2', ()),
    ('weightLhs', '-D[weightPotential, B] Btheta', ()),
    ('weightRhs', 'Btheta (4 - eta B) Sqrt[1 - eta B]/(2 B^3)', ()),
    ('heatKernel', 'x/(2 Sqrt[Pi] t^(3/2)) Exp[-x^2/(4 t)]', ()),
    ('heatResidual', 'FullSimplify[D[heatKernel, t] - D[heatKernel, {x, 2}],\n  Assumptions -> x > 0 && t > 0]', ()),
    ('heatMass', 'Integrate[heatKernel, {t, 0, Infinity}, Assumptions -> x > 0]', ()),
    ('activeReturn', 'nu^(-1/5)', ()),
    ('precession', 'FullSimplify[Sqrt[nu/activeReturn], Assumptions -> nu > 0]', ()),
    ('c0ScaleExpr', 'Rmaj B0^2/(nu eps)', ()),
    ('deltaEtaRef', 'DeltaEtaMax Sqrt[nu/nuCrit]', ()),
    ('rb0DrDpsi', '1/eps', ()),
    ('dimensionalScale', 'FullSimplify[\n  c0ScaleExpr deltaEtaRef/Sqrt[8] rb0DrDpsi/(Rmaj B0),\n  Assumptions -> Rmaj > 0 && B0 > 0 && nu > 0 && eps > 0 &&\n    nuCrit > 0 && DeltaEtaMax > 0]', ()),
    ('selected', 'muPos cPos - muNeg cNeg', ('muPos', 'muNeg')),
    ('fullSine', 'Integrate[Sin[m xi], {xi, 0, 2 Pi}, Assumptions -> Element[m, Integers] && m > 0]', ()),
    ('windowSine', 'Integrate[Sin[m xi], {xi, a, b}, Assumptions -> Element[m, Integers] && m > 0]', ()),
    ('potential', '{0, c0, c0 + c1, c0 + c1 + c2}', ()),
    ('maxSigns', '{1, -1}', ()),
    ('minSigns', '{-1, 1}', ()),
    ('lowerBranch', 'lobe0 + (upper1 - lobe0) x^(2/5)', ()),
    ('closure', 'lowerBranch + (1 - x)(lobeD - lobe0)/(1 + ratio x)', ()),
    ('lowLimit', 'Limit[closure, x -> 0, Assumptions -> ratio > 0]', ()),
    ('joinValue', 'FullSimplify[closure /. x -> 1, Assumptions -> ratio > 0]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-rabe-qi-spectral/subcritical_gate.wl')
