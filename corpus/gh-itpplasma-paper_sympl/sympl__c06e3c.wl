$Assumptions = {Element[a, Reals], Element[r, Reals], Element[th, Reals], Element[ph, Reals], Element[r0, Reals], eps > 0, eps < R0, R0 > 0, R0 < 1, r > 0, a > 0}

psitor = (r^2*Subscript[B, 0])/2; , Null, psipol = io0*Subscript[B, 0]*(r^2/2 - r^4/(4*a^2)); , Null, F = (-Subscript[B, 0])*(r^3/(3*Subscript[R, 0]))*Sin[ϑ]; , Null, io = io0*(1 - r^2/a^2); , Null, psitorpr = D[psitor, r]; , Null, psipolpr = psitorpr*io, Null, psipol = Integrate[psipolpr, r]; , Null, Ath = psitor + D[F, ϑ], Null, Aph = -psipol + D[F, φ]

hth = ι*(r^2/Subscript[R, 0]); , Null, hph = Subscript[R, 0] + r*Cos[ϑ]; , Null, B[r, ϑ] = Subscript[B, 0]*(1 - (r/Subscript[R, 0])*Cos[ϑ]); , Null, sqg = FullSimplify[(hph*D[Ath, r] + hth*r*ι*Subscript[B, 0])/B[r, ϑ]]

Series[sqg /. {ι^2 -> io0*(1 - r^2/a^2), r -> eps*Subscript[R, 0]}, {eps, 0, 3}]

FullSimplify[Series[sqg /. {ι^2 -> io0*(1 - r^2/a^2), r -> a*(1 - eps)}, {eps, 0, 2}]]

FullSimplify[Series[sqg /. r -> a*eps, {eps, 0, 3}]]

Series[sqg - r*(Subscript[R, 0] + r*Cos[ϑ]) /. r -> a*(1 - eps), {eps, 0, 4}]

Bph = D[Ath, eps]/(sqrtg*R0)

Bth = -D[Aph, eps]/(sqrtg*R0)

gtt = hth/(Bth/B)

Bthphys = FullSimplify[Sqrt[gtt]*Bth]

Series[Bthphys, {eps, 0, 1}]

hth = io0*(1 - r^2/a^2)*(r^2/Subscript[R, 0])

FullSimplify[D[hth, r]]

FullSimplify[D[hth, r, r]]
