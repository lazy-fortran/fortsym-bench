GeoMean[a_] := Times @@ a^(1/Length[a])

GeoMean[{1, 2, 3}], Null, GeometricMean[{1, 2, 3}]

6^(1/3)

HarmMean[a_] := Length[a]/Plus @@ (1/a); 

HarmMean[{1, 2, 3}], Null, HarmonicMean[{1, 2, 3}]

Clear[u, r, L, k], Null, Dop = Derivative[2][u][r] + (2/r)*Derivative[1][u][r] - L*((L + 1)/r^2) + k^2

(Dop = ReplacePart[Dop, Derivative[1][u][r]/r, Position[Dop, 2*(Derivative[1][u][r]/r)]]; )*(Dop = ReplacePart[Dop, L, Position[Dop, L + 1]]; )*(Dop = Dop /. u -> w)

{{a, b, c, d}, {p, q, r, s}}

{{{0.3, 0.5}}, {{0.6, 1.}}, {{0.9, 1.5}}, {{1.2, 2.}}}

(* UNCONVERTED CELL *)

Clear[a, b, c, d, p, q, r, s]; , Null, list1 = {{{{a, b}}, {{c, d}}}, {{{p, q}}, {{r, s}}}}, Null, list2 = {{{0.3, 0.5}}, {{0.6, 1.}}, {{0.9, 1.5}}, {{1.2, 2.}}}

Flatten /@ list1

Flatten /@ list2

Null

lx = {x1, x2, x3, x4, x5}

lxs = ToString[lx]

lvc = Characters[lxs] /. "x" -> "v"

lvs = StringJoin[lvc]

lv = ToExpression[lvs]

Null

Clear[la, n, i]; , Null, la[n_] := ToExpression[Table[{StringJoin[{"ax", ToString[i]}], StringJoin[{"ay", ToString[i]}], StringJoin[{"az", ToString[i]}]}, {i, 1, n}]], Null, lb[n_] := ToExpression[Table[{StringJoin[{"bx", ToString[i]}], StringJoin[{"by", ToString[i]}], StringJoin[{"bz", ToString[i]}]}, {i, 1, n}]]

Riffle[la[5], lb[5]]

Null

TODO

{{a, b}, {c, d}}

TODO

f = FactorInteger[11244102684192486488811361002585612418726608312031552683325339048893]

MultiplyFactors[k_] := Times @@@ {(#1[[1]]^#1[[2]] & ) /@ k}; 

MultiplyFactors[f]
