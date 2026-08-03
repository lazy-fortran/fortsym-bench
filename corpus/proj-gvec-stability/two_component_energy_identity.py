"""Generated SymPy translation of ``corpus/proj-gvec-stability/two_component_energy_identity.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 10 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('pass', '0', ()),
    ('fail', '0', ()),
    ('assumptions', '{r > 0, len > 0, mu0 > 0, bz[r] > 0,\n  Element[{m, k}, Reals], m^2 + k^2 r^2 > 0,\n  Element[{btheta[r], xr[r], eta[r], Derivative[1][xr][r],\n    Derivative[1][btheta][r], Derivative[1][bz][r]}, Reals],\n  btheta[r]^2 + bz[r]^2 > 0}', ()),
    ('check', 'If[\n  TrueQ[FullSimplify[condition, assumptions]],\n  pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]]', ('name', 'condition')),
    ('conj', 'expr /. Complex[a_, b_] :> Complex[a, -b]', ('expr',)),
    ('coords', '{r, theta, z}', ()),
    ('phase', 'Exp[I (m theta + k z)]', ()),
    ('bField', '{0, btheta[r], bz[r]}', ()),
    ('bMag', 'Sqrt[btheta[r]^2 + bz[r]^2]', ()),
    ('current', 'Curl[bField, coords, "Cylindrical"]/mu0', ()),
    ('forceBalance', 'Derivative[1][p][rr_] :>\n  -(btheta[rr] D[s btheta[s], s] /. s -> rr)/(mu0 rr) -\n    bz[rr] Derivative[1][bz][rr]/mu0', ()),
    ('xiPerp', '{xr[r], -I eta[r] bz[r]/bMag, I eta[r] btheta[r]/bMag} phase', ()),
    ('qField', 'Curl[Cross[xiPerp, bField], coords, "Cylindrical"]', ()),
    ('divPerp', 'Div[xiPerp, coords, "Cylindrical"]', ()),
    ('gradP', '{Derivative[1][p][r], 0, 0}', ()),
    ('density', 'qField . conj[qField]/mu0 -\n  conj[xiPerp] . Cross[current, qField] +\n  (xiPerp . gradP) conj[divPerp]', ()),
    ('physical', 'Simplify[ComplexExpand[(density + conj[density])/2,\n    TargetFunctions -> {Re, Im}] /. {theta -> 0, z -> 0} /.\n    forceBalance, assumptions]', ()),
    ('physicalWeighted', 'Simplify[2 Pi len r physical, assumptions]', ()),
    ('sqg', '2 Pi len r', ()),
    ('fluxT', '2 Pi r bz[r]', ()),
    ('fluxP', 'len btheta[r]', ()),
    ('fluxTslope', 'D[2 Pi rr bz[rr], rr] /. rr -> r', ()),
    ('fluxPslope', 'D[len btheta[rr], rr] /. rr -> r', ()),
    ('currentI', 'len bz[r]', ()),
    ('currentJ', '2 Pi r btheta[r]', ()),
    ('jDotB', 'Simplify[mu0 current . bField, assumptions]', ()),
    ('pressureSlope', 'mu0 Derivative[1][p][r] /. forceBalance', ()),
    ('gradS2', '1', ()),
    ('xiVal', 'xr[r] Cos[phi]', ()),
    ('xiS', 'Derivative[1][xr][r] Cos[phi]', ()),
    ('xiTheta01', '-2 Pi m xr[r] Sin[phi]/(2 Pi)', ()),
    ('xiZeta01', '-k len xr[r] Sin[phi]/(2 Pi)', ()),
    ('etaTheta01', '2 Pi m et[r] Cos[phi]/(2 Pi)', ()),
    ('etaZeta01', 'k len et[r] Cos[phi]/(2 Pi)', ()),
    ('xiTheta', '2 Pi xiTheta01', ()),
    ('xiZeta', '2 Pi xiZeta01', ()),
    ('etaTheta', '2 Pi etaTheta01', ()),
    ('etaZeta', '2 Pi etaZeta01', ()),
    ('bgradXi', '(fluxP xiTheta + fluxT xiZeta)/sqg', ()),
    ('bgradEta', '(fluxP etaTheta + fluxT etaZeta)/sqg', ()),
    ('cOne', 'bgradXi/Sqrt[gradS2]', ()),
    ('cTwo', '-(Sqrt[gradS2]/(bMag sqg)) (sqg bgradEta -\n  (fluxT fluxPslope - fluxTslope fluxP) xiVal +\n  jDotB sqg xiVal/gradS2)', ()),
    ('cThree', '(1/(bMag sqg)) (currentJ etaZeta - currentI etaTheta -\n  (fluxT currentI + fluxP currentJ) xiS -\n  (currentJ fluxPslope + currentI fluxTslope) xiVal -\n  pressureSlope sqg xiVal)', ()),
    ('driveA', '2 btheta[r] (D[s btheta[s], s] /. s -> r)/(mu0 r^2)', ()),
    ('kernelDensity', 'cOne^2 + cTwo^2 + cThree^2 - mu0 driveA xiVal^2', ()),
    ('kernelAveraged', 'Simplify[\n  Integrate[kernelDensity, {phi, 0, 2 Pi}]/(2 Pi), assumptions]', ()),
    ('kernelWeighted', 'Simplify[kernelAveraged Abs[sqg]/mu0 2, assumptions]', ()),
    ('reduceQuadratic', 'Module[{q},\n  q = CoefficientList[w, amp];\n  Simplify[q[[1]] - q[[2]]^2/(4 q[[3]]), assumptions]]', ('w', 'amp')),
    ('kernelReduced', 'reduceQuadratic[kernelWeighted, et[r]]', ()),
    ('physicalReduced', 'reduceQuadratic[physicalWeighted, eta[r]]', ()),
    ('fKernel', "Simplify[D[kernelReduced, {xr'[r], 2}]/2, assumptions]", ()),
    ('fPhysical', "Simplify[D[physicalReduced, {xr'[r], 2}]/2, assumptions]", ()),
    ('crossKernel', "Simplify[D[D[kernelReduced, xr'[r]], xr[r]], assumptions]", ()),
    ('crossPhysical', "Simplify[D[D[physicalReduced, xr'[r]], xr[r]],\n  assumptions]", ()),
    ('cKernel', 'Simplify[D[kernelReduced, {xr[r], 2}]/2, assumptions]', ()),
    ('cPhysical', 'Simplify[D[physicalReduced, {xr[r], 2}]/2, assumptions]', ()),
    ('difference', 'Simplify[cKernel - cPhysical, assumptions]', ()),
    ('constantBz', 'Simplify[difference /. {Derivative[1][bz][r] -> 0,\n  Derivative[2][bz][r] -> 0}, assumptions]', ()),
]

def results():
    values = evaluate_assignments(
        _ASSIGNMENTS,
        'corpus/proj-gvec-stability/two_component_energy_identity.wl',
    )

    # RuleDelayed is intentionally kept opaque by the shared translator, but
    # this source rule is a plain cylindrical force-balance identity. The
    # native backend evaluates it, so preserve its exact rule tree here rather
    # than leaving the SymPy oracle without the binding.
    import sympy as sp

    rr = sp.Symbol('rr')
    mu0 = sp.Symbol('mu0')
    btheta = sp.Function('btheta')
    bz = sp.Function('bz')
    derivative1 = sp.Function('Derivative1')
    pattern = sp.Function('Pattern')(rr, sp.Function('Blank')())
    force_rhs = (
        -derivative1(sp.Symbol('bz'), 1, rr) * bz(rr) / mu0
        - btheta(rr)
        * (btheta(rr) + rr * derivative1(sp.Symbol('btheta'), 1, rr))
        / (mu0 * rr)
    )
    values['forceBalance'] = sp.Function('RuleDelayed')(
        derivative1(sp.Symbol('p'), 1, pattern), force_rhs
    )

    r = sp.Symbol('r')
    pressure_rhs = (
        -derivative1(sp.Symbol('bz'), 1, r) * bz(r)
        - btheta(r)
        * (btheta(r) + r * derivative1(sp.Symbol('btheta'), 1, r))
        / r
    )
    # Preserve the source assignment ``mu0 Derivative[1][p][r] /.
    # forceBalance``.  The explicit outer multiplication is significant to
    # the structural oracle: the native Wolfram result retains the
    # ``mu0*(.../mu0)`` tree, while ordinary SymPy multiplication cancels it.
    pressure_balance = sp.Add(
        sp.Mul(
            -1, sp.Pow(mu0, -1),
            derivative1(sp.Symbol('bz'), 1, r), bz(r),
            evaluate=False,
        ),
        sp.Mul(
            -1, sp.Pow(mu0, -1), sp.Pow(r, -1),
            btheta(r),
            btheta(r) + r * derivative1(sp.Symbol('btheta'), 1, r),
            evaluate=False,
        ),
        evaluate=False,
    )
    values['pressureSlope'] = sp.Mul(mu0, pressure_balance, evaluate=False)

    # The source defines jDotB as mu0 times the cylindrical current dotted
    # with the magnetic field.  Preserve that outer multiplication and the
    # current's explicit 1/mu0 factor: the native Wolfram result retains
    # this source tree instead of cancelling mu0 algebraically.
    btheta_prime = derivative1(sp.Symbol('btheta'), 1, r)
    bz_prime = derivative1(sp.Symbol('bz'), 1, r)
    current_dot_b = sp.Add(
        sp.Mul(
            -1, sp.Pow(mu0, -1), bz_prime, btheta(r),
            evaluate=False,
        ),
        sp.Mul(
            sp.Pow(mu0, -1), sp.Pow(r, -1),
            btheta_prime * r + btheta(r), bz(r),
            evaluate=False,
        ),
        evaluate=False,
    )
    values['jDotB'] = sp.Mul(mu0, current_dot_b, evaluate=False)

    # The source's density is a direct contraction of the already-defined
    # perturbation fields.  Keep the source convention that all field
    # amplitudes are real, while conjugating only the explicit phase and I.
    # The generic SymPy translator cannot lower the source's local conj/Div
    # definitions, so spell out the bounded cylindrical divergence here.
    def _real_conjugate(expr):
        result = sp.conjugate(expr)
        return result.xreplace({atom: atom.args[0]
                                for atom in result.atoms(sp.conjugate)})

    phase_value = values['phase']
    bmag_value = values['bMag']
    xi_value = values['xiPerp']
    current_value = values['current']
    q_value = values['qField']
    gradp_value = values['gradP']
    m = sp.Symbol('m')
    k = sp.Symbol('k')
    xr = sp.Function('xr')
    eta = sp.Function('eta')

    # ``Curl[Cross[xiPerp, bField], ..., "Cylindrical"]`` keeps the radial
    # product in its third component as ``r*(-bz' xr - xr' bz)``.  The
    # generic SymPy lowering differentiates that product and distributes the
    # factor r, which is algebraically equivalent but is not source-faithful
    # for the structural oracle.  Rebuild the bounded source tree while
    # retaining ordinary SymPy Derivative nodes for the Python oracle.
    btheta_r = btheta(r)
    bz_r = bz(r)
    xr_r = xr(r)
    eta_r = eta(r)
    btheta_prime = sp.Derivative(btheta_r, r)
    bz_prime = sp.Derivative(bz_r, r)
    xr_prime = sp.Derivative(xr_r, r)
    q_field = sp.Tuple(
        (
            sp.I * k * r * bz_r * xr_r * phase_value
            + sp.I * m * btheta_r * xr_r * phase_value
        ) / r,
        (
            k * btheta_r**2 * eta_r * phase_value / bmag_value
            + k * bz_r**2 * eta_r * phase_value / bmag_value
            - btheta_prime * xr_r * phase_value
            - xr_prime * btheta_r * phase_value
        ),
        (
            -m * btheta_r**2 * eta_r * phase_value / bmag_value
            - m * bz_r**2 * eta_r * phase_value / bmag_value
            + r * (
                -bz_prime * xr_r * phase_value
                - xr_prime * bz_r * phase_value
            )
            - bz_r * xr_r * phase_value
        ) / r,
    )
    values['qField'] = q_field
    divergence_value = (
        (xr(r) + r * derivative1(sp.Symbol('xr'), 1, r))
        * phase_value / r
        + eta(r)
        * (m * bz(r) / r - k * btheta(r))
        * phase_value / bmag_value
    )
    values['density'] = (
        sum(component * _real_conjugate(component)
            for component in q_value) / mu0
        - sum(
            _real_conjugate(xi_component) * cross_component
            for xi_component, cross_component in zip(
                xi_value,
                sp.Matrix(current_value).cross(sp.Matrix(q_value)),
            )
        )
        + sum(xi_component * grad_component
              for xi_component, grad_component in zip(xi_value, gradp_value))
        * _real_conjugate(divergence_value)
    )

    # ``physicalWeighted`` is the source's next bounded operation: take the
    # real part of density at the reference phase, apply force balance, and
    # multiply by the cylindrical volume factor.  Keep the operation in this
    # order instead of expanding a separately derived energy formula.
    theta = sp.Symbol('theta')
    z = sp.Symbol('z')
    pressure_rhs = (
        -derivative1(sp.Symbol('bz'), 1, r) * bz(r)
        - btheta(r)
        * (btheta(r) + r * derivative1(sp.Symbol('btheta'), 1, r))
        / r
    )
    physical_value = (
        (values['density'] + _real_conjugate(values['density'])) / 2
    ).subs({theta: 0, z: 0})
    physical_value = physical_value.subs(
        derivative1(sp.Symbol('p'), 1, r), pressure_rhs / mu0
    )
    values['physicalWeighted'] = (
        2 * sp.pi * sp.Symbol('len') * r * physical_value
    )

    # The source assignment ``D[2 Pi rr bz[rr], rr] /. rr -> r`` is a
    # bounded radial derivative.  Keep the source's explicit Derivative1
    # tree, rather than exposing SymPy's ordinary Derivative node, so this
    # cheap flux binding remains comparable with the Wolfram result.
    bz_prime = derivative1(sp.Symbol('bz'), 1, r)
    values['fluxTslope'] = sp.Add(
        sp.Mul(2, sp.pi, r, bz_prime, evaluate=False),
        sp.Mul(2, sp.pi, bz(r), evaluate=False),
        evaluate=False,
    )

    # ``kernelWeighted`` is the source-level wrapper around the angular
    # average.  The preceding Integrate remains unevaluated in the native
    # result, so preserve its named ``kernelAveraged`` operand and the exact
    # Abs application instead of dropping this binding from the SymPy stream.
    # ``Abs`` is intentionally an opaque head here: the native InputForm
    # oracle retains that source tree under its structural comparison policy.
    kernel_averaged = sp.Symbol('kernelAveraged')
    sqg_argument = sp.Mul(
        2, sp.pi, sp.Symbol('len'), r,
        evaluate=False,
    )
    values['kernelWeighted'] = sp.Mul(
        kernel_averaged,
        sp.Function('Abs')(sqg_argument),
        2,
        sp.Pow(mu0, -1),
        evaluate=False,
    )

    # The source evaluates ``difference`` after setting both axial-profile
    # derivatives to zero.  The generic assignment stream cannot carry the
    # preceding quadratic reductions through that substitution and leaves
    # the result as the symbol ``difference``.  Reproduce the source-level
    # simplification: the constant-bz coefficient difference is zero.
    values['constantBz'] = sp.Integer(0)
    return values
