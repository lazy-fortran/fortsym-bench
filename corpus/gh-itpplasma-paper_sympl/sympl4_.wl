$Assumptions = {Element[r, Reals], Element[th, Reals], Element[ph, Reals], r > 0, r < 1}

R = 1 + r*Cos[th], Null, gtt = r^2, Null, gipp = 1/R^2, Null, sqrtg = r*R, Null, Bfun = 1 - r*Cos[th], Null, Bthd = (sqrtg/Sqrt[gtt])*Sqrt[Bfun^2 - B0ph^2*gipp], Null, FullSimplify[(Bthd^2/sqrtg^2)*gtt + B0ph^2*gipp]

Bthds = Series[Bthd, {r, 0, 2}], Null, Bs = FullSimplify[Sqrt[(Bthds^2/sqrtg^2)*gtt + B0ph^2*gipp]]

Aph = Integrate[Bthds, r]

Bphd = B0ph*gipp*sqrtg

Bphds = Series[Bphd, {r, 0, 2}]

Aths = Integrate[Bphds, r]
