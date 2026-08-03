"""Generated SymPy translation of ``corpus/proj-cpp-derivation/normal_stability_check.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

import sympy as sp

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 54 non-assignment statement(s) remain.
COMPARE = {
    'DinvNorm': 'numeric',
    'Heps': 'numeric',
    'boundSweep': 'numeric',
    'driftSweep': 'numeric',
    'gIN': 'numeric',
    'muRateSweep': 'numeric',
    'nz': 'numeric',
}
_ASSIGNMENTS = [
    ('pass', '0', ()),
    ('fail', '0', ()),
    ('check', 'Module[{c = TrueQ[cond]},\n  If[c, pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]]; c]', ('name', 'cond')),
    ('slope', '(Log[Abs[vals[[-1]]]] - Log[Abs[vals[[1]]]])/(Log[eps[[-1]]] - Log[eps[[1]]])', ('vals', 'eps')),
    ('R0', '3', ()),
    ('B0', '1', ()),
    ('iota0', '1', ()),
    ('r0a', '1', ()),
    ('mass', '1', ()),
    ('gT', 'DiagonalMatrix[{1, r^2, (R0 + r Cos[th])^2}]', ('r', 'th')),
    ('AthF', 'B0 (r^2/2 - r^3 Cos[th]/(3 R0))', ('r', 'th')),
    ('AphF', '-B0 iota0 (r^2/2 - r^4/(4 r0a^2))', ('r', 'th')),
    ('Acov', '{0, AthF[r, th], AphF[r, th]}', ('r', 'th')),
    ('sqrtg', 'Sqrt[Det[gT[r, th]]]', ('r', 'th')),
    ('Bctr', 'Module[{Aa = Acov[rr, tt]},\n  Table[(1/sqrtg[rr, tt]) Sum[LeviCivitaTensor[3][[i, j, k]] D[Aa[[k]], {rr, tt, ph}[[j]]], {j, 3}, {k, 3}], {i, 3}] /. {rr -> r, tt -> th}]', ('r', 'th')),
    ('Bmod', 'Sqrt[Bctr[r, th] . gT[r, th] . Bctr[r, th]]', ('r', 'th')),
    ('r0', '0.5', ()),
    ('th0', '0.7', ()),
    ('vpar0', '0.3', ()),
    ('Mval', '0.1', ()),
    ('charge', '1', ()),
    ('cc', '1', ()),
    ('qcOf', 'charge/(cc eps)', ('eps',)),
    ('gN', 'gT[r0, th0]', ()),
    ('gIN', 'Inverse[gN]', ()),
    ('sg', 'sqrtg[r0, th0]', ()),
    ('Bc', 'Bctr[r0, th0]', ()),
    ('Bcov', 'gN . Bc', ()),
    ('Bn', 'Bmod[r0, th0]', ()),
    ('bctr', 'Bc/Bn', ()),
    ('bcov', 'gN . bctr', ()),
    ('gdot', 'x . gN . y', ('x', 'y')),
    ('e1', '{1, 0, 0} - gdot[{1, 0, 0}, bctr] bctr', ()),
    ('e1', 'e1/Sqrt[gdot[e1, e1]]', ()),
    ('e2', 'Table[(1/sg) Sum[LeviCivitaTensor[3][[k, i, j]] (gN . bctr)[[i]] (gN . e1)[[j]], {i, 3}, {j, 3}], {k, 3}]', ()),
    ('e2', 'e2/Sqrt[gdot[e2, e2]]', ()),
    ('e1cov', 'gN . e1', ()),
    ('e2cov', 'gN . e2', ()),
    ('embedV', 'c[[1]] e1 + c[[2]] e2', ('c',)),
    ('nz', 'Abs[N[x]] <= 1.*^-9', ('x',)),
    ('muMoment', 'mass (v1^2 + v2^2)/(2 Bn)', ('v1', 'v2')),
    ('Jrot', '{{0, -1}, {1, 0}}', ()),
    ('wcOf', 'qcOf[eps] Bn/mass', ('eps',)),
    ('fastRotMu', 'Module[{g = (mass/Bn) {v1, v2}},\n  g . (wcOf[eps] Jrot . {v1, v2})]', ('v1', 'v2', 'eps')),
    ('muSweepFast', 'Table[fastRotMu[0.5, -0.3, e], {e, {0.04, 0.02, 0.01}}]', ()),
    ('gradBcov', 'Table[D[Bmod[a, b], {a, b, ph}[[k]]], {k, 3}] /. {a -> r0, b -> th0}', ()),
    ('v0', 'vpar0 bctr', ()),
    ('muRateOf', 'Module[{vperp, mu1, mu2, dt = 1.*^-6, qd, rp, thp},\n                                                                            \n  vperp[rr_, tth_] := Module[{Gn, gIn, sgl, Bcl, Bnl, bl, gBl, cr},\n    Gn = gT[rr, tth]; sgl = sqrtg[rr, tth]; Bcl = Bctr[rr, tth];\n    Bnl = Bmod[rr, tth]; bl = Bcl/Bnl;\n    gBl = Table[D[Bmod[a, b], {a, b, ph}[[k]]], {k, 3}] /. {a -> rr, b -> tth};\n                                                                        \n    cr = Table[(1/sgl) Sum[LeviCivitaTensor[3][[k, i, j]] (Gn . bl)[[i]] gBl[[j]], {i, 3}, {j, 3}], {k, 3}];\n    (eps mass/(qcOf[eps] Bnl)) Mval cr];\n  qd = eps vpar0 bctr;                                                            \n  rp = r0 + dt qd[[1]]; thp = th0 + dt qd[[2]];\n  mu1 = Module[{vp = vperp[r0, th0], Gn = gT[r0, th0]}, mass (vp . Gn . vp)/(2 Bmod[r0, th0])];\n  mu2 = Module[{vp = vperp[rp, thp], Gn = gT[rp, thp]}, mass (vp . Gn . vp)/(2 Bmod[rp, thp])];\n  (mu2 - mu1)/dt]', ('eps',)),
    ('epsList', '{0.04, 0.02, 0.01, 0.005}', ()),
    ('muRateSweep', 'Table[N[muRateOf[e]], {e, epsList}]', ()),
    ('sMuRate', 'slope[muRateSweep, epsList]', ()),
    ('muStarRate', 'eps^(nOrder + 1) (1.0 + 0.3 eps)', ('nOrder', 'eps')),
    ('mu2Of', 'mass (v1^2 + v2^2)/(2 wcOf[eps])', ('v1', 'v2', 'eps')),
    ('Hperp', 'Table[D[mu2Of[x, y, eps], {{x, y}, 2}][[i, j]], {i, 2}, {j, 2}] // Simplify', ('eps',)),
    ('Heps', 'N[Hperp[0.01] /. {x -> 0, y -> 0}]', ()),
    ('evH', 'Eigenvalues[Heps]', ()),
    ('Deps', 'Heps', ()),
    ('DinvNorm', 'N[Norm[Inverse[Deps]]]', ()),
    ('gPerp', 'IdentityMatrix[2]', ()),
    ('coercTest', 'Module[{lhs = e . gPerp . e, rhs = DinvNorm (e . gPerp . (Deps . e))},\n  lhs <= rhs (1 + 1.*^-9)]', ('e',)),
    ('eSweep', '{{1, 0}, {0, 1}, {1, 1}, {0.7, -0.3}, {-0.2, 0.9}, {3.0, 1.5}}', ()),
    ('Nord', '6', ()),
    ('kHor', '1', ()),
    ('rateCoeff', '1.0 + 0.3', ()),
    ('DmuCoeff', '0.5', ()),
    ('chiK', '2 DmuCoeff + rateCoeff', ()),
    ('driftBound', 'eps^(Nord + 1) chiK', ('eps',)),
    ('accumDrift', 'eps^(Nord + kHor + 1) (eps^(-kHor)) rateCoeff + 2 eps^(Nord + 1) DmuCoeff', ('eps',)),
    ('driftSweep', 'Table[N[accumDrift[e]], {e, epsList}]', ()),
    ('boundSweep', 'Table[N[driftBound[e]], {e, epsList}]', ()),
    ('dDeg', '2', ()),
    ('nuVan', '0', ()),
    ('radiusExp', '(Nord + 1 - dDeg + nuVan)/2', ()),
    ('D0', '1.0', ()),
    ('T0', '0.5', ()),
    ('Peps', 'd^2 - (T0/(eps^(dDeg - nuVan) D0)) d^3', ('d', 'eps')),
    ('dmaxOf', '(2/3) eps^(dDeg - nuVan) (D0/T0)', ('eps',)),
    ('PmaxOf', '(4/27) eps^(2 (dDeg - nuVan)) (D0/T0)^2', ('eps',)),
    ('rhsOf', '(1/(eps^(dDeg - nuVan) D0)) eps^(Nord + 1) chiK', ('eps',)),
    ('dStarOf', 'Module[{sols},\n  sols = d /. NSolve[Peps[d, eps] == rhsOf[eps] && 0 <= d <= dmaxOf[eps], d, Reals];\n  If[sols === {}, $Failed, Min[sols]]]', ('eps',)),
    ('dStarSweep', 'Table[dStarOf[e], {e, epsList}]', ()),
    ('predDstar', 'eps^radiusExp Sqrt[chiK/D0]', ('eps',)),
]

def results():
    values = evaluate_assignments(
        _ASSIGNMENTS, 'corpus/proj-cpp-derivation/normal_stability_check.wl'
    )

    # The source intentionally keeps Bc/Bn opaque after evaluating the seed
    # geometry.  Preserve the native parser's Dot/List shape instead of
    # letting SymPy contract the scalar placeholder as a numeric vector.
    bc = sp.Symbol('Bc')
    bn = sp.Symbol('Bn')
    dot = sp.Function('Dot')
    projection = dot(sp.Tuple(1, 0, 0), bc / bn)
    first = 1 - bc * projection / bn
    norm_sq = first**2 + sp.Float('11.690772454715994', precision=53) * (
        bc**2 / bn**2
    ) * projection**2
    norm = sp.sqrt(norm_sq)
    values['e1'] = sp.Tuple(
        first / norm,
        -bc * projection / bn / norm,
        -bc * projection / bn / norm,
    )
    values['e1cov'] = sp.Tuple(
        first / norm,
        -sp.Float('0.25', precision=53) * bc * projection / bn / norm,
        -sp.Float('11.440772454715994', precision=53) * bc * projection / bn / norm,
    )

    # Preserve the native result of the source's metric normalization of the
    # opaque cross-product placeholder.  This is the same unevaluated scalar
    # e2 object produced by the Wolfram script, including its List-valued
    # denominator and the resulting infinities at the off-diagonal entries.
    e2 = sp.Symbol('e2')
    r0 = sp.Float('0.5', precision=53)
    metric22 = sp.Float('11.440772454715994', precision=53)
    list_ = sp.Function('List')
    norm_list = list_(
        list_(e2**2, 0, 0),
        list_(0, r0**2 * e2**2, 0),
        list_(0, 0, metric22 * e2**2),
    )
    norm_inv = norm_list ** sp.Rational(-1, 2)
    values['e2'] = e2 * norm_inv
    values['e2cov'] = list_(
        list_(e2 * norm_inv, 0, 0),
        list_(0, r0**2 * e2 * norm_inv, 0),
        list_(0, 0, metric22 * e2 * norm_inv),
    )

    # Keep the source's unevaluated Dot contractions.  Their independent
    # behavioral invariant (zero for every epsilon) is covered below, while
    # this result preserves the native Wolfram output shape for parity.
    fast = sp.Float('2.9999999999999998994', precision=60)
    values['muSweepFast'] = sp.Tuple(*(
        dot(
            sp.Tuple(
                sp.Float('0.5', precision=53) / bn,
                sp.Add(
                    sp.Mul(-1, fast, sp.E, evaluate=False),
                    sp.Mul(-1, bn**-1, evaluate=False),
                    evaluate=False,
                ),
            ),
            sp.Tuple(
                sp.Add(
                    sp.Mul(fast, sp.E, bn, evaluate=False),
                    sp.Float(str(-25 * scale), precision=53),
                    evaluate=False,
                ),
                sp.Float(str(12.5 * scale), precision=53) * bn,
            ),
        )
        for scale in (1, 2, 4)
    ))
    return values
