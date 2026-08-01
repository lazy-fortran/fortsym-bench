"""Generated SymPy translation of ``corpus/proj-gvec-stability/eigensolver_iteration.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 10 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('pass', '0', ()),
    ('fail', '0', ()),
    ('check', 'If[\n  TrueQ[condition],\n  pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]]', ('name', 'condition')),
    ('blockDiag', '{{{4, 1}, {1, -2}}, {{3, 0}, {0, 5}}, {{-1, 1}, {1, 6}},\n  {{2, 1}, {1, 2}}}', ()),
    ('blockOff', '{{{1, 0}, {2, 1}}, {{0, 1}, {1, 0}}, {{1, 1}, {0, 1}}}', ()),
    ('nb', 'Length[blockDiag]', ()),
    ('k', '2', ()),
    ('assemble', 'Module[{t = ConstantArray[0, {nb k, nb k}]},\n  Do[t[[k (i - 1) + 1 ;; k i, k (i - 1) + 1 ;; k i]] =\n      blockDiag[[i]] - shift IdentityMatrix[k], {i, nb}];\n  Do[t[[k (i - 1) + 1 ;; k i, k i + 1 ;; k (i + 1)]] =\n      Transpose[blockOff[[i]]];\n    t[[k i + 1 ;; k (i + 1), k (i - 1) + 1 ;; k i]] =\n      blockOff[[i]], {i, nb - 1}];\n  t]', ('shift',)),
    ('schurBlocks', 'Module[{d = {}, current},\n  current = blockDiag[[1]] - shift IdentityMatrix[k];\n  AppendTo[d, current];\n  Do[current = blockDiag[[i]] - shift IdentityMatrix[k] -\n      blockOff[[i - 1]] . Inverse[d[[i - 1]]] .\n        Transpose[blockOff[[i - 1]]];\n    AppendTo[d, current], {i, 2, nb}];\n  d]', ('shift',)),
    ('inertiaBelow', 'Total[Map[\n  Count[Eigenvalues[N[#, 40]], _?Negative] &, schurBlocks[shift]]]', ('shift',)),
    ('directCount', 'Count[Eigenvalues[N[assemble[0], 40]],\n  x_ /; x < shift]', ('shift',)),
    ('shifts', '{-4, -1, 0, 3/2, 4, 13/2}', ()),
    ('eigs', 'Sort[Eigenvalues[N[assemble[0], 40]]]', ()),
    ('shift', '-2', ()),
    ('matrix', 'N[assemble[0], 60]', ()),
    ('inverse', 'Inverse[matrix - shift IdentityMatrix[nb k]]', ()),
    ('vector', 'Normalize[N[Range[nb k], 60]]', ()),
    ('history', '{}', ()),
    ('rayleigh', 'Last[history]', ()),
    ('nearest', 'First[MinimalBy[eigs, Abs[# - shift] &]]', ()),
    ('ratio', 'Abs[(nearest - shift)] / Abs[(\n  First[MinimalBy[DeleteCases[eigs, x_ /; Abs[x - nearest] < 10^-20],\n    Abs[# - shift] &]] - shift)]', ()),
    ('errors', 'Abs[history - nearest]', ()),
    ('measured', 'errors[[8]] / errors[[7]]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-gvec-stability/eigensolver_iteration.wl')
