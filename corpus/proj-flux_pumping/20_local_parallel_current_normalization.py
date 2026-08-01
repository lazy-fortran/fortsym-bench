"""Generated SymPy translation of ``corpus/proj-flux_pumping/20_local_parallel_current_normalization.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 24 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('wp', '{wp1, wp2, wp3}', ()),
    ('wm', '{wm1, wm2, wm3}', ()),
    ('rp', '{rp1, rp2, rp3}', ()),
    ('rm', '{rm1, rm2, rm3}', ()),
    ('qraw', 'wp.rp - wm.rm', ()),
    ('oldDensity', '(wp1 rp1 - wm1 rm1)/dphi', ()),
    ('dphi', '{d1, d2, d3}', ()),
    ('bhat', '{b1, b2, b3}', ()),
    ('hphi', '{h1, h2, h3}', ()),
    ('raw', '{r1, r2, r3}', ()),
    ('mu', 'dphi/(bhat hphi)', ()),
    ('y6', 'Total[mu]', ()),
    ('gammaLocal', '-beta3 betak bhat hphi raw', ()),
    ('surfaceAverage', 'Total[mu gammaLocal]/y6', ()),
    ('gamma', '-beta3 betak (dphi.raw)/y6', ()),
    ('dScale', 'vT rho bref', ()),
    ('vparB', '-dScale (g1 a1 + g2 a2)', ()),
    ('jpar', 'z eCharge density vparB/(bref bh)', ()),
    ('uD', '{2, -1, 0, 1}', ()),
    ('uA', '{-1, 0, 0, 0}', ()),
    ('uB', '{0, 0, 0, 1}', ()),
    ('uCharge', '{0, 0, 1, 0}', ()),
    ('uDensity', '{-3, 0, 0, 0}', ()),
    ('uVelocity', 'uD + uA - uB', ()),
    ('uCurrentDensity', 'uCharge + uDensity + uVelocity', ()),
    ('gComplex', '(gReal - gBase) - I (gImag - gBase)', ()),
    ('summaryPath', 'FileNameJoin[{DirectoryName[$InputFileName], "..", "runs",\n    "wp2_neo2", "helical_core_l1", "results",\n    "local_response_18564561.json"}]', ()),
    ('summary', 'Import[summaryPath, "RawJSON"]', ()),
    ('expectedRun', 'summary["qflux_expected"]', ()),
    ('pointRun', 'summary["qflux_point_sum"][[{1, 3}]]', ()),
    ('localRun', 'summary["qflux_local_sum"][[{1, 3}]]', ()),
    ('relativeRun', 'Abs[pointRun - expectedRun]/Map[Max[Abs[#], 1.] &, expectedRun]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-flux_pumping/20_local_parallel_current_normalization.wl')
