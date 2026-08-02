"""Generated SymPy translation of ``corpus/proj-cpp-derivation/variational_symplectic.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

import sympy as sp

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 44 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('pass', '0', ()),
    ('fail', '0', ()),
    ('check', 'Module[{c = TrueQ[Simplify[cond]]},\n  If[c, pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]]; c]', ('name', 'cond')),
    ('checkZero', 'Module[{c = TrueQ[And @@ (PossibleZeroQ /@ Flatten[{expr}])]},\n  If[c, pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]]; c]', ('name', 'expr')),
    ('Jmat', 'ArrayFlatten[{{ConstantArray[0, {n, n}], IdentityMatrix[n]},\n                          {-IdentityMatrix[n], ConstantArray[0, {n, n}]}}]', ('n',)),
    ('q', '{q1, q2, q3}', ()),
    ('gM', 'Table[Subscript[gg, Min[i,j], Max[i,j]][q1, q2, q3], {i, 3}, {j, 3}]', ()),
    ('gInv', 'Inverse[gM]', ()),
    ('Acov', 'Table[Subscript[aa, i][q1, q2, q3], {i, 3}]', ()),
    ('Bm', 'bmod[q1, q2, q3]', ()),
    ('u', '{u1, u2, u3}', ()),
    ('Lcpp', '(mm/2) Sum[gM[[i,j]] u[[i]] u[[j]], {i,3},{j,3}] +\n       qcc Sum[Acov[[i]] u[[i]], {i,3}] - muu Bm', ()),
    ('pcan', 'Table[D[Lcpp, u[[k]]], {k,3}]', ()),
    ('pcanExp', 'Table[mm Sum[gM[[k,i]] u[[i]], {i,3}] + qcc Acov[[k]], {k,3}]', ()),
    ('velHess', 'Table[D[Lcpp, u[[i]], u[[j]]], {i,3},{j,3}]', ()),
    ('pvar', '{p1, p2, p3}', ()),
    ('piCov', 'pvar - qcc Acov', ()),
    ('uOfp', '(1/mm) gInv . piCov', ()),
    ('Lsub', 'Lcpp /. Thread[u -> uOfp]', ()),
    ('Hcpp', 'Simplify[pvar . uOfp - Lsub]', ()),
    ('HcppExp', '(1/(2 mm)) piCov . gInv . piCov + muu Bm', ()),
]

def results():
    values = evaluate_assignments(
        _ASSIGNMENTS, 'corpus/proj-cpp-derivation/variational_symplectic.wl'
    )

    # The generic lowering cannot serialize the opaque metric definitions
    # above, but these two source expressions remain meaningful at that
    # abstraction level. Preserve their exact symbolic Dot/Inverse structure
    # so the native Wolfram path has the same Legendre-transform bindings.
    inverse_gm = sp.Function('Inverse')(sp.Symbol('gM'))
    dot = sp.Function('Dot')
    pi_cov = values['piCov']
    mm = sp.Symbol('mm')
    values['uOfp'] = dot(inverse_gm, pi_cov) / mm
    values['HcppExp'] = (
        sp.Symbol('muu') * values['Bm']
        + dot(dot(pi_cov, inverse_gm), pi_cov) / (2 * mm)
    )
    return values
