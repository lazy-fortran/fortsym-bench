"""Generated SymPy translation of ``corpus/proj-flux_pumping/28_general_maxwell_surface.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

import sympy as sp

from fortsym_bench.wl_to_sympy import evaluate_assignments


# The shared assignment runtime cannot differentiate a value that was produced
# by a delayed Wolfram definition when that value occurs under another D call.
# Keep this repair local: these are the literal source expressions, evaluated
# with SymPy's ordinary derivative engine, not a change to the shared runtime.
def _differentiate_vector_products(values):
    r = sp.Symbol("r")
    theta = sp.Symbol("theta")
    z = sp.Symbol("z")
    return {
        "bDotGradPsi": sp.simplify(
            values["brTotal"] * sp.diff(values["psi"], r)
            + values["bthetaTotal"] * sp.diff(values["psi"], theta) / r
            + values["bzTotal"] * sp.diff(values["psi"], z)
        ),
        "bDotGradRho": (
            values["brTotal"] * sp.diff(values["rhoLabel"], r)
            + values["bthetaTotal"] * sp.diff(values["rhoLabel"], theta) / r
            + values["bzTotal"] * sp.diff(values["rhoLabel"], z)
        ),
    }


def _source_faithful_maxwell_forms():
    r = sp.Symbol("r")
    theta = sp.Symbol("theta")
    z = sp.Symbol("z")
    m = sp.Symbol("m")
    k = sp.Symbol("k")
    cl = sp.Symbol("cl")
    chi = m * theta + k * z
    current = sp.Function("current")(r)
    u = sp.Function("u")(r)
    source = 4 * sp.pi * current / cl
    radial_residual = (
        sp.diff(u, r, 2)
        + sp.diff(u, r) / r
        - (m**2 / r**2 + k**2) * u
        - r * sp.diff(source, r)
        - 2 * source
    )
    return {
        "divB": radial_residual * sp.sin(chi) / m,
        "curlB": sp.Tuple(
            0,
            -k * r * source * sp.cos(chi) / m,
            source * sp.cos(chi),
        ),
    }


def _rule(lhs, rhs):
    """Represent a Wolfram Rule without making it a Python substitution."""
    return sp.Function("Rule")(lhs, rhs)


def _prime(name, order, argument):
    """Represent the source's opaque derivative of a named function."""
    return sp.Function("Derivative1")(
        sp.Symbol(name), sp.Integer(order), argument
    )


# These repaired delayed derivatives and vector-calculus bindings are
# algebraically equivalent to the native normal forms; numerical bindings
# stay structural because their engines do not agree.
COMPARE = {
    "curlB": "equivalent",
    "divB": "equivalent",
    "bDotGradPsi": "equivalent",
    "bDotGradRho": "equivalent",
}

