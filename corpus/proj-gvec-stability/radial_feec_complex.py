"""Generated SymPy translation of ``corpus/proj-gvec-stability/radial_feec_complex.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 17 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('pass', '0', ()),
    ('fail', '0', ()),
    ('check', 'If[TrueQ[FullSimplify[condition]],\n  pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]]', ('name', 'condition')),
    ('openKnots', 'Join[\n  ConstantArray[First[breaks], degree + 1],\n  Flatten[ConstantArray[#, degree] & /@ Rest[Most[breaks]]],\n  ConstantArray[Last[breaks], degree + 1]]', ('breaks', 'degree')),
    ('incidence', 'Module[\n  {h1Count = Length[knots] - degree - 1, map, column, denominator},\n  map = ConstantArray[0, {h1Count - 1, h1Count}];\n  Do[\n   If[column > 1,\n    denominator = knots[[column + degree]] - knots[[column]];\n    map[[column - 1, column]] = degree/denominator];\n   If[column < h1Count,\n    denominator = knots[[column + degree + 1]] - knots[[column + 1]];\n    map[[column, column]] = -degree/denominator],\n   {column, 1, h1Count}];\n  map]', ('knots', 'degree')),
    ('breaks', '{0, 1/4, 2/3, 1}', ()),
    ('$Assumptions', 'Element[{s, power}, Reals] && s > 0', ()),
    ('storedField', 's^-power field[s]', ()),
    ('storedAxisField', 's axisAmplitude[s]', ()),
    ('physicalAxisField', 's^-(1 - m/2) storedAxisField', ()),
    ('gaussNodes', 'x /. Solve[LegendreP[5, x] == 0, x, Reals]', ()),
    ('gaussWeights', 'Table[\n  2/((1 - node^2) (D[LegendreP[5, x], x] /. x -> node)^2),\n  {node, gaussNodes}]', ()),
    ('kernelRows', 'Array[row, {4, 5}]', ()),
    ('energySigns', 'DiagonalMatrix[{1, 1, 1, -drive}]', ()),
    ('pointMatrix', 'Transpose[kernelRows] . energySigns . kernelRows', ()),
    ('normalValues', 'Array[h, 3]', ()),
    ('tangentialValues', 'Array[l, 2]', ()),
    ('normalCoefficients', 'Array[u, 3]', ()),
    ('tangentialCoefficients', 'Array[v, 2]', ()),
    ('massDensity', '(normalValues . normalCoefficients)^2 +\n  (tangentialValues . tangentialCoefficients)^2', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-gvec-stability/radial_feec_complex.wl')
