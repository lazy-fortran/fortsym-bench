"""Generated SymPy translation of ``corpus/proj-cpp-derivation/perp_block_check.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

import sympy as sp

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 44 non-assignment statement(s) remain.
COMPARE = {
    'block': 'numeric',
    'checkZeroB': 'numeric',
    'gIN': 'numeric',
    'invNorm': 'numeric',
    'nz': 'numeric',
    'omegaC': 'numeric',
    'parCol': 'numeric',
    'parPar': 'numeric',
    'parRow': 'numeric',
    'predInv': 'numeric',
}
_ASSIGNMENTS = [
    ('pass', '0', ()),
    ('fail', '0', ()),
    ('check', 'Module[{c = TrueQ[cond]},\n  If[c, pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]]; c]', ('name', 'cond')),
    ('R0', '3', ()),
    ('B0', '1', ()),
    ('iota0', '1', ()),
    ('r0a', '1', ()),
    ('mass', '1', ()),
    ('gT', 'DiagonalMatrix[{1, r^2, (R0 + r Cos[th])^2}]', ('r', 'th')),
    ('AthF', 'B0 (r^2/2 - r^3 Cos[th]/(3 R0))', ('r', 'th')),
    ('AphF', '-B0 iota0 (r^2/2 - r^4/(4 r0a^2))', ('r', 'th')),
    ('Acov', '{0, AthF[r, th], AphF[r, th]}', ('r', 'th')),
    ('coord', '{r, th, ph}', ()),
    ('sqrtg', 'Sqrt[Det[gT[r, th]]]', ('r', 'th')),
    ('Bctr', 'Module[{Aa = Acov[rr, tt]},\n  Table[(1/sqrtg[rr, tt]) Sum[LeviCivitaTensor[3][[i, j, k]] D[Aa[[k]], {rr, tt, ph}[[j]]], {j, 3}, {k, 3}], {i, 3}] /. {rr -> r, tt -> th}]', ('r', 'th')),
    ('Bmod', 'Sqrt[Bctr[r, th] . gT[r, th] . Bctr[r, th]]', ('r', 'th')),
    ('r0', '0.5', ()),
    ('th0', '0.7', ()),
    ('vpar', '0.3', ()),
    ('charge', '1', ()),
    ('cc', '1', ()),
    ('qcVal', '30', ()),
    ('ro0', 'charge/(cc qcVal)', ()),
    ('gN', 'gT[r0, th0]', ()),
    ('gIN', 'Inverse[gN]', ()),
    ('Bc', 'Bctr[r0, th0]', ()),
    ('Bcov', 'gN . Bc', ()),
    ('Bn', 'Bmod[r0, th0]', ()),
    ('bctr', 'Bc/Bn', ()),
    ('bcov', 'Bcov/Bn', ()),
    ('gdot', 'x . gN . y', ('x', 'y')),
    ('seed1', '{1, 0, 0}', ()),
    ('e1raw', 'seed1 - gdot[seed1, bctr] bctr', ()),
    ('e1', 'e1raw/Sqrt[gdot[e1raw, e1raw]]', ()),
    ('crossCtr', 'Module[{acov = gN . actr, ccov = gN . cctr},\n  Table[(1/sqrtg[r0, th0]) Sum[LeviCivitaTensor[3][[k, i, j]] acov[[i]] ccov[[j]], {i, 3}, {j, 3}], {k, 3}]]', ('actr', 'cctr')),
    ('e2', 'crossCtr[bctr, e1]', ()),
    ('e2', 'e2/Sqrt[gdot[e2, e2]]', ()),
    ('nz', 'Abs[N[x]] <= 1.*^-9', ('x',)),
    ('dA', 'Table[D[Acov[rr, tt][[i]], {rr, tt, ph}[[k]]], {i, 3}, {k, 3}] /. {rr -> r0, tt -> th0}', ()),
    ('Fmat', 'Table[qcVal (dA[[j, k]] - dA[[k, j]]), {k, 3}, {j, 3}]', ()),
    ('BxOp', 'Table[qcVal sqrtg[r0, th0] Sum[LeviCivitaTensor[3][[k, j, l]] Bc[[l]], {l, 3}], {k, 3}, {j, 3}]', ()),
    ('Dwf', 'Fmat . ((1/mass) gIN)', ()),
    ('Ecov', 'gN . bvec', ('bvec',)),
    ('blockComp', 'avec . (Dwf . Ecov[bvec])', ('avec', 'bvec')),
    ('block', 'N[{{blockComp[e1, e1], blockComp[e1, e2]},\n           {blockComp[e2, e1], blockComp[e2, e2]}}]', ()),
    ('parRow', 'N[{blockComp[bctr, e1], blockComp[bctr, e2]}]', ()),
    ('parCol', 'N[{blockComp[e1, bctr], blockComp[e2, bctr]}]', ()),
    ('parPar', 'N[blockComp[bctr, bctr]]', ()),
    ('omegaC', 'N[qcVal Bn/mass]', ()),
    ('symPart', '(block + Transpose[block])/2', ()),
    ('asymPart', '(block - Transpose[block])/2', ()),
    ('sv', 'SingularValueList[block]', ()),
    ('Jrot', 'block/omegaC', ()),
    ('invBlock', 'Inverse[block]', ()),
    ('invNorm', 'N[Norm[invBlock]]', ()),
    ('predInv', 'N[1/omegaC]', ()),
    ('checkZeroB', 'N[bctr . (Dwf . Ecov[bctr])]', ()),
]

def results():
    values = evaluate_assignments(
        _ASSIGNMENTS, 'corpus/proj-cpp-derivation/perp_block_check.wl'
    )
    # The source evaluates this inverse after fixing the seed point. The
    # generic lowering leaves the matrix inverse as a symbolic operation, so
    # recover this one diagonal binding directly from the source metric.
    r0 = sp.Float('0.5')
    th0 = sp.Float('0.7')
    R0 = sp.Integer(3)
    values['gIN'] = sp.Tuple(
        sp.Tuple(1, 0, 0),
        sp.Tuple(0, 1 / r0**2, 0),
        sp.Tuple(0, 0, 1 / (R0 + r0 * sp.cos(th0))**2),
    )
    return values
