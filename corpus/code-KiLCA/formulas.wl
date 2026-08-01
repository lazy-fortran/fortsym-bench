Integrate[x^20*Exp[-x^2/2/v^2], {x, -Infinity, Infinity}]

m = 20, Null, Sqrt[2*Pi]*(m - 1)!!*v^(m + 1)

Null

m = 5; , Null, n = 0; , Null, Int = Assuming[{V > 0, a > 0, kp > 0, nu > 0, EE > 0}, Integrate[w1^m*w2^n*Exp[-w2^2/2/V^2 + I*(kp/nu)*(w1 - w2) - (1/4/a)*(w1 - w2*EE + I*b)^2], {w1, -Infinity, Infinity}, {w2, -Infinity, Infinity}]]/Sqrt[4*Pi*a]; , Null, Int = Simplify[Int /. {b -> 2*kp*(V^2/nu)*(1 - EE), a -> (V^2/2)*(1 - EE^2)}]

m = 5; , Null, n = 0; , Null, BB[alpha_, beta_] := V^2*(2*I*kp*(alpha/nu) + alpha*beta); , Null, CC[alpha_, beta_] := (V^2/2)*(alpha^2 + beta^2 - 4*I*(kp/nu)*alpha); , Null, Ans = Sqrt[2*Pi]*V*D[D[Exp[BB[alpha, beta]*EE + CC[alpha, beta]], {beta, n}], {alpha, m}], Null, Ans = Ans /. {alpha -> I*(kp/nu), beta -> (-I)*(kp/nu)}

Assuming[{V > 0}, Simplify[Ans - Int]]

$Assumptions
