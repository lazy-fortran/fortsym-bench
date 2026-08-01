Get["green.txt"]

G[w1, w2, tau, nu]

FullSimplify[G[w1, w2, tau, nu]*Exp[(-2^(-1))*(w2^2/Vt^2)]]

Expand[argG[w1, w2, tau, nu] - (1/2)*(w2^2/Vt^2)]

FullSimplify[G[w1, w2, tau, nu]*Exp[(-2^(-1))*(w2^2/Vt^2)] - G[w2, w1, tau, nu]*Exp[(-2^(-1))*(w1^2/Vt^2)]]

Get["W2_func.txt"]; 

S = {{omc^2*Wf[0, 0], omc*Vth*Wf[0, 0] + omc*hth*Wf[0, 1], omc*Vz*Wf[0, 0] + omc*hz*Wf[0, 1]}, {Vth*omc*Wf[0, 0] + hth*omc*Wf[0, 1], Vth^2*Wf[0, 0] + 2*hth*Vth*Wf[0, 1] + hth^2*Wf[1, 1], Vth*Vz*Wf[0, 0] + (hth*Vz + hz*Vth)*Wf[0, 1] + hth*hz*Wf[1, 1]}, {Vz*omc*Wf[0, 0] + hz*omc*Wf[0, 1], Vth*Vz*Wf[0, 0] + (hth*Vz + hz*Vth)*Wf[0, 1] + hth*hz*Wf[1, 1], Vz^2*Wf[0, 0] + 2*hz*Vz*Wf[0, 1] + hz^2*Wf[1, 1]}}

MatrixForm[S]

L = Eigenvalues[S]

Tr[S]

Det[S]

Simplify[L[[3]] + L[[2]] - L[[2]] /. Wf -> Wfwc, Assumptions -> Element[{Vt, omega, omega0, kp, nu}, Reals] && kp > 0 && Vt > 0 && nu > 0]

Simplify[L[[2]]*L[[3]]]

W00 = FullSimplify[J1der[0, 0, nu]]

FullSimplify[Re[J1derNC[0, 1, nu]]^2 - Re[J1derNC[0, 0, nu]]*Re[J1derNC[1, 1, nu]]]

J1derNC[1, 1, nu]

JLimT = Sqrt[2*Pi]*Vt*((1/(Vt*Abs[kp]))*(E^(((omega - omega0)*(-omega + omega0 + 2*(alpha + beta)*kp*Vt^2))/(2*kp^2*Vt^2))*Sqrt[Pi/2]*(1 - I*Erfi[((-omega + omega0 + (alpha + beta)*kp*Vt^2)*Abs[kp])/(Sqrt[2]*kp^2*Vt)]))); 

a1 = FullSimplify[Re[J1derNC[0, 1, nu]]^2, Assumptions -> {Element[{Vt, omega, omega0, kp}, Reals], kp > 0, Vt > 0}]

FullSimplify[Re[J1derNC[0, 1, nu]]^2 - Re[J1derNC[0, 0, nu]]*Re[J1derNC[1, 1, nu]], Assumptions -> {Element[{Vt, omega, omega0, kp}, Reals], kp > 0, Vt > 0}]

a2 = FullSimplify[Re[J1derNC[0, 0, nu]], Assumptions -> {Element[{Vt, omega, omega0, kp}, Reals], kp > 0, Vt > 0}]

a3 = FullSimplify[Re[J1derNC[1, 1, nu]], Assumptions -> {Element[{Vt, omega, omega0, kp}, Reals], kp > 0, Vt > 0}]

a1 - a2*a3

TT = Simplify[L[[3]] /. Wf -> Wfwc, Assumptions -> Element[{Vt, omega, omega0, kp, Vth, Vz, omc, hth, hz, nu}, Reals] && kp > 0 && Vt > 0 && nu > 0]

Simplify[L[[2]] /. Wf -> Wfwc, Assumptions -> Element[{Vt, omega, omega0, kp, Vth, Vz, omc, hth, hz, nu}, Reals] && kp > 0 && Vt > 0 && nu > 0]

Wfnc[m1_, n1_] := Re[J1derNC[m1, n1, nu]]; , Null, Wfwc[m1_, n1_] := Re[J1der[m1, n1, nu]]; 

L[[2]]

Simplify[Wf[0, 1] /. Wf -> Wfwc, Assumptions -> Element[{Vt, omega, omega0, kp, nu}, Reals] && kp > 0 && Vt > 0 && nu > 0]

Wfnc[1, 0]

Simplify[Re[J1der[0, 1, nu]]^2 - Re[J1der[0, 0, nu]]*Re[J1der[1, 1, nu]], Assumptions -> Element[{Vt, omega, omega0, kp, nu}, Reals] && kp > 0 && Vt > 0 && nu > 0]

Re[J1derNC[0, 1, nu]]^2 - Re[J1derNC[0, 0, nu]]*Re[J1derNC[1, 1, nu]]

