"""Generated SymPy translation of ``corpus/archive-tu/math14u.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 44 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('c', '{0, 0, 0}', ()),
    ('a', '{1, 0, 0}', ()),
    ('b', '{0, 0, 1}', ()),
    ('p', '{0, 1, 0}', ()),
    ('UnitNormal', 'Normalize[Cross[a, b]]', ('a', 'b')),
    ('PlaneDistance', 'Abs[UnitNormal[a, b] . (p - b)]', ('a', 'b', 'c', 'p')),
    ('F', '{(x + I*y)^2*z^2, (x + I*y)^2*z}', ()),
    ('CalcArea', '(1/2)*Abs[Cross[({#1[[1]], #1[[2]], 0} & )[r1 - r2], ({#1[[1]], #1[[2]], 0} & )[r1 - r3]]]', ('r1', 'r2', 'r3')),
    ('CheckInOnTriangle', 'If[CalcArea[r, r1, r2] + CalcArea[r, r1, r3] + CalcArea[r, r2, r3] == CalcArea[r1, r2, r3], If[CalcArea[r, r1, r2] != {0, 0, 0} && CalcArea[r, r1, r3] != {0, 0, 0} && CalcArea[r, r2, r3] != {0, 0, 0}, "In", "On"], "Out"]', ('r1', 'r2', 'r3', 'r')),
    ('P', '{1, 2, 3}', ()),
    ('P', '{3, 3*(Pi/7), 0.3*Pi}', ()),
    ('Pc', 'CoordinatesToCartesian[P, Spherical]', ()),
    ('a', '2', ()),
    ('ar', '{a*t, t, 0}', ()),
    ('d', 'ArcLengthFactor[ar, t]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/archive-tu/math14u.wl')
