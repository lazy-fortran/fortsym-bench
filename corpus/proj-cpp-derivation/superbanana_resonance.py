"""Generated SymPy translation of ``corpus/proj-cpp-derivation/superbanana_resonance.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 46 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('pass', '0', ()),
    ('fail', '0', ()),
    ('check', 'Module[{c = TrueQ[cond]},\n  If[c, pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]]; c]', ('name', 'cond')),
    ('omegaB', '1 + Jb/2', ('Jb',)),
    ('omegaD', '2 (Jb - 4/5)', ('Jb',)),
    ('nRes', '1', ()),
    ('mRes', '1', ()),
    ('resCond', 'nRes omegaB[Jb] + mRes omegaD[Jb]', ('Jb',)),
    ('JbScan', 'Table[j, {j, 0, 1, 1/100}]', ()),
    ('Jres', 'Jb /. Solve[resCond[Jb] == 0, Jb][[1]]', ()),
    ('projComboAdvance', 'Module[{s0 = {0, 0, Jb}, s1},\n  s1 = projStep[s0, dt];\n  (nRes (s1[[1]] - s0[[1]]) + mRes (s1[[2]] - s0[[2]]))/dt]', ('Jb', 'dt')),
    ('JresProj', 'Jb /. Solve[projComboAdvance[Jb, 1] == 0, Jb][[1]]', ()),
    ('d3Bound', '1', ()),
    ('CC', '1', ()),
    ('Norder', '4', ()),
    ('epsT', '1/40', ()),
    ('slowLTE', '(d3Bound/24) dt^3 + CC epsT^(Norder + 1)', ('dt',)),
    ('projComboLTE', 'resCond[Jb] + (d3Bound/24) dt^2', ('Jb', 'dt')),
    ('JresProjLTE', 'Jb /. FindRoot[projComboLTE[Jb, dt] == 0, {Jb, Jres}][[1]]', ('dt',)),
    ('placeErr', 'Abs[JresProjLTE[dt] - Jres]', ('dt',)),
    ('errSmall', 'placeErr[1/10]', ()),
    ('errBig', 'placeErr[1/2]', ()),
    ('jacBound', "Max[Abs[omegaB'[Jb] /. Jb -> #] & /@ JbScan,\n               Abs[omegaD'[Jb] /. Jb -> #] & /@ JbScan]", ()),
    ('dtAdmissible', '2/jacBound - 1/1000', ()),
    ('delta', '1/5', ()),
    ('omegaBwrong', 'omegaB[Jb] (1 + delta)', ('Jb',)),
    ('resCondWrong', 'nRes omegaBwrong[Jb] + mRes omegaD[Jb]', ('Jb',)),
    ('plainComboAdvance', 'Module[{s0 = {0, 0, Jb}, s1},\n  s1 = plainStep[s0, dt];\n  (nRes (s1[[1]] - s0[[1]]) + mRes (s1[[2]] - s0[[2]]))/dt]', ('Jb', 'dt')),
    ('JresWrong', 'Jb /. Solve[resCondWrong[Jb] == 0, Jb][[1]]', ()),
    ('JresWrongOf', 'Jb /. Solve[nRes omegaB[Jb] (1 + d) + mRes omegaD[Jb] == 0, Jb][[1]]', ('d',)),
    ('misplace', 'JresWrongOf[d] - Jres', ('d',)),
    ('dtRes', '1/5', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-cpp-derivation/superbanana_resonance.wl')
