"""Generated SymPy translation of ``corpus/proj-flux_pumping/44_kinetic_mhd_bridge_aug.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 29 non-assignment statement(s) remain.
# These are machine-precision arithmetic checks.  The Wolfram path and SymPy
# round intermediate products differently, but an independent decimal check
# of the source formulas bounds the resulting relative error below 2e-15.
# Keep the integral and the derived kinetic scales structural: their remaining
# differences are not rounding differences.
COMPARE = {
    'nuEff': 'numeric',
    'deficitCorr': 'numeric',
    'eDynCorr': 'numeric',
    'epsBetaCore': 'numeric',
    'epsBetaWhole': 'numeric',
    'qFloorCore': 'numeric',
}
_ASSIGNMENTS = [
    ('figdir', 'FileNameJoin[{DirectoryName[$InputFileName], "figures"}]', ()),
    ('$Assumptions', 'vt > 0 && nu > 0 && k > 0', ()),
    ('f0hat', 'Exp[-v^2/(2 vt^2)]/(Sqrt[2 Pi] vt)', ('v',)),
    ('integralG', 'Integrate[v^2 f0hat[v]/(I k v + nu), {v, -Infinity, Infinity},\n  Assumptions -> vt > 0 && nu > 0 && k > 0]', ()),
    ('Gfun', 'Simplify[(nu/vt^2) integralG]', ()),
    ('Gxi', 'Simplify[Gfun /. {k -> xiv nu/vt} /. vt -> 1 /. nu -> 1]', ('xiv',)),
    ('xiHalf', 'x /. FindRoot[Gxi[x] == 1/2, {x, 0.4}]', ()),
    ('eta0', '2.41 10^-9', ()),
    ('bb0', '2.57', ()),
    ('nne', '0.98 10^20', ()),
    ('rr0', '4.41/2.57', ()),
    ('dJphi', '0.8 10^6', ()),
    ('eReq', '1.6 10^-3', ()),
    ('jCore', '2.5 10^6', ()),
    ('me', '9.1093837 10^-31', ()),
    ('ee', '1.602177 10^-19', ()),
    ('teKev', '(1.65 10^-9 15/eta0)^(2/3)', ()),
    ('vte', 'Sqrt[teKev 10^3 ee/me]', ()),
    ('nuEff', 'nne ee^2 eta0/me', ()),
    ('lambdaMfp', 'vte/nuEff', ()),
    ('kPar', 'dq/rr0', ('dq',)),
    ('xiOf', 'kPar[dq] lambdaMfp', ('dq',)),
    ('dqOhm', 'xiHalf rr0/lambdaMfp', ()),
    ('suppression', 'Gxi[xiOf[0.01]]', ()),
    ('deltaHel', '0.05', ()),
    ('dOverB', 'Abs[0.01]/rr0', ()),
    ('deficitCorr', '(3/2) (deltaHel dOverB)^2', ()),
    ('eDynCorr', 'eta0 jCore deficitCorr', ()),
    ('betaPRepresentative', '1.5', ()),
    ('rCoreBracket', '{0.15, 0.20}', ()),
    ('aAug', '0.50', ()),
    ('epsBetaCore', 'betaPRepresentative rCoreBracket/rr0', ()),
    ('epsBetaWhole', 'betaPRepresentative aAug/rr0', ()),
    ('vmecEpsBeta', '0.1809482656966454', ()),
    ('vmecQDrift', '0.02690807725830191', ()),
    ('vmecQScale', 'vmecQDrift/vmecEpsBeta', ()),
    ('qFloorCore', 'vmecQScale epsBetaCore', ()),
    ('figKM', 'GraphicsRow[{\n  LogLogPlot[{Gxi[x], 1/x^2}, {x, 0.01, 100},\n    PlotRange -> {{0.01, 100}, {10^-5, 2}}, Frame -> True,\n    FrameLabel -> {"\\[Xi] = k_par \\[Lambda]_mfp", "G"},\n    PlotLegends -> {"kinetic G(\\[Xi])", "1/\\[Xi]^2"},\n    PlotLabel -> "static parallel response vs collisionality",\n    GridLines -> {{xiHalf, xiOf[0.01]}, {1}}, ImageSize -> 320],\n  LogLogPlot[Gxi[dq lambdaMfp/rr0], {dq, 10^-5, 0.1},\n    PlotRange -> All, Frame -> True,\n    FrameLabel -> {"|q - 1|", "G"},\n    PlotLabel -> "AUG #36663: Ohm validity vs detuning",\n    GridLines -> {{dqOhm, 0.01}, {0.5}}, ImageSize -> 320]},\n  ImageSize -> 660]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-flux_pumping/44_kinetic_mhd_bridge_aug.wl')
