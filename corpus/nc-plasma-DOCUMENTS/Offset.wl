F[mu_] = (BesselK[2, mu]*Exp[mu])/mu

dF[mu_] = D[F[mu], mu]

ddF[mu_] = D[dF[mu], mu]

mu*(dF[mu]/F[mu])

a02[mu_] := FullSimplify[(mu^2*(-((E^mu*BesselK[2, mu])/mu^2) + (E^mu*BesselK[2, mu])/mu + (E^mu*(-BesselK[1, mu] - BesselK[3, mu]))/(2*mu)))/(E^mu*BesselK[2, mu])]

Limit[a02[mu], mu -> Infinity]

Series[FullSimplify[(mu^2*(-((E^mu*BesselK[2, mu])/mu^2) + (E^mu*BesselK[2, mu])/mu + (E^mu*(-BesselK[1, mu] - BesselK[3, mu]))/(2*mu)))/(E^mu*BesselK[2, mu])], {mu, Infinity, 10}]

N[a02[100000000]]

a22[mu_] := mu^2*(ddF[mu]/F[mu])

FullSimplify[a22[mu]]

N[a22[1000000]]

N[a22[10000000], 20]

FullSimplify[a22[mu]]

Out()

Series[a22[mu], {mu, Infinity, 10}]

a02[510983.03150221746]

NumberForm[-1.535983963795615, 16]
