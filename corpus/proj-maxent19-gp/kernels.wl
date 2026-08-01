$Assumptions = r1 > 0 && r2 > 0 && Element[th1, Reals] && Element[th2, Reals]

s = FullSimplify[ExpToTrig[ComplexExpand[Re[Sum[r1^k*r2^k*(Cos[k*th1]*Cos[k*th2] + Sin[k*th1]*Sin[k*th2]), {k, 0, Infinity}]]]]]

(-(1/2))*Log[1 + r1^2*r2^2 - 2*r1*r2*Cos[th1 - th2]]

Plot[Re[s /. {r1 -> 1.1, th1 -> 1, th2 -> 1}], {r2, 0, 5}]

Plot[Re[s /. {r1 -> 0.5, r2 -> 1, th2 -> 0}], {th1, 0, 2*Pi}]

ContourPlot[Re[s /. {r1 -> 1, th1 -> 0, r2 -> Sqrt[x^2 + y^2], th2 -> ArcTan[x, y]}], {x, -2, 2}, {y, -2, 2}]

ContourPlot[(-2^(-1))*Log[1 - 2*(x*x0 + y*y0) + (x^2 + y^2)*(x0^2 + y0^2)] /. {x0 -> 1, y0 -> 0}, {x, -2, 2}, {y, -2, 2}]