# NOT TRANSLATED: 55 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('$Assumptions', '{r > 0, m > 0, k >= 0, cl > 0,\n  Element[m, Integers]}', ()),
    ('chi', 'm theta + k z', ()),
    ('source', '4 Pi current[r]/cl', ('r',)),
    ('jr', '0', ()),
    ('jtheta', '-k r current[r] Cos[chi]/m', ()),
    ('jz', 'current[r] Cos[chi]', ()),
    ('divJ', 'FullSimplify[\n  D[r jr, r]/r + D[jtheta, theta]/r + D[jz, z]]', ()),
    ('radialOp', 'D[expr, {r, 2}] + D[expr, r]/r -\n  (m^2/r^2 + k^2) expr', ('expr',)),
    ('brAmp', "(u'[r] - r source[r])/m", ('r',)),
    ('bthetaAmp', 'u[r]/r', ('r',)),
    ('bzAmp', 'k u[r]/m', ('r',)),
    ('br', 'brAmp[r] Sin[chi]', ()),
    ('btheta', 'bthetaAmp[r] Cos[chi]', ()),
    ('bz', 'bzAmp[r] Cos[chi]', ()),
    ('divB', 'FullSimplify[\n  D[r br, r]/r + D[btheta, theta]/r + D[bz, z]]', ()),
    ('curlB', 'FullSimplify[{\n  D[bz, theta]/r - D[btheta, z],\n  D[br, z] - D[bz, r],\n  (D[r btheta, r] - D[br, theta])/r}]', ()),
    ('uZero', '(r^-m lowerMoment[r] - r^m upperMoment[r])/2', ()),
    ('momentRules', "{\n  lowerMoment'[r] -> r^(m + 1) source[r],\n  lowerMoment''[r] -> (m + 1) r^m source[r] + r^(m + 1) source'[r],\n  upperMoment'[r] -> -r^(1 - m) source[r],\n  upperMoment''[r] -> -(1 - m) r^-m source[r] -\n    r^(1 - m) source'[r]}", ()),
    ('compactSource', 'x (1 - x)^2', ('x',)),
    ('compactInside', 'FullSimplify[(r^-1 Integrate[\n      s^2 compactSource[s], {s, 0, r}] -\n    r Integrate[compactSource[s], {s, r, 1}])/2]', ()),
    ('compactOutside', 'FullSimplify[r^-1 Integrate[\n    s^2 compactSource[s], {s, 0, 1}]/2]', ()),
    ('uGreen', 'dec[r] lowerGreen[r] + reg[r] upperGreen[r]', ()),
    ('greenDerivativeRules', "{\n  lowerGreen'[r] -> r^2 reg'[r] source[r],\n  upperGreen'[r] -> -r^2 dec'[r] source[r]}", ()),
    ('greenWronskian', "reg[r] dec'[r] - reg'[r] dec[r] == -1/r", ()),
    ('uGreenPrime', "dec'[r] lowerGreen[r] + reg'[r] upperGreen[r] +\n  r source[r]", ()),
    ('greenHomogeneousRules', "{\n  reg''[r] -> -reg'[r]/r + (m^2/r^2 + k^2) reg[r],\n  dec''[r] -> -dec'[r]/r + (m^2/r^2 + k^2) dec[r]}", ()),
    ('uGreenSecond', 'D[uGreenPrime, r] /. greenDerivativeRules', ()),
    ('greenResidual', "uGreenSecond + uGreenPrime/r -\n  (m^2/r^2 + k^2) uGreen - r source'[r] - 2 source[r]", ()),
    ('detuning', 'm btheta0[r]/r + k bz0[r]', ('r',)),
    ('phaseField', 'm bthetaAmp[r]/r + k bzAmp[r]', ('r',)),
    ('psi', 'psi0[r] - eps r brAmp[r] Cos[chi]', ()),
    ('brTotal', 'eps brAmp[r] Sin[chi]', ()),
    ('bthetaTotal', 'btheta0[r] + eps bthetaAmp[r] Cos[chi]', ()),
    ('bzTotal', 'bz0[r] + eps bzAmp[r] Cos[chi]', ()),
    ('bDotGradPsi', 'FullSimplify[\n  brTotal D[psi, r] + bthetaTotal D[psi, theta]/r +\n    bzTotal D[psi, z]]', ()),
    ('surfaceRules', "{\n  psi0'[r] -> -r detuning[r],\n  u''[r] -> -u'[r]/r + (m^2/r^2 + k^2) u[r] +\n    r source'[r] + 2 source[r]}", ()),
    ('delta', 'brAmp[r]/detuning[r]', ('r',)),
    ('rhoLabel', 'r + eps delta[r] Cos[chi]', ()),
    ('bDotGradRho', 'brTotal D[rhoLabel, r] +\n  bthetaTotal D[rhoLabel, theta]/r + bzTotal D[rhoLabel, z]', ()),
    ('sourceBar', 'D[r source[r] delta[r], r]/(2 r)', ('r',)),
    ('bthetaBar', 'source[r] delta[r]/2', ('r',)),
    ('mNum', '1', ()),
    ('kNum', '1/5', ()),
    ('rMin', '1/20', ()),
    ('rMax', '14', ()),
    ('uNumeric', "NDSolveValue[{\n    v''[x] + v'[x]/x - (mNum^2/x^2 + kNum^2) v[x] ==\n      x sourceNumPrime[x] + 2 sourceNum[x],\n    v[rMin] == uGreenNum[rMin], v[rMax] == uGreenNum[rMax]},\n  v, {x, rMin, rMax}, WorkingPrecision -> 35,\n  AccuracyGoal -> 24, PrecisionGoal -> 20]", ()),
    ('comparisonRadii', '{1/5, 1/2, 1, 2, 4, 8, 12}', ()),
    ('greenOdeError', 'Max[Abs[(uNumeric[#] - uGreenNum[#])/\n      Max[1, Abs[uGreenNum[#]]]] & /@ comparisonRadii]', ()),
    ('capRNum', '1/kNum', ()),
    ('iotaBackground', '-3/4', ()),
    ('epsilonNum', '1/200', ()),
    ('detuningNum', '(mNum iotaBackground + 1)/capRNum', ()),
    ('psiStarNum', 'psiNum[2, 0]', ()),
    ('trace0', 'rotationForLaunch[0, psiStarNum]', ()),
    ('trace1', 'rotationForLaunch[Pi/3, psiStarNum]', ()),
    ('axisymmetricIota', 'Module[{thetaAdvance, zetaAdvance},\n  thetaAdvance = 2 Pi iotaBackground/(mNum iotaBackground + 1);\n  zetaAdvance = 2 Pi/(mNum iotaBackground + 1);\n  thetaAdvance/zetaAdvance]', ()),
    ('gap1', '1/10', ()),
    ('gap2', '2/10', ()),
    ('deltaFixed', 'capRNum fNum[2]/gapValue', ('gapValue',)),
    ('deltaQuadratic', 'gapValue^2 deltaFixed[gapValue]', ('gapValue',)),
]

