"""Generated SymPy translation of ``corpus/proj-flux_pumping/31_pitch_crossing_geometry.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 26 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('magneticField', 'magneticOffset + magneticSlope coordinate', ('coordinate',)),
    ('crossing', '(1/pitch - magneticOffset)/magneticSlope', ()),
    ('leftWeight', '(phiRight - crossing)/(phiRight - phiLeft)', ()),
    ('rightWeight', '(crossing - phiLeft)/(phiRight - phiLeft)', ()),
    ('metric', '2 magneticField[coordinate] + 3 coordinate', ('coordinate',)),
    ('geodesic', '5 - coordinate + coordinate^2', ('coordinate',)),
    ('pitchBandVector', 'constantDistribution {eta1 - eta0, eta2 - eta1}', ()),
    ('cellDivergence', '{\n  (flux0 - flux1)/width1,\n  (flux1 - flux2)/width2,\n  (flux2 - flux3)/width3}', ()),
    ('remeshedPeriod', '{0, crossing, period}', ()),
    ('scaledCrossingProduct', '(dimensionlessPitch/fieldScale)*\n    (fieldScale*dimensionlessField[dimensionlessCoordinate])', ()),
    ('scaledLogDerivative', 'D[Log[fieldScale dimensionlessField[phi/coordinateScale]], phi]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-flux_pumping/31_pitch_crossing_geometry.wl')
