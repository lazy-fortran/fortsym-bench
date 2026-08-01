"""Generated SymPy translation of ``corpus/proj-flux_pumping/16_helcore_neo2_mode_map.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 17 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('bcPath', 'FileNameJoin[{DirectoryName[$InputFileName], "..", "sources",\n    "faepcr35", "NEO2", "HELCORE", "simple_l1", "reference",\n    "helcore.bc"}]', ()),
    ('tokens', 'StringSplit /@ ReadList[bcPath, String]', ()),
    ('number', 'ToExpression[StringReplace[s, "E" -> "*^"]]', ('s',)),
    ('modeRows', 'Map[number,\n  Select[tokens, Length[#] == 6 &&\n      StringMatchQ[#[[1]], NumberString] &&\n      StringMatchQ[#[[2]], NumberString] &], {2}]', ()),
    ('firstSurface', 'Take[modeRows, 6]', ()),
    ('axisRows', 'Select[firstSurface, #[[1]] == 0 &]', ()),
    ('rAxis', 'Total[#[[3]] Cos[#[[1]] theta - #[[2]] u] & /@ axisRows]', ('u',)),
    ('zAxis', 'Total[#[[4]] Sin[#[[1]] theta - #[[2]] u] & /@ axisRows]', ('u',)),
    ('rMajor', '(rAxis[0] + rAxis[Pi])/2', ()),
    ('dAxis', '(rAxis[0] - rAxis[Pi])/2', ()),
    ('helcoreAxis', '{dAxis Cos[phiH], dAxis Sin[phiH]}', ()),
    ('reportAxis', '{dAxis Cos[zetaR], -dAxis Sin[zetaR]}', ()),
    ('mS', '-1', ()),
    ('nS', '1', ()),
    ('mR', '1', ()),
    ('nR', '1', ()),
    ('mH', '1', ()),
    ('nH', '-1', ()),
    ('sergeiPhase', 'mS theta + nS phiS', ()),
    ('reportPhase', 'mR theta + nR zetaR', ()),
    ('helcorePhase', 'mH theta + nH phiH', ()),
    ('thetaLine', 'theta0 + iotaH phiH', ()),
    ('iotaS', 'D[thetaLine /. phiH -> phiS, phiS]', ()),
    ('iotaR', 'D[thetaLine /. phiH -> -zetaR, zetaR]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-flux_pumping/16_helcore_neo2_mode_map.wl')
