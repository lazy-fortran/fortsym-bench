Clear[a, b, c, p]; , Null, c = {0, 0, 0}; , Null, a = {1, 0, 0}; , Null, b = {0, 0, 1}; , Null, p = {0, 1, 0}; , Null, UnitNormal[a_, b_] := Normalize[Cross[a, b]]; , Null, PlaneDistance[a_, b_, c_, p_] := Abs[UnitNormal[a, b] . (p - b)]; 

PlaneDistance[a, b, c, p]

Null

Clear[x, y, z, F]; , Null, F = {(x + I*y)^2*z^2, (x + I*y)^2*z}

(D[#1, {x, 2}] + D[#1, {y, 2}] + D[#1, {z, 2}] & ) /@ F

Needs["VectorAnalysis`"]; , Null, SetCoordinates[Cartesian[x, y, z]], Null, (Div[Grad[#1]] & ) /@ F

Clear[a, b, x, y, z, r1, r2, r3, r, t]; , Null, CalcArea[r1_, r2_, r3_] := (1/2)*Abs[Cross[({#1[[1]], #1[[2]], 0} & )[r1 - r2], ({#1[[1]], #1[[2]], 0} & )[r1 - r3]]]; , Null, CheckInOnTriangle[r1_, r2_, r3_, r_] := If[CalcArea[r, r1, r2] + CalcArea[r, r1, r3] + CalcArea[r, r2, r3] == CalcArea[r1, r2, r3], If[CalcArea[r, r1, r2] != {0, 0, 0} && CalcArea[r, r1, r3] != {0, 0, 0} && CalcArea[r, r2, r3] != {0, 0, 0}, "In", "On"], "Out"]; , Null

CheckInOnTriangle[{0, 0}, {1, 0}, {0, 1}, {0.2, 0.2}]

CheckInOnTriangle[{0, 0}, {1, 0}, {0, 1}, {0.2, 0}]

CheckInOnTriangle[{0, 0}, {1, 0}, {0, 1}, {-1, 0}]

Needs["VectorAnalysis`"]; , Null, P = {1, 2, 3}; , Null, (CoordinatesFromCartesian[P, #1] & ) /@ {Spherical, Paraboloidal, ProlateSpheroidal[xi, eta, phi, 5]}, Null

Needs["VectorAnalysis`"]; , Null, P = {3, 3*(Pi/7), 0.3*Pi}; , Null, Pc = CoordinatesToCartesian[P, Spherical]; 

(CoordinatesFromCartesian[P, #1] & ) /@ {Cylindrical, Paraboloidal, ProlateSpheroidal[xi, eta, phi, 2]}

Needs["VectorAnalysis`"]; , Null, SetCoordinates[Spherical]; , Null, a = 2; , Null, ar = {a*t, t, 0}

PolarPlot[{ar[[1]]}, {t, 0, 10}]

d = ArcLengthFactor[ar, t]

Integrate[d, {t, 0, 2*Pi}]

Needs["VectorAnalysis`"]; , Null, SetCoordinates[Spherical]; 

TODO
