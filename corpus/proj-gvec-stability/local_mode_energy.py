"""Generated SymPy translation of ``corpus/proj-gvec-stability/local_mode_energy.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 9 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('pass', '0', ()),
    ('fail', '0', ()),
    ('check', 'If[TrueQ[FullSimplify[condition]],\n  pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]]', ('name', 'condition')),
    ('k', '{kx, ky, kz}', ()),
    ('b', '{bx, by, bz}', ()),
    ('n', '{nx, ny, nz}', ()),
    ('induction', '(b.k) IdentityMatrix[3] - Outer[Times, b, k]', ()),
    ('stiffness', 'Transpose[induction].induction/mu0 +\n  gamma pressure Outer[Times, k, k] - drive Outer[Times, n, n]', ()),
    ('xi', '{x1, x2, x3}', ()),
    ('qFromCross', 'Cross[k, Cross[xi, b]]', ()),
    ('special', 'FullSimplify[stiffness /. {\n    kx -> 0, ky -> 0, kz -> kpar,\n    bx -> 0, by -> 0, bz -> b0,\n    nx -> 1, ny -> 0, nz -> 0}]', ()),
    ('expected', 'DiagonalMatrix[{\n    b0^2 kpar^2/mu0 - drive,\n    b0^2 kpar^2/mu0,\n    gamma pressure kpar^2}]', ()),
    ('characteristic', 'Factor[Det[special - density omega2 IdentityMatrix[3]]]', ()),
    ('expectedCharacteristic', 'Product[expected[[i, i]] - density omega2, {i, 3}]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-gvec-stability/local_mode_energy.wl')
