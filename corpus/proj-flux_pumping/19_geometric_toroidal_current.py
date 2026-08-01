"""Generated SymPy translation of ``corpus/proj-flux_pumping/19_geometric_toroidal_current.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 17 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('ass', 'r > 0 && capR > 0 && Bz > 0 && Element[iota, Reals]', ()),
    ('gTheta', 'r^2', ()),
    ('gZeta', 'capR^2', ()),
    ('Btheta', 'iota Bz', ()),
    ('Bzeta', 'Bz', ()),
    ('Bmag', 'Sqrt[gTheta Btheta^2 + gZeta Bzeta^2]', ()),
    ('jZeta', 'Jamp', ()),
    ('jTheta', '-Jamp', ()),
    ('jDotB', 'gTheta jTheta Btheta + gZeta jZeta Bzeta', ()),
    ('jPar', 'FullSimplify[jDotB/Bmag, ass]', ()),
    ('jParClosed', 'Jamp (capR^2 - r^2 iota)/Sqrt[r^2 iota^2 + capR^2]', ()),
    ('jZetaFromPar', 'jParVal Sqrt[r^2 iota^2 + capR^2]/(capR^2 - r^2 iota)', ()),
    ('jTorPhysical', 'capR jZetaFromPar', ()),
    ('jMagnitude', 'Sqrt[gTheta jTheta^2 + gZeta jZeta^2]', ()),
    ('bHat', '{Btheta, Bzeta}/Bmag', ()),
    ('jVec', '{jTheta, jZeta}', ()),
    ('gMat', 'DiagonalMatrix[{gTheta, gZeta}]', ()),
    ('jParVec', '((jVec.gMat.bHat)) bHat', ()),
    ('jPerpVec', 'FullSimplify[jVec - jParVec, ass]', ()),
    ('perpDerivative', 'FullSimplify[D[jPerpVec, iota] /. iota -> -1, ass]', ()),
    ('pVec', '{capR^2 Bzeta, -r^2 Btheta}', ()),
    ('jFamily', 'jParVal bHat + alpha pVec', ()),
    ('jNeo', '{jTheta, -jZeta}', ()),
    ('bNeo', '{Btheta, -Bzeta}/Bmag', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-flux_pumping/19_geometric_toroidal_current.wl')
