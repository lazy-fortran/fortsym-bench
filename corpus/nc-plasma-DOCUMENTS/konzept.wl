TrigExpand[Sqrt[(Sin[q2] + a - Sin[q1])^2 + (Cos[q2] - Cos[q1])^2] - a]

mu := 1; a := 2; d := 0.1; , Null, H[q1_, p1_, q2_, p2_] := p1^2/2 + mu*(p2^2/2) - Cos[q1] - mu*Cos[q2] + d*(Sqrt[(Sin[q2] + a - Sin[q1])^2 + (Cos[q2] - Cos[q1])^2] - a)^2; , Null, q1dot[q1_, p1_, q2_, p2_] := D[H[q1, p1, q2, p2], p1]; p1dot[q1_, p1_, q2_, p2_] := -D[H[q1, p1, q2, p2], q1]; , Null, q2dot[q1_, p1_, q2_, p2_] := D[H[q1, p1, q2, p2], p2]; p2dot[q1_, p1_, q2_, p2_] := -D[H[q1, p1, q2, p2], q2]; , Null

t1 = 10*Pi; , Null, sol = NDSolve[{D[q1[t], t] == q1dot[q1[t], p1[t], q2[t], p2[t]], D[p1[t], t] == p1dot[q1[t], p1[t], q2[t], p2[t]], D[q2[t], t] == q2dot[q1[t], p1[t], q2[t], p2[t]], D[p2[t], t] == p2dot[q1[t], p1[t], q2[t], p2[t]], q1[0] == 0.8, p1[0] == 0, q2[0] == 0, p2[0] == 0}, {q1[t], p1[t], q2[t], p2[t]}, {t, 0, t1}]; , Null, qp[ta_] := Flatten[{q1[t], p1[t], q2[t], p2[t]} /. sol /. t -> ta]; 

Plot[qp[t], {t, 0, t1}]

q1dot0[q_, p_] := D[H[q1, p1, q2, p2], p1] /. {q1 -> q, p1 -> p, q2 -> 0, p2 -> 0}; p1dot0[q_, p_] := -D[H[q1, p1, q2, p2], q1] /. {q1 -> q, p1 -> p, q2 -> 0, p2 -> 0}; , Null, VectorPlot[{q1dot0[q, p], p1dot0[q, p]}, {q, -Pi, Pi}, {p, -Pi, Pi}]
