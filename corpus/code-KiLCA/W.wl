AF := I*(omega - omegaL) - kp^2*(vT^2/nu), Null, BF[a_, b_] := vT^2*(a + I*(kp/nu))*(b + I*(kp/nu)), Null, CF[a_, b_] := (1/2)*vT^2*(a^2 + b^2) - I*(kp/nu)*vT^2*(a + b) + kp^2*(vT^2/nu^2), Null, W[m_, n_] := (-Sqrt[2*Pi])*(vT/AF)*D[D[Exp[CF[a, b] + BF[a, b]]*Button[Hypergeometric1F1, Inherited, BaseStyle -> "Link", ButtonData -> "paclet:ref/Hypergeometric1F1"][1, 1 - AF/nu, -BF[a, b]], {a, m}], {b, n}] /. {a -> 0, b -> 0}; 

FullSimplify[W[0, 1]], Null, W[0, 1], Null
