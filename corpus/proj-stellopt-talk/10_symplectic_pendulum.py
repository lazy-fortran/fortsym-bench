"""Generated SymPy translation of ``corpus/proj-stellopt-talk/10_symplectic_pendulum.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 15 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('failed', '0', ()),
    ('sympMap', '{q + h (p - h Sin[q]), p - h Sin[q]}', ()),
    ('explMap', '{q + h p, p - h Sin[q]}', ()),
    ('detS', 'Simplify[Det[D[sympMap, {{q, p}}]]]', ()),
    ('detE', 'Simplify[Det[D[explMap, {{q, p}}]]]', ()),
    ('ham', 'Function[{qq, pp}, pp^2/2 - Cos[qq]]', ()),
    ('hh', '0.01', ()),
    ('n', '100000', ()),
    ('q0', '1.5', ()),
    ('p0', '0.', ()),
    ('h0', 'ham[q0, p0]', ()),
    ('qs', 'q0', ()),
    ('ps', 'p0', ()),
    ('maxdS', '0.', ()),
    ('maxdSHalf', '0.', ()),
    ('qe', 'q0', ()),
    ('pe', 'p0', ()),
    ('cps', '{}', ()),
    ('dEfinal', 'Last[cps]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-stellopt-talk/10_symplectic_pendulum.wl')
