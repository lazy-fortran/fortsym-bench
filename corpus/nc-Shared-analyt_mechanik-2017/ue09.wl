Th22S = FullSimplify[Integrate[(M/V)*r*(r^2*Cos[ph]^2 + (z - h/4)^2), {r, 0, R}, {z, 0, h*(1 - r/R)}, {ph, 0, 2*Pi}] /. V -> (Pi/3)*R^2*h]

Th22O = FullSimplify[Integrate[(M/V)*r*(r^2*Cos[ph]^2 + z^2), {r, 0, R}, {z, 0, h*(1 - r/R)}, {ph, 0, 2*Pi}] /. V -> (Pi/3)*R^2*h]

Th22OCheck = FullSimplify[Th22S + M*(h/4)^2]
