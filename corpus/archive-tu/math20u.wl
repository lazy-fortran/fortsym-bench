RelFreq[n_, b_] := (N[(1/Length[n])*Count[n, #1]] & ) /@ Range[0, b - 1]; 

num = {2^2^11 + 1, 100!}

num10 = (IntegerDigits[#1, 10] & ) /@ num

RelFreq[num10[[1]], 10]

RelFreq[num10[[2]], 10]

num8 = (IntegerDigits[#1, 8] & ) /@ num

RelFreq[num8[[1]], 8]

RelFreq[num8[[2]], 8]

pidigits = RealDigits[Pi, 10, 100]

RelFreq[pidigits[[1]], 10]

Clear[x, y, z, v, w]; , Null, f = 5*x^2 + 7*((x + z^3)^(1/2)/(5 + z^2))

f = ReplacePart[f, w, Position[f, x, 3]]; , Null, f = ReplacePart[f, v, Position[f, x, 4]]; , Null, f = ReplacePart[f, 4, Position[f, 5, 2]]; , Null, f = ReplacePart[f, 25*y^4, Position[f, 5 + z^2]]; , Null, f = f /. z^3 -> z^4; , Null, f = f /. (i_)^(1/2) -> i^(3/2); , Null, f = f /. 7 -> 17

Clear[x, y, z, u, v, w, a, b, c, d]; , Null, f = Sin[a*x]*Exp[b + c*y]*Log[d*z]

f = f /. a -> 5; , Null, f = ReplacePart[f, 7*c*y, Position[f, b + c*y]]; , Null, f = f /. z -> u^2
