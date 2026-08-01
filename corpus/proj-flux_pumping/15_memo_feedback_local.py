"""Generated SymPy translation of ``corpus/proj-flux_pumping/15_memo_feedback_local.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 39 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('figdir', 'FileNameJoin[{DirectoryName[$InputFileName], "figures"}]', ()),
    ('$Assumptions', '{r > 0, R > 0, B0 > 0, Bph > 0, cl > 0, kpar != 0,\n    Element[m, Integers], Element[n, Integers], m != 0, m iota + n != 0}', ()),
    ('sqrtg', 'r R', ()),
    ('metric', 'DiagonalMatrix[{1, r^2, R^2}]', ()),
    ('crossCovCov', 'Cross[a, b]/sqrtg', ('a', 'b')),
    ('javg', 'Delta Cos[alpha]/(2 rr) D[rr jm[rr], rr]', ('rr',)),
    ('jphOfB', 'cl/(4 Pi) 1/(rr R) D[rr^2 bth[rr], rr]', ('rr',)),
    ('ItorOfB', 'Integrate[2 Pi R rp jphOfB[rp], rp] /. rp -> rr', ('rr',)),
    ('drive', 'Brm/B0 - I kpar Phim/E0r', ()),
    ('rhom', 'kpar/omE F0 drive', ()),
    ('jparm', '-F0 drive', ()),
    ('Bcontra', '{0, iota Bph, Bph}', ()),
    ('Bcov', 'metric.Bcontra', ()),
    ('Bmag', 'Simplify[Sqrt[Bcontra.Bcov], r > 0]', ()),
    ('Ecov', '{-Php, 0, 0}', ()),
    ('VEcontra', 'cl crossCovCov[Ecov, Bcov]/Bmag^2', ()),
    ('kcov', '{0, m, n}', ()),
    ('kdotVE', 'Simplify[kcov.VEcontra]', ()),
    ('hcov', 'Bcov/Bmag', ()),
    ('kparExact', 'Simplify[kcov.Bcontra/Bmag]', ()),
    ('rhomSurf', '-Brm/(I (m Bcontra[[2]] + n Bcontra[[3]]))', ()),
    ('PhiA', 'Simplify[Php rhomSurf]', ()),
    ('gradrCov', '{1, 0, 0}', ()),
    ('gradphCov', '{0, 0, 1}', ()),
    ('kXgradr', 'crossCovCov[kcov, gradrCov]', ()),
    ('ratioExact', 'Simplify[(kXgradr.gradphCov)/(kXgradr.hcov)]', ()),
    ('hth', 'Simplify[hcov[[2]]]', ()),
    ('hph', 'Simplify[hcov[[3]]]', ()),
    ('Ias', '-I x2/x1^2 /. {x1 -> kpar vT/nu, x2 -> -omE/nu}', ()),
    ('F0asSpecies', 'ea na vT^2/nu ((A1 + A2) Ias + A2/2 Ias)', ()),
    ('A1of', "dens'[r]/dens[r] + q Php/T[r] - 3 T'[r]/(2 T[r])", ('q', 'dens', 'T')),
    ('A2of', "T'[r]/T[r]", ('T',)),
    ('sumEN', 'Sum[sp[[1]] sp[[2]][r] (A1of[sp[[1]], sp[[2]], sp[[3]]]\n      + 3/2 A2of[sp[[3]]]), {sp, {{qe, nne, Te}, {qi, nni, Ti}}}]', ()),
    ('neutral', 'nni -> Function[rr, -qe nne[rr]/qi]', ()),
    ('rhomBoltz', '-(qe^2 nne[r]/Te[r] + qi^2 nni[r]/Ti[r]) PhiMA', ()),
    ('jparBoltz', '-omE rhomBoltz/kpar', ()),
    ('jparAsymp', 'I kpar (-I omE (-Php)/(4 Pi kpar^2) (4 Pi nne[r] qe^2/Te[r]\n    + 4 Pi nni[r] qi^2/Ti[r])) PhiMA/(-Php)', ()),
    ('sumLam', '4 Pi nne[r] qe^2/Te[r] + 4 Pi nni[r] qi^2/Ti[r]', ()),
    ('jphAsymp', 'Simplify[jparBoltz/R]', ()),
    ('jphExpl', 'Simplify[jphAsymp /. {kpar -> (m/R) (iota - iotam),\n    omE -> cl Php m/(B0 r)}]', ()),
    ('lowRoot', '(iota0 + iotam)/2 - Sqrt[(iota0 - iotam)^2/4 + KK]', ()),
    ('upRoot', '(iota0 + iotam)/2 + Sqrt[(iota0 - iotam)^2/4 + KK]', ()),
    ('pumpedBranch', '(i0 + 1)/2 - Sqrt[(i0 - 1)^2/4 + km]', ('i0', 'km')),
    ('otherBranch', '(i0 + 1)/2 + Sqrt[(i0 - 1)^2/4 + km]', ('i0', 'km')),
    ('figClamp', 'Plot[\n    {pumpedBranch[i0, 0.001], pumpedBranch[i0, 0.004],\n     otherBranch[i0, 0.001], otherBranch[i0, 0.004], i0},\n    {i0, 0.9, 1.15},\n    PlotStyle -> {Directive[Thick, ColorData[97][1]],\n      Directive[Thick, ColorData[97][2]],\n      Directive[Thin, Gray], Directive[Thin, Gray, Dashed],\n      Directive[Gray, Dashed]},\n    PlotLegends -> Placed[{"pumped branch, K = 0.001",\n      "pumped branch, K = 0.004", "upper branch, K = 0.001",\n      "upper branch, K = 0.004", "no feedback (\\[Iota] = \\[Iota]0)"},\n      {0.32, 0.75}],\n    Epilog -> {Gray, Dotted, Line[{{0.9, 1}, {1.15, 1}}],\n      Text[Style["\\[Iota] = \\[Iota]m (q = 1)", Gray, 11], {1.11, 1.008}]},\n    Frame -> True,\n    FrameLabel -> {"\\[Iota]0 (unperturbed, with CD overdrive)",\n      "\\[Iota] (solution of the local feedback equation)"},\n    PlotRange -> {{0.9, 1.15}, {0.9, 1.15}}, ImageSize -> 460]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-flux_pumping/15_memo_feedback_local.wl')