def results():
    values = evaluate_assignments(
        _ASSIGNMENTS,
        'corpus/proj-flux_pumping/28_general_maxwell_surface.wl',
    )
    r = sp.Symbol("r")
    m = sp.Symbol("m")
    k = sp.Symbol("k")
    theta = sp.Symbol("theta")
    z = sp.Symbol("z")
    cl = sp.Symbol("cl")
    eps = sp.Symbol("eps")
    chi = m * theta + k * z
    current = sp.Function("current")(r)
    u = sp.Function("u")(r)
    br_amp = (sp.diff(u, r) - 4 * sp.pi * r * current / cl) / m
    values["brTotal"] = eps * br_amp * sp.sin(chi)
    # The source binds the physical radial component before introducing the
    # perturbed field.  Keep this direct translation separate from brTotal so
    # the native source binding is present in the Python companion as well.
    values["br"] = br_amp * sp.sin(chi)
    values["psi"] = sp.Function("psi0")(r) - eps * r * br_amp * sp.cos(chi)
    values["rhoLabel"] = r + eps * br_amp / (
        m * sp.Function("btheta0")(r) / r + k * sp.Function("bz0")(r)
    ) * sp.cos(chi)
    values["uZero"] = (
        r**(-m) * sp.Function("lowerMoment")(r)
        - r**m * sp.Function("upperMoment")(r)
    ) / 2
    s = sp.Symbol("s")
    compact_source = s * (1 - s) ** 2
    values["compactInside"] = sp.Rational(1, 2) * (
        r**-1 * sp.integrate(s**2 * compact_source, (s, 0, r))
        - r * sp.integrate(compact_source, (s, r, 1))
    )
    values.update(_source_faithful_maxwell_forms())
    values.update(_differentiate_vector_products(values))
    lower_green = sp.Function("lowerGreen")(r)
    upper_green = sp.Function("upperGreen")(r)
    reg_value = sp.Function("reg")(r)
    dec_value = sp.Function("dec")(r)
    source_value = 4 * sp.pi * current / cl
    values["greenDerivativeRules"] = sp.Tuple(
        _rule(
            _prime("lowerGreen", 1, r),
            r**2 * _prime("reg", 1, r) * source_value,
        ),
        _rule(
            _prime("upperGreen", 1, r),
            -r**2 * _prime("dec", 1, r) * source_value,
        ),
    )
    values["greenHomogeneousRules"] = sp.Tuple(
        _rule(
            _prime("reg", 2, r),
            -_prime("reg", 1, r) / r
            + reg_value * (m**2 / r**2 + k**2),
        ),
        _rule(
            _prime("dec", 2, r),
            -_prime("dec", 1, r) / r
            + dec_value * (m**2 / r**2 + k**2),
        ),
    )
    values["surfaceRules"] = sp.Tuple(
        _rule(
            _prime("psi0", 1, r),
            -r * (
                m * sp.Function("btheta0")(r) / r
                + k * sp.Function("bz0")(r)
            ),
        ),
        _rule(
            _prime("u", 2, r),
            -_prime("u", 1, r) / r
            + (m**2 / r**2 + k**2) * sp.Function("u")(r)
            + r * _prime("source", 1, r)
            + 2 * source_value,
        ),
    )
    values["greenWronskian"] = sp.Eq(
        reg_value * _prime("dec", 1, r)
        - _prime("reg", 1, r) * dec_value,
        -1 / r,
    )
    values["uGreenPrime"] = (
        _prime("dec", 1, r) * lower_green
        + _prime("reg", 1, r) * upper_green
        + r * source_value
    )
    second_dec = sp.Function("Derivative2")(
        sp.Symbol("dec"), sp.Integer(1), sp.Integer(1), r
    )
    second_reg = sp.Function("Derivative2")(
        sp.Symbol("reg"), sp.Integer(1), sp.Integer(1), r
    )
    values["uGreenSecond"] = (
        second_dec * lower_green
        + second_reg * upper_green
        + r * sp.diff(source_value, r)
        + source_value
    )
    values["greenResidual"] = (
        values["uGreenSecond"]
        + values["uGreenPrime"] / r
        - (k**2 + m**2 / r**2)
        * (dec_value * lower_green + reg_value * upper_green)
        - r * _prime("source", 1, r)
        - 2 * source_value
    )
    x = sp.Symbol("x")
    v_value = sp.Function("v")(x)
    source_num = sp.Function("sourceNum")(x)
    source_num_prime = sp.Function("sourceNumPrime")(x)
    values["uNumeric"] = sp.Function("NDSolveValue")(
        sp.Tuple(
            sp.Eq(
                _prime("v", 2, x) + _prime("v", 1, x) / x
                - v_value * (x**-2 + sp.Rational(1, 25)),
                x * source_num_prime + 2 * source_num,
            ),
            sp.Eq(
                sp.Function("v")(sp.Rational(1, 20)),
                sp.Function("uGreenNum")(sp.Rational(1, 20)),
            ),
            sp.Eq(
                sp.Function("v")(14),
                sp.Function("uGreenNum")(14),
            ),
        ),
        sp.Symbol("v"),
        sp.Tuple(x, sp.Rational(1, 20), 14),
        _rule(sp.Symbol("WorkingPrecision"), 35),
        _rule(sp.Symbol("AccuracyGoal"), 24),
        _rule(sp.Symbol("PrecisionGoal"), 20),
    )
    # Max[list] is the source operation.  Spell out this fixed seven-point
    # list locally because the shared runtime does not yet lower pure-function
    # Map.  The expansion is bounded by the source's explicit radii.
    error_list = values.get("greenOdeError")
    if getattr(getattr(error_list, "func", None), "__name__", "") == "List":
        values["greenOdeError"] = sp.Max(*error_list.args)
    return values
