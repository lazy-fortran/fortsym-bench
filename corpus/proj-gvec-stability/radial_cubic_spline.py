"""Generated SymPy translation of ``corpus/proj-gvec-stability/radial_cubic_spline.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 25 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('pass', '0', ()),
    ('fail', '0', ()),
    ('check', 'If[TrueQ[FullSimplify[condition]],\n  pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]]', ('name', 'condition')),
    ('segment', 'Module[{h = xRight - xLeft, left = x - xLeft,\n    right = xRight - x},\n   mLeft right^3/(6 h) + mRight left^3/(6 h) +\n    (yLeft - mLeft h^2/6) right/h +\n    (yRight - mRight h^2/6) left/h]', ('x', 'xLeft', 'xRight', 'yLeft', 'yRight', 'mLeft', 'mRight')),
    ('assumptions', 'h1 > 0 && h2 > 0 && h3 > 0', ()),
    ('x0', '0', ()),
    ('x1', 'h1', ()),
    ('x2', 'h1 + h2', ()),
    ('x3', 'h1 + h2 + h3', ()),
    ('left', 'segment[x, x0, x1, y0, y1, m0, m1]', ()),
    ('right', 'segment[x, x1, x2, y1, y2, m1, m2]', ()),
    ('interiorEquation', 'h1 m0 + 2 (h1 + h2) m1 + h2 m2 ==\n   6 ((y2 - y1)/h2 - (y1 - y0)/h1)', ()),
    ('notAKnotResidual', '-h2 m0 + (h1 + h2) m1 - h1 m2', ()),
    ('m0Eliminated', '((h1 + h2) m1 - h1 m2)/h2', ()),
    ('reducedFirst', '(h1 + h2) (2 + h1/h2) m1 +\n  (h2 - h1^2/h2) m2', ()),
    ('m3Eliminated', '((h2 + h3) m2 - h3 m1)/h2', ()),
    ('reducedLast', '(h2 - h3^2/h2) m1 +\n  (h2 + h3) (2 + h3/h2) m2', ()),
    ('polynomial', 'a0 + a1 t + a2 t^2 + a3 t^3', ('t',)),
    ('points', '{x0, x1, x2, x3}', ()),
    ('values', 'polynomial /@ points', ()),
    ('second', '(D[polynomial[t], {t, 2}] /. t -> #) & /@ points', ()),
    ('pieces', 'Table[\n   segment[x, points[[i]], points[[i + 1]], values[[i]],\n    values[[i + 1]], second[[i]], second[[i + 1]]], {i, 1, 3}]', ()),
    ('fixtureNodes', '{1/25, 17/100, 9/25, 29/50, 79/100, 24/25}', ()),
    ('fixtureValues', '{1, -2, 3, 1/2, -1, 2}', ()),
    ('fixtureIntervals', 'Differences[fixtureNodes]', ()),
    ('fixtureSecond', 'Array[fixtureM, Length[fixtureNodes]]', ()),
    ('fixtureInterior', 'Table[\n   fixtureIntervals[[i - 1]] fixtureSecond[[i - 1]] +\n     2 (fixtureIntervals[[i - 1]] + fixtureIntervals[[i]])\n       fixtureSecond[[i]] + fixtureIntervals[[i]] fixtureSecond[[i + 1]] ==\n    6 ((fixtureValues[[i + 1]] - fixtureValues[[i]])/\n        fixtureIntervals[[i]] -\n      (fixtureValues[[i]] - fixtureValues[[i - 1]])/\n        fixtureIntervals[[i - 1]]),\n   {i, 2, Length[fixtureNodes] - 1}]', ()),
    ('fixtureNotAKnot', '{\n   (fixtureSecond[[2]] - fixtureSecond[[1]])/fixtureIntervals[[1]] ==\n    (fixtureSecond[[3]] - fixtureSecond[[2]])/fixtureIntervals[[2]],\n   (fixtureSecond[[-2]] - fixtureSecond[[-3]])/fixtureIntervals[[-2]] ==\n    (fixtureSecond[[-1]] - fixtureSecond[[-2]])/fixtureIntervals[[-1]]}', ()),
    ('fixtureSolution', 'First[Solve[Join[fixtureInterior, fixtureNotAKnot],\n    fixtureSecond]]', ()),
    ('fixtureResults', '{\n   {fixtureSegment[0, 1], D[fixtureSegment[t, 1], t] /. t -> 0},\n   {fixtureSegment[1/2, 3], D[fixtureSegment[t, 3], t] /. t -> 1/2},\n   {fixtureSegment[1, 5], D[fixtureSegment[t, 5], t] /. t -> 1}}', ()),
    ('lower2', 'sub2/diag1', ()),
    ('factored2', 'diag2 - lower2 super1', ()),
    ('lower3', 'sub3/factored2', ()),
    ('factored3', 'diag3 - lower3 super2', ()),
    ('lowerMatrix', '{{1, 0, 0}, {lower2, 1, 0}, {0, lower3, 1}}', ()),
    ('upperMatrix', '{{diag1, super1, 0}, {0, factored2, super2},\n  {0, 0, factored3}}', ()),
    ('tridiagonal', '{{diag1, super1, 0}, {sub2, diag2, super2},\n  {0, sub3, diag3}}', ()),
    ('solveFactored', 'LinearSolve[upperMatrix,\n  LinearSolve[lowerMatrix, rhs]]', ('rhs',)),
    ('rhsA', '{rA1, rA2, rA3}', ()),
    ('rhsB', '{rB1, rB2, rB3}', ()),
    ('segmentJet', '{segment[x, x0, x1, yLeft, yRight, mLeft, mRight],\n   D[segment[x, x0, x1, yLeft, yRight, mLeft, mRight], x],\n   D[segment[x, x0, x1, yLeft, yRight, mLeft, mRight], {x, 2}]}', ('yLeft', 'yRight', 'mLeft', 'mRight')),
    ('jetA', 'segmentJet[yA0, yA1, mA0, mA1]', ()),
    ('jetB', 'segmentJet[yB0, yB1, mB0, mB1]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-gvec-stability/radial_cubic_spline.wl')
