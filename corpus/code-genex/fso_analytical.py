"""Generated SymPy translation of ``corpus/code-genex/fso_analytical.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 25 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('argv', 'Rest @ $ScriptCommandLine', ()),
    ('argc', 'Length @ argv', ()),
    ('equilibrium', 'argv[[argc]]', ()),
    ('CWD', 'Directory[]', ()),
    ('masses', '{1, 0.5}', ()),
    ('coordinatesystem', 'If[equilibrium == "salpha", "Cylindrical", "Cartesian"]', ()),
    ('rho', 'Switch[equilibrium, "slab", R, \\\n    "circular", CoordinateTransform["Cartesian" -> "Polar", {R, Z}][[1]], \\\n    "salpha", CoordinateTransform["Cartesian" -> "Polar", \\\n                                  {R - 1.0, Z}][[1]] / minorr]', ('R', 'Z')),
    ('theta', 'Switch[equilibrium, "slab", Z, \\\n    "circular", CoordinateTransform["Cartesian"-> "Polar", {R, Z}][[2]], \\\n    "salpha", CoordinateTransform["Cartesian"-> "Polar", {R - 1.0, Z}][[2]]]', ('R', 'Z')),
    ('jacobian', 'Switch[equilibrium, "slab", 1, "circular", 1, "salpha", R]', ('R',)),
    ('testfunc', 'Sin[2 * nrad * Pi * (rho[R, Z] - rhomin) / (rhomax - rhomin)] \\', ('R', 'phi', 'Z')),
    ('densi', '0.5 + Sin[nrad * Pi * (rho[R, Z] - rhomin) / (rhomax - rhomin)]^2 \\', ('R', 'phi', 'Z')),
    ('dense', '0.5 + Cos[nrad * Pi * (rho[R, Z] - rhomin) / (rhomax - rhomin)]^2 \\', ('R', 'phi', 'Z')),
    ('massdens', 'masses[[1]] * densi[R, phi, Z] + masses[[2]] * dense[R, phi, Z]', ('R', 'phi', 'Z')),
    ('lambdaohmslaw', 'densi[R, phi, Z] + dense[R, phi, Z]', ('R', 'phi', 'Z')),
    ('coqneq', 'jacobian[R] * (rhoref / Lref)^2 * massdens[R, phi, Z]', ('R', 'phi', 'Z')),
    ('bqneq', '-1 / jacobian[R] \\', ('R', 'phi', 'Z')),
    ('bampslaw', '-1 / jacobian[R] \\', ('R', 'phi', 'Z')),
    ('bbpareq', 'testfunc[R, phi, Z]', ('R', 'phi', 'Z')),
    ('bohmslaw', '-1 / jacobian[R] \\', ('R', 'phi', 'Z')),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/code-genex/fso_analytical.wl')
