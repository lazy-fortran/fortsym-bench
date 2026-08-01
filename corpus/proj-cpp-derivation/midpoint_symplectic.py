"""Generated SymPy translation of ``corpus/proj-cpp-derivation/midpoint_symplectic.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 35 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('pass', '0', ()),
    ('fail', '0', ()),
    ('check', 'Module[{c = TrueQ[Simplify[cond]]},\n  If[c, pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]]; c]', ('name', 'cond')),
    ('checkZero', 'Module[{c = TrueQ[And @@ (PossibleZeroQ /@ Flatten[{expr}])]},\n  If[c, pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]]; c]', ('name', 'expr')),
    ('Jmat', 'ArrayFlatten[{{ConstantArray[0, {n, n}], IdentityMatrix[n]},\n                          {-IdentityMatrix[n], ConstantArray[0, {n, n}]}}]', ('n',)),
    ('cayley', 'Module[{id = IdentityMatrix[Length[L]]},\n  Inverse[id - L] . (id + L)]', ('L',)),
    ('hamGen', 'Module[{S, Jm, L, dt},\n  S = Table[Subscript[s, Min[i, j], Max[i, j]], {i, 2 n}, {j, 2 n}];                \n  Jm = Jmat[n];\n  L = (dt/2) Inverse[Jm] . S;\n  {S, Jm, L}]', ('n',)),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-cpp-derivation/midpoint_symplectic.wl')
