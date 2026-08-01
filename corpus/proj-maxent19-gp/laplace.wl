G[x_, t_, xk_, tk_] := Log[/(4*(t - tk))]

Null

sqexp = Exp[-((x - x0)^2 + (y - y0)^2)/(2*r0^2)]

FullSimplify[Div[Grad[sqexp, {x, y}], {x, y}]]
