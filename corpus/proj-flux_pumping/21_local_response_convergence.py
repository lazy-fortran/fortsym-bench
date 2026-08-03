"""Generated SymPy translation of ``corpus/proj-flux_pumping/21_local_response_convergence.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

import hashlib
import re

import sympy as sp

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 22 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('qh', 'q0 + cq x^p', ('x',)),
    ('jh', 'cj x^p', ('x',)),
    ('coarseDifference', 'qh[h/2] - qh[h]', ()),
    ('fineDifference', 'qh[h/4] - qh[h/2]', ()),
    ('physicalAccepted', 'screenPassed && profileConverged && forcesApplied &&', ()),
    ('endpointOnly', 'Piecewise[{{traceValue, x == x0}}, 0]', ('x',)),
    ('linear', 'aa + bb x', ('x',)),
    ('summaryPath', 'FileNameJoin[{DirectoryName[$InputFileName], "..", "runs",\n    "wp2_neo2", "helical_core_l1", "results",\n    "profile_convergence_18564705.json"}]', ()),
    ('summary', 'Import[summaryPath, "RawJSON"]', ()),
    ('pairs', 'summary["pair_errors"]', ()),
    ('l2Run', 'Lookup[pairs, "relative_l2"]', ()),
    ('linfRun', 'Lookup[pairs, "relative_linf"]', ()),
    ('coverageRun', 'Lookup[pairs, "compared_coordinate_fraction"]', ()),
    ('expectedOrder', 'Log[2, l2Run[[1]]/l2Run[[2]]]', ()),
    ('gammaN', 'nterm unitRoundoff/(1 - nterm unitRoundoff)', ()),
]


def _native_string_atom(literal):
    """Match the comparison atom emitted for a native Wolfram string."""
    digest = hashlib.sha256(f'"{literal}"'.encode('utf-8')).hexdigest()
    digest = re.sub(r'([eE][+-]?)0+(\d+)', r'\1\2', digest)
    return sp.Symbol('fortsymString' + digest)


def results():
    values = evaluate_assignments(
        _ASSIGNMENTS,
        'corpus/proj-flux_pumping/21_local_response_convergence.wl',
    )

    # The archived JSON summary is not present in this checkout.  The native
    # runner therefore keeps the import and its downstream lookups opaque;
    # preserve that source-level chain instead of embedding the unsupported
    # FileNameJoin or fabricating convergence measurements.
    string = _native_string_atom
    summary = sp.Function('Import')(sp.Symbol('summaryPath'), string('RawJSON'))
    pairs = sp.Function('summary')(string('pair_errors'))
    lookup = sp.Function('Lookup')
    values.update({
        'summary': summary,
        'pairs': pairs,
        'l2Run': lookup(pairs, string('relative_l2')),
        'linfRun': lookup(pairs, string('relative_linf')),
        'coverageRun': lookup(pairs, string('compared_coordinate_fraction')),
    })
    return values
