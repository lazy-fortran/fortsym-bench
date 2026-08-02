"""Generated SymPy translation of ``corpus/proj-flux_pumping/04_validity_estimates.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 11 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('clight', '2.99792458 10^10', ()),
    ('e', '4.80320425 10^-10', ()),
    ('mD', '3.34358377 10^-24', ()),
    ('erg', '1.602176634 10^-12', ()),
    ('EkeV', '5 10^3 erg', ()),
    ('B0', '2 10^4', ()),
    ('qsaf', '1', ()),
    ('Rmaj', '170.', ()),
    ('rmin', '10.', ()),
    ('vD', 'Sqrt[2 EkeV/mD]', ()),
    ('rhoL', 'mD vD clight/(e B0)', ()),
    ('drp', '2 qsaf rhoL', ()),
    ('drt', 'drp Sqrt[Rmaj/rmin]', ()),
    ('ft', 'Sqrt[rmin/Rmaj]', ()),
]

# The Wolfram and SymPy oracles retain different guard digits for these
# decimal inputs. Their source formulas are identical, so compare the
# resulting numeric values at the precision carried by each backend.
COMPARE = {
    name: 'numeric'
    for name in ('e', 'mD', 'EkeV', 'vD', 'rhoL', 'drp', 'drt', 'ft')
}

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-flux_pumping/04_validity_estimates.wl')
