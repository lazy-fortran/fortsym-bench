R = 1 + r*Cos[th]; , Null, gtt = r^2; , Null, gpp = R^2; , Null, sqrtg = r*R; , Null, Ath = B0ph*(r^2/2) - (B0ph*Cos[th])*(r^3/3); , Null, Aph = B0th*r; 

Bthctr = FullSimplify[-D[Aph, r]/sqrtg], Null, Bphctr = FullSimplify[D[Ath, r]/sqrtg], Null, Bth = FullSimplify[Bthctr*gtt], Null, Bph = FullSimplify[Bphctr*gpp], Null, B = FullSimplify[Series[Sqrt[Bth*Bthctr + Bph*Bphctr], {r, 0, 1}]]

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
