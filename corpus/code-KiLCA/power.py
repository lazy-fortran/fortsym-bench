"""Generated SymPy translation of ``corpus/code-KiLCA/power.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 40 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('S', '{{omc^2*Wf[0, 0], omc*Vth*Wf[0, 0] + omc*hth*Wf[0, 1], omc*Vz*Wf[0, 0] + omc*hz*Wf[0, 1]}, {Vth*omc*Wf[0, 0] + hth*omc*Wf[0, 1], Vth^2*Wf[0, 0] + 2*hth*Vth*Wf[0, 1] + hth^2*Wf[1, 1], Vth*Vz*Wf[0, 0] + (hth*Vz + hz*Vth)*Wf[0, 1] + hth*hz*Wf[1, 1]}, {Vz*omc*Wf[0, 0] + hz*omc*Wf[0, 1], Vth*Vz*Wf[0, 0] + (hth*Vz + hz*Vth)*Wf[0, 1] + hth*hz*Wf[1, 1], Vz^2*Wf[0, 0] + 2*hz*Vz*Wf[0, 1] + hz^2*Wf[1, 1]}}', ()),
    ('L', 'Eigenvalues[S]', ()),
    ('W00', 'FullSimplify[J1der[0, 0, nu]]', ()),
    ('JLimT', 'Sqrt[2*Pi]*Vt*((1/(Vt*Abs[kp]))*(E^(((omega - omega0)*(-omega + omega0 + 2*(alpha + beta)*kp*Vt^2))/(2*kp^2*Vt^2))*Sqrt[Pi/2]*(1 - I*Erfi[((-omega + omega0 + (alpha + beta)*kp*Vt^2)*Abs[kp])/(Sqrt[2]*kp^2*Vt)])))', ()),
    ('a1', 'FullSimplify[Re[J1derNC[0, 1, nu]]^2, Assumptions -> {Element[{Vt, omega, omega0, kp}, Reals], kp > 0, Vt > 0}]', ()),
    ('a2', 'FullSimplify[Re[J1derNC[0, 0, nu]], Assumptions -> {Element[{Vt, omega, omega0, kp}, Reals], kp > 0, Vt > 0}]', ()),
    ('a3', 'FullSimplify[Re[J1derNC[1, 1, nu]], Assumptions -> {Element[{Vt, omega, omega0, kp}, Reals], kp > 0, Vt > 0}]', ()),
    ('TT', 'Simplify[L[[3]] /. Wf -> Wfwc, Assumptions -> Element[{Vt, omega, omega0, kp, Vth, Vz, omc, hth, hz, nu}, Reals] && kp > 0 && Vt > 0 && nu > 0]', ()),
    ('Wfnc', 'Re[J1derNC[m1, n1, nu]]', ('m1', 'n1')),
    ('test', 'Simplify[Tr[S] /. Wf -> Wfwc, Assumptions -> Element[{Vt, omega, omega0, kp, nu}, Reals] && kp > 0 && Vt > 0 && nu > 0]', ()),
    ('res', 'test //. {Sqrt[2*Pi] -> sqrt2p, kp^2*(Vt^2/nu^2) -> t1, ((-I)*nu*(omega - omega0) + kp^2*Vt^2)/nu^2 -> t2, (I*nu*(omega - omega0) - kp^2*Vt^2)/nu^2 -> -t2, Gamma[t2] -> Gamma[t2, t1] + gam, Exp[t1] -> Ex, t1^(-t2) -> 1/t1Pt2, omega - omega0 -> dom}', ()),
    ('qq', 'N[Re[Simplify[Button[Hypergeometric1F1, Inherited, BaseStyle -> "Link", ButtonData -> "paclet:ref/Hypergeometric1F1"][1, 1 + t1 + I*d, t1]/(t1 + I*d), Assumptions -> t1 > 0]], 20]', ()),
    ('pp', 'Re[Hypergeometric1F1[1, 1 + t1 + I*t3, t1]/(t1 + I*t3)]', ('t1', 't3')),
    ('pp', 'FullSimplify[G[w1, w2, tau, nu]*Exp[(-2^(-1))*(w2^2/Vt^2)]]', ()),
    ('EE', 'x^2 + y^2 - a*x*y + b*(x + y)', ()),
    ('S', '{{omc^2*Wf[0, 0], omc*Vth*Wf[0, 0] + omc*hth*Wf[0, 1], (omc*Vz*Wf[0, 0] + omc*hz*Wf[0, 1])/r0}, {Vth*omc*Wf[0, 0] + hth*omc*Wf[0, 1], Vth^2*Wf[0, 0] + 2*hth*Vth*Wf[0, 1] + hth^2*Wf[1, 1], (Vth*Vz*Wf[0, 0] + (hth*Vz + hz*Vth)*Wf[0, 1] + hth*hz*Wf[1, 1])/r0}, {(Vz*omc*Wf[0, 0] + hz*omc*Wf[0, 1])/r0, (Vth*Vz*Wf[0, 0] + (hth*Vz + hz*Vth)*Wf[0, 1] + hth*hz*Wf[1, 1])/r0, (Vz^2*Wf[0, 0] + 2*hz*Vz*Wf[0, 1] + hz^2*Wf[1, 1])/r0^2}}', ()),
    ('tt', 'Tr[S]', ()),
    ('T', '{{{a, b}, {c, d}}}', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/code-KiLCA/power.wl')
