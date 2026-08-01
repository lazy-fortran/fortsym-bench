"""Generated SymPy translation of ``corpus/proj-iter_tc24/neort_layer_kernel.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 13 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('report', 'Print[If[TrueQ[ok], "PASS ", "FAIL "], name]', ('name', 'ok')),
    ('xiOfEta', 'Sqrt[1 - eta B]', ('eta', 'B')),
    ('detadxi', 'D[(1 - xi^2)/B, xi]', ()),
    ('lorentz', '(nu/2) D[(1 - xi^2) D[f[(1 - xi^2)/B], xi], xi]', ()),
    ('lorentzEta', 'Simplify[lorentz /. xi -> xiOfEta[eta, B], 0 < eta B < 1]', ()),
    ('Deta', "Simplify[Coefficient[lorentzEta, f''[eta]], 0 < eta B < 1]", ()),
    ('xiSq', '2 eps k2', ()),
    ('num', 'Integrate[Sqrt[k2 - Sin[th/2]^2], {th, -2 ArcSin[Sqrt[k2]], 2 ArcSin[Sqrt[k2]]},\n   Assumptions -> 0 < k2 < 1]', ()),
    ('den', 'Integrate[1/Sqrt[k2 - Sin[th/2]^2], {th, -2 ArcSin[Sqrt[k2]], 2 ArcSin[Sqrt[k2]]},\n   Assumptions -> 0 < k2 < 1]', ()),
    ('classical', 'EllipticE[m]/EllipticK[m] - (1 - m)', ('m',)),
    ('numN', 'NIntegrate[Sqrt[m - Sin[th/2]^2],\n   {th, -2 ArcSin[Sqrt[m]], 2 ArcSin[Sqrt[m]]}, PrecisionGoal -> 10]', ('m',)),
    ('denN', 'NIntegrate[1/Sqrt[m - Sin[th/2]^2],\n   {th, -2 ArcSin[Sqrt[m]], 2 ArcSin[Sqrt[m]]}, PrecisionGoal -> 10]', ('m',)),
    ('baOK', 'And @@ Table[\n    Abs[numN[m]/denN[m] - classical[m]] < 10^-6,\n    {m, {0.1, 0.3, 0.7, 0.95}}]', ()),
    ('deltaRel3', '(2 nud eta^2 eps g1)/(om2 (2 eps eta)^3) /. eta -> 1/B0', ()),
    ('grid', '{0.5, 1., 2., 4., 8., 16., 32., 64.}', ()),
    ('table', 'Flatten[Table[{zdt, ztp, layerR[zdt, ztp]}, {zdt, grid}, {ztp, grid}], 1]', ()),
    ('rFar', 'layerR[64., 64.]', ()),
    ('rNearDT', 'layerR[1., 64.]', ()),
    ('rNearTP', 'layerR[64., 1.]', ()),
    ('rKrook', 'NIntegrate[\n    nuhat/(z^2 + nuhat^2), {z, -zdt, ztp}]/Pi', ('nuhat', 'zdt', 'ztp')),
    ('OmTE', '5233.327', ()),
    ('OmTBref', '-997.116', ()),
    ('uRoot', '2.734', ()),
    ('epsT', '0.068693', ()),
    ('nuD', '18.8 epsT', ()),
    ('dOm', '2 Abs[OmTBref] uRoot^2', ()),
    ('deltaK2', '(nuD/(2 epsT)/dOm)^(1/3)', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-iter_tc24/neort_layer_kernel.wl')
