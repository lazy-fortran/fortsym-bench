F = {{x^6 - 5*x^5 + 4*x^4 - 2*x^3 + 3*x^2 - x - 1, x^2 - x + 1}, {x^7 + x^6 - 1, x - 1}}; , Null, (PolynomialQuotient[#1[[1]], #1[[2]], x] & ) /@ F

Clear[a, b, c]; , Null, SqTri[s_, c_] := Solve[{b, a} . {s, s} == a*b && a^2 + b^2 == c^2 && a > 0 && b > 0, {a, b}, Reals]; 

s = 4; , Null, c = 20; , Null, sol = {a, b} /. SqTri[s, c]

plots = (ListLinePlot[{{0, 0}, {#1[[1]], 0}, {0, #1[[2]]}, {0, 0}}, PlotRange -> {{0, c}, {0, c}}] & ) /@ sol; , Null, square = ListLinePlot[{{0, 0}, {s, 0}, {s, s}, {0, s}, {0, 0}}, Filling -> Axis]; 

Show[plots, square, AspectRatio -> 1]

Clear[a, b, c]; sol = Reduce[a + b + c == 3 && a^2 + b^2 + c^2 == 9 && a^3 + b^3 + c^3 == 24, {a, b, c}, Cubics -> True, Quartics -> True]

sol = FullSimplify[sol]

Solve[FullSimplify[Reduce[sol[[1]][[1]] && sol[[2]][[1]] && sol[[3]] && Element[a^4 + b^4 + c^4, Integers], {a, b, c}, Cubics -> True, Quartics -> True]]]

FullSimplify[a^4 + b^4 + c^4 /. %]

Solve[FullSimplify[Reduce[sol[[1]][[1]] && sol[[2]][[2]] && sol[[3]] && Element[a^4 + b^4 + c^4, Integers], {a, b, c}, Cubics -> True, Quartics -> True]]]

FullSimplify[a^4 + b^4 + c^4 /. %]

f[a_, x_] = a^4 + 3*a^2*x + a*x^4 + x^5; 

Reduce[f[a, x] == 0, x, Reals, Cubics -> True, Quartics -> True]

a1 = N[Root[62208 - 2187*#1^2 - 972*#1^3 - 450*#1^4 - 7500*#1^5 + 3125*#1^6 + 256*#1^7 & , 1]]

a2 = N[Root[62208 - 2187*#1^2 - 972*#1^3 - 450*#1^4 - 7500*#1^5 + 3125*#1^6 + 256*#1^7 & , 1]]

plots = (Plot[f[#1, x], {x, -10, 15}] & ) /@ Range[-20, 0, 3]; Show[plots]

a = N[Root[62208 - 2187*#1^2 - 972*#1^3 - 450*#1^4 - 7500*#1^5 + 3125*#1^6 + 256*#1^7 & , 1], 30]
