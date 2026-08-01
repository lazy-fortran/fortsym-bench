"""Generated SymPy translation of ``corpus/proj-flux_pumping/18_wp0_risk_bounds.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 19 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('R0', '165', ()),
    ('rCore', '10', ()),
    ('rhoLiD', '72/100', ()),
    ('meOverMD', '1/3672', ()),
    ('Eref', '5', ()),
    ('TeCore', '5/2', ()),
    ('ZDelta', '4/100', ()),
    ('IECCD', '1/10', ()),
    ('Ip', '8/10', ()),
    ('rhoLe', 'rhoLiD Sqrt[meOverMD (Ekev/Eref)]', ('Ekev',)),
    ('epsCore', 'rCore/R0', ()),
    ('DqPrimary', '1/100', ()),
    ('DqSideband', 'Abs[2 - 1]', ()),
    ('sidebandGeometric', 'epsCore', ()),
    ('sidebandResonant', 'epsCore (DqPrimary/DqSideband)', ()),
    ('widthRatio', 'rhoLe[Ekev]/rCore', ('Ekev',)),
    ('ZDeltaFast', 'ZDelta (TeCore/30)^(3/2)', ()),
    ('driveFraction', 'IECCD/Ip', ()),
    ('Jenv', 'Jc rr', ('rr',)),
    ('boundaryCurrent', 'Pi R0 rr d0 Jenv[rr] Cos[alpha]', ('rr',)),
    ('jBarAxis', 'd0 Cos[alpha]/(2 rr) D[rr Jenv[rr], rr] /. rr -> r', ()),
    ('aPot', '(rc^3/(4 rr)) (1 - Exp[-(rr/rc)^2])', ('rr',)),
    ('bcSeries', 'Normal@Series[boundaryCurrent[rr], {rr, 0, 2}]', ()),
    ('qAxis', '1', ()),
    ('rPot', '(2 qAxis rhoLiD)^(2/3) R0^(1/3)', ()),
    ('trappedDWidth', '6', ()),
    ('trappedEWidth', 'Sqrt[R0/rCore] rhoLe[TeCore]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-flux_pumping/18_wp0_risk_bounds.wl')
