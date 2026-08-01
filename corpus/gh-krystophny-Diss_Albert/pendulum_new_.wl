Omt[H_] := Sqrt[U0/m]*(Pi/(2*EllipticK[H/(2*U0)])), Null, D2HdJ2t = FullSimplify[Omt[H]*D[Omt[H], H]], Null, Plot[Omt[H] /. {m -> 1, U0 -> 1}, {H, 0, 2}], Null, Plot[D2HdJ2t /. {m -> 1, U0 -> 1}, {H, 0, 2}]

Jt[H_] := Sqrt[m*U0]*(8/Pi)*(EllipticE[H/(2*U0)] - (1 - H/(2*U0))*EllipticK[H/(2*U0)]), Null, DJtDH = D[Jt[H], H]; , Null, Plot[{DJtDH, 1/Omt[H]} /. {m -> 1, U0 -> 1}, {H, 0, 2}]
