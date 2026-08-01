"""Generated SymPy translation of ``corpus/proj-gvec-stability/newcomb_axis_regularization.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 21 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('passed', '0', ()),
    ('failed', '0', ()),
    ('check', 'If[TrueQ[FullSimplify[condition]],\n  passed++; Print["PASS: ", name], failed++; Print["FAIL: ", name]]', ('name', 'condition')),
    ('$Assumptions', 'radius > 0 && coefficient > 0 &&', ()),
    ('cartesianPlusPower', 'Abs[mode + 1]', ('mode',)),
    ('cartesianMinusPower', 'Abs[mode - 1]', ('mode',)),
    ('radialPower', 'Min[cartesianPlusPower[mode],\n  cartesianMinusPower[mode]]', ('mode',)),
    ('fNonzeroMode', 'coefficient radius^3', ()),
    ('gNonzeroMode', 'coefficient (mode^2 - 1) radius', ()),
    ('nonzeroIndicial', 'Factor[\n  -D[fNonzeroMode D[radius^nu, radius], radius] +\n    gNonzeroMode radius^nu]', ()),
    ('fAxisymmetric', 'coefficient radius', ()),
    ('gAxisymmetric', 'coefficient/radius', ()),
    ('axisymmetricIndicial', 'Factor[\n  -D[fAxisymmetric D[radius^nu, radius], radius] +\n    gAxisymmetric radius^nu]', ()),
    ('axisymmetricRoots', 'nu /. Solve[axisymmetricIndicial == 0, nu, Reals]', ()),
    ('regularUnitMode', 'axisValue + curvature radius^2', ()),
    ('rawTraction', 'coefficient radius^3 D[regularUnitMode, radius] +\n  crossCoefficient radius^2 regularUnitMode', ()),
    ('integrand', "a[radius] xi[radius]^2 +\n  2 b[radius] xi[radius] xi'[radius] +\n  c[radius] xi'[radius]^2", ()),
    ('newcombIntegrand', "(a[radius] - b'[radius]) xi[radius]^2 +\n  c[radius] xi'[radius]^2", ()),
    ('thetaPinchC', '2 Pi^2 r^3/(1 + r^2)', ('r',)),
    ('manufacturedXi', '1 - r^2', ('r',)),
    ('exactBendingEnergy', "Integrate[\n  thetaPinchC[r] manufacturedXi'[r]^2, {r, 0, 1}]", ()),
    ('midpointEnergy', 'Sum[With[{\n    left = (cell - 1)/intervals,\n    right = cell/intervals,\n    midpoint = (cell - 1/2)/intervals},\n  thetaPinchC[midpoint]\n    ((manufacturedXi[right] - manufacturedXi[left]) intervals)^2/intervals],\n  {cell, 1, intervals}]', ('intervals',)),
    ('midpointErrors', 'N[Abs[midpointEnergy[#] - exactBendingEnergy] & /@\n    {16, 32, 64}, 30]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-gvec-stability/newcomb_axis_regularization.wl')
