"""Generated SymPy translation of ``corpus/proj-gvec-stability/generalized_profile_certificate.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

import sympy as sp

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 13 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('pass', '0', ()),
    ('fail', '0', ()),
    ('check', 'If[TrueQ[FullSimplify[condition]],\n  pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]]', ('name', 'condition')),
    ('k', '{{k11, k12}, {k12, k22}}', ()),
    ('m', '{{m11, m12}, {m12, m22}}', ()),
    ('s', 'DiagonalMatrix[{s1, s2}]', ()),
    ('y', '{y1, y2}', ()),
    ('x', 's . y', ()),
    ('a', 's . k . s', ()),
    ('b', 's . m . s', ()),
    ('c', 's . (k - sigma m) . s', ()),
    ('assumptions', 'Element[{k11, k12, k22, m11, m12, m22, s1, s2,\n     y1, y2, lambda, sigma}, Reals] && s1 != 0 && s2 != 0', ()),
    ('u', '{{u11, u12}, {0, u22}}', ()),
    ('bCholesky', 'Transpose[u] . u', ()),
    ('aGeneral', '{{a11, a12}, {a12, a22}}', ()),
    ('z', 'u . y', ()),
    ('aStandard', 'Inverse[Transpose[u]] . aGeneral . Inverse[u]', ()),
    ('rGeneral', 'aGeneral . y - lambda bCholesky . y', ()),
    ('rStandard', 'Inverse[Transpose[u]] . rGeneral', ()),
    ('choleskyAssumptions', 'Element[{u11, u12, u22, a11, a12, a22,\n     y1, y2, lambda}, Reals] && u11 != 0 && u22 != 0', ()),
    ('twoLevel', 'DiagonalMatrix[{lambda1, lambda2}]', ()),
    ('trial', '{Cos[theta], Sin[theta]}', ()),
    ('rayleigh', 'FullSimplify[trial . twoLevel . trial]', ()),
    ('trialResidual', 'FullSimplify[twoLevel . trial - rayleigh trial]', ()),
    ('residualNorm', 'FullSimplify[Sqrt[trialResidual . trialResidual],\n  0 < theta < Pi/2 && lambda2 > lambda1]', ()),
    ('unwantedSeparation', 'FullSimplify[lambda2 - rayleigh,\n  0 < theta < Pi/2 && lambda2 > lambda1]', ()),
]

def results():
    values = evaluate_assignments(
        _ASSIGNMENTS,
        'corpus/proj-gvec-stability/generalized_profile_certificate.wl',
    )

    # The shared evaluator cannot parse Wolfram's ``lambda`` identifier as a
    # Python expression.  Preserve the source's direct residual assignments
    # explicitly; these are scalar/vector algebra, not guesses about the
    # unresolved FullSimplify/Dot rows.
    lam = sp.Symbol('lambda')
    u11, u12, u22 = sp.symbols('u11 u12 u22')
    a11, a12, a22 = sp.symbols('a11 a12 a22')
    y1, y2 = sp.symbols('y1 y2')
    r_general = sp.Tuple(
        a11 * y1 + a12 * y2 - lam * (u11**2 * y1 + u11 * u12 * y2),
        a12 * y1 + a22 * y2
        - lam * (u11 * u12 * y1 + (u12**2 + u22**2) * y2),
    )
    values['rGeneral'] = r_general
    values['rStandard'] = sp.Tuple(
        r_general[0] / u11,
        -u12 * r_general[0] / (u11 * u22) + r_general[1] / u22,
    )

    # Native fortsym-wl retains ``rayleigh`` here because the preceding
    # matrix Dot is outside its simplification boundary.  Keep that
    # source-visible form rather than silently replacing it with a guessed
    # closed form.
    lambda1, lambda2, theta, rayleigh = sp.symbols(
        'lambda1 lambda2 theta rayleigh'
    )
    values['residualNorm'] = sp.sqrt(
        (lambda1 * sp.cos(theta) - rayleigh * sp.cos(theta)) ** 2
        + (lambda2 * sp.sin(theta) - rayleigh * sp.sin(theta)) ** 2
    )
    values['unwantedSeparation'] = lambda2 - rayleigh
    return values
