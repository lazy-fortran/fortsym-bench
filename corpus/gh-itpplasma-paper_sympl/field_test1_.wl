R = 1 + r*Cos[th]; , Null, gtt = r^2; , Null, gpp = R^2; , Null, sqrtg = r*R; , Null, Ath = B0ph*(r^2/2 - (r^3/3)*Cos[th]), Null, Aph = (-B0th)*r

FullSimplify[Bthctr = Series[-D[Aph, r]/sqrtg, {r, 0, 2}]; ], Null, FullSimplify[Bphctr = Series[D[Ath, r]/sqrtg, {r, 0, 2}]; ], Null, Bth = FullSimplify[Series[Bthctr*gtt, {r, 0, 2}]], Null, Bph = FullSimplify[Series[Bphctr*gpp, {r, 0, 2}]], Null, B = FullSimplify[Series[Sqrt[Bth*Bthctr + Bph*Bphctr], {r, 0, 1}]]

Bfun = 1 - r*Cos[th]

Ath

FullSimplify(D(Ath,r))

FullSimplify(D(Ath,th))

Aph

FullSimplify(D(Aph,r))

FullSimplify(D(Aph,th))

Bth

FullSimplify(D(Bth,r))

FullSimplify(D(Bth,th))

Bfun

FullSimplify(D(Bfun,r)/Bfun)

FullSimplify(D(Bfun,th)/Bfun)

FullSimplify(D(Bth,r,r))

FullSimplify(D(Bth,th,r))

FullSimplify(D(Bth,th,th))