Simplify[L[[2]]*L[[3]] /. Wf -> Wfwc, Assumptions -> Element[{Vt, omega, omega0, kp, nu}, Reals] && kp > 0 && Vt > 0 && nu > 0]

test = Simplify[Tr[S] /. Wf -> Wfwc, Assumptions -> Element[{Vt, omega, omega0, kp, nu}, Reals] && kp > 0 && Vt > 0 && nu > 0]

res = test //. {Sqrt[2*Pi] -> sqrt2p, kp^2*(Vt^2/nu^2) -> t1, ((-I)*nu*(omega - omega0) + kp^2*Vt^2)/nu^2 -> t2, (I*nu*(omega - omega0) - kp^2*Vt^2)/nu^2 -> -t2, Gamma[t2] -> Gamma[t2, t1] + gam, Exp[t1] -> Ex, t1^(-t2) -> 1/t1Pt2, omega - omega0 -> dom}; , Null, res = Simplify[res /. {gam -> (1/Ex)*(t1Pt2/t2)*F11}], Null, res = Simplify[res //. {t2 -> t1 - I*(dom/nu), t1 -> kp^2*(Vt^2/nu^2), omega -> dom + omega0}]; , Null, res = res //. {Sqrt[2*Pi] -> sqrt2p, kp^2*(Vt^2/nu^2) -> t1, ((-I)*nu*(omega - omega0) + kp^2*Vt^2)/nu^2 -> t2, (I*nu*(omega - omega0) - kp^2*Vt^2)/nu^2 -> -t2, Gamma[t2] -> Gamma[t2, t1] + gam, Exp[t1] -> Ex, t1^(-t2) -> 1/t1Pt2, omega - omega0 -> dom}, Null

qq = N[Re[Simplify[Button[Hypergeometric1F1, Inherited, BaseStyle -> "Link", ButtonData -> "paclet:ref/Hypergeometric1F1"][1, 1 + t1 + I*d, t1]/(t1 + I*d), Assumptions -> t1 > 0]], 20]

N[qq /. {t1 -> 10, d -> 10}, 20]

(* UNCONVERTED CELL *)

Null

Clear[t1, t2]

(* UNCONVERTED CELL *)

qq

Eval

pp[t1_, t3_] := Re[Hypergeometric1F1[1, 1 + t1 + I*t3, t1]/(t1 + I*t3)]

Plot[pp[t1, t3] /. t3 -> 1, {t1, 1, 2}]

Plot3D[pp[t1, t3], {t1, 0, 10^5}, {t3, -10^4, 10^4}]

Simplify[Re[J1der[0, 0, nu]], Assumptions -> Element[{Vt, omega, omega0, kp, nu}, Reals] && kp > 0 && Vt > 0 && nu > 0]

Null

pp = FullSimplify[G[w1, w2, tau, nu]*Exp[(-2^(-1))*(w2^2/Vt^2)]]

EE = x^2 + y^2 - a*x*y + b*(x + y)

Simplify[EE /. {x -> (Sqrt[2]/2)*(u1 - u2), y -> (Sqrt[2]/2)*(u1 + u2)}]

Simplify[argG[w1, w2, tau, nu] - (1/2)*(w2^2/Vt^2) - (1/4/a[tau, nu])*(b[tau, nu]*b[tau, nu] - 4*a[tau, nu]*c[tau, nu] - w1^2 - w2^2 + 2*Exp[(-nu)*tau]*w1*w2 - 2*Vt^2*kp*(I/nu)*(1 - Exp[(-nu)*tau])^2*(w1 + w2))]

Simplify[(1/4/a[tau, nu])*(b[tau, nu]*b[tau, nu] - 4*a[tau, nu]*c[tau, nu] - w1^2 - w2^2 + 2*Exp[(-nu)*tau]*w1*w2 - 2*Vt^2*kp*(I/nu)*(1 - Exp[(-nu)*tau])^2*(w1 + w2))]

S = {{omc^2*Wf[0, 0], omc*Vth*Wf[0, 0] + omc*hth*Wf[0, 1], (omc*Vz*Wf[0, 0] + omc*hz*Wf[0, 1])/r0}, {Vth*omc*Wf[0, 0] + hth*omc*Wf[0, 1], Vth^2*Wf[0, 0] + 2*hth*Vth*Wf[0, 1] + hth^2*Wf[1, 1], (Vth*Vz*Wf[0, 0] + (hth*Vz + hz*Vth)*Wf[0, 1] + hth*hz*Wf[1, 1])/r0}, {(Vz*omc*Wf[0, 0] + hz*omc*Wf[0, 1])/r0, (Vth*Vz*Wf[0, 0] + (hth*Vz + hz*Vth)*Wf[0, 1] + hth*hz*Wf[1, 1])/r0, (Vz^2*Wf[0, 0] + 2*hz*Vz*Wf[0, 1] + hz^2*Wf[1, 1])/r0^2}}

MatrixForm[S]

tt = Tr[S]

T = {{{a, b}, {c, d}}}

MatrixForm[Inverse[T]]

Inverse[{{a, b}, {c, d}}]
