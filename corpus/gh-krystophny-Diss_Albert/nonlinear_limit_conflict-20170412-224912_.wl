y[th_, J_] := Sign[y]*Sqrt[J + 2*Cos[th]], Null, Jac = {{1, 0}, {D[y[th, J], th], D[y[th, J], J]}}, Null, Jaci = Inverse[Jac]

Null

gp0barpr = FullSimplify[C/Integrate[Sqrt[J + 2*Cos[th]], {th, -Pi, Pi}, Assumptions -> J > 2]]

Plot[{gp0barpr /. C -> 1, 1/(2*Pi*Sqrt[J])}, {J, 3, 10}]
