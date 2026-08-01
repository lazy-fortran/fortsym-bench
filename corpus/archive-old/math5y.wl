Clear[a, b, c, d, l0, l1, l2]

l0 = {3, 5, 1}

l1 = {a, b, c, d}

l2 = l1^2

l1 + l2

l0 + l1

l1*l2

l1/l2

Exp[l0]

N[Exp[l0]]

p = x^4 - 1 + x

sp = Solve[p == 0., x]

p /. sp

Chop[%]

l4 = {a, b, c, d, {al, be, ga}, e}

Length[l4]

l1 = {a, b, c}

l2 = {{a11, a12, a13}, {a21, a22, a23}, {a31, a32, a33}}

TableForm[l2]

MatrixForm[l2]

Transpose[l2]

TableForm[%]

epst = {{{0, 0, 0}, {0, 0, 1}, {0, -1, 0}}, {{0, 0, -1}, {0, 0, 0}, {1, 0, 0}}, {{0, 1, 0}, {-1, 0, 0}, {0, 0, 0}}}; 

TableForm[%]

Transpose[epst]; 

TableForm[%]

Table[i^2, {9}]

Table[i^2, {i, 9}]

Table[Exp[I*x], {x, 0, Pi, Pi/5}]

Table[Sin[x], {x, 0, Pi, Pi/5}]

N[%]

Table[i*(j/k), {i, 3}, {j, 2}, {k, 4}]

Range[5]

Range[-1, -5]

Reverse[-Range[1, 5]]

Range[1/2, 9/2]

Range[1/2, 10]

Range[1/2, 5, 1/3]

Table[Plot[Sin[n*x], {x, 0, Pi}, ImageSize -> 115, Ticks -> {Pi*Range[0, 1, 1/4], {-1, 0, 1}}, BaseStyle -> {FontSize -> 6}], {n, 4}]

Show[Reverse[%]]

li = Reverse[Range[1, 8]]

li[[3]]

li[[-3]]

li[[1]]

First[li]

Last[li]

li[[{2, 4, 6}]]

li[[Range[2, 5]]]

so = Solve[x + a == 0, x]

Flatten[so]

so[[1]]

x /. so

First[%]

Clear[a11, a12, a13, a21, a22, a23, a31, a32, a33]*l2 = {{a11, a12, a13}, {a21, a22, a23}, {a31, a32, a33}}

Take[l2, 2]

Take[l2, -3]

Rest[l2]

Take[l2, {2, 3}]

Drop[l2, -2]

li = {{3, 5, 9}, 6, {2, 3, 4, 5, 9}, {1, 4, 9}, 7}; 

pos4 = Position[li, 4]

(Drop[#1, -1] & ) /@ pos4

Extract[li, %]

int = Integrate[x*((x + 2)^2/((x - 1)*(x + 3))), x]

polog = Position[int, Log]

(Drop[#1, {-2, -1}] & ) /@ polog

Extract[int, %]

poly = c^3 + a*x^3 + 3*x*y + b^4*y^3; 

powerPositions = Position[poly, (y_)^(n_)]

Extract[poly, powerPositions]

Clear[a, b, c, d, u, v, w, x, y, z]

Prepend[{a, b, c}, x]

Append[{u, v, w}, x]

Insert[{a, b, c, d}, x, 2]

Insert[{a, b, c, d}, x, -2]

Delete[%, -2]

l1 = {a, b, c, d}

l1[[3]] = gg

l1

l1[[3]] = c

l1

l2 = ReplacePart[l1, 10, 2]

l1

l2

Position[l2, 10]

ReplacePart[l2, b, Position[l2, 10]]

lf = (a^2 + 3*a*b*c)^2

Position[lf, a]

Expand[lf]

Position[%, a]

Clear[a, b, c, d, e, l1, l2, l3, l4]

l1 = {a, b, c}

l2 = {d, e, c}

l3 = Join[l1, l2]

l4 = Union[l1, l2]

Reverse[l4]

ll = {{1, 2, 3, 4}, {5, 6}, {7, 8}, {9, 10}, {11, 12}}

Flatten[ll]

Partition[%, 3]

Reverse[%]

lx = {x1, x2, x3, x4, x5}; 

FullForm[lx]

lt = lx == l4

Thread[lt]

n = 5; Clear[lx], Null, lx = Thread[Subscript[x, Range[0, n]]]

lt = lx == l4

FullForm[lx]

Split[{8, 8, 8, 1, 2, 1, 8, 8, 7, 7, 7, 1, 1, 2, 2, 3}]

lst = Table[a[i], {i, 20}]

le = lst[[Table[k, {k, 1, Length[lst], 2}]]]

Partition[lst, Sequence[1, 2]]

Flatten[%]

le = lst[[Table[k, {k, 2, Length[lst], 2}]]]

Partition[lst, Sequence[2, 2]]

Partition[Drop[lst, 1], Sequence[1, 2]]

le = lst[[Table[k, {k, 1, Length[lst], 3}]]]

Partition[lst, Sequence[1, 3]]

Partition[lst, Sequence[2, 3]]

lx = {x1, x2, x3, x4, x5}; , Null, ly = {y1, y2, y3, y4, y5}; 

lxy = Transpose[{lx, ly}]

li = {r1, r2, r3, r4, r5}

ls = FoldList[Plus, r1, Drop[li, 1]]

lr = RandomReal[{0, 1}, 1000]; 

{ts, ls} = Timing[FoldList[Plus, lr[[1]], Drop[lr, 1]]]; ts

{tss, lss} = Timing[Table[Sum[lr[[k]], {k, n}], {n, Length[lr]}]]; tss

{tst, lst} = Timing[Table[Plus @@ Take[lr, n], {n, Length[lr]}]]; tst

ls - lss == Table[0., {Length[ls]}], Null, ls - lst == Table[0., {Length[ls]}]

Clear[a, b, c, d, r, l1, l2, l3], Null, l1 = {a, b, c}; l2 = {a, 2, r}; l3 = {a, b, c, d}; 

la = Union[l1, l2, l3]

Union[l1, l2, l3]

li = Intersection[l1, l2, l3]

Complement[la, l1, l3]

a = N[{Pi, Pi + 10^(-5), Pi - 10^(-5)}, 6]

testdiff = If[NumericQ[#1 - #2], Abs[N[#1 - #2]] < 10^(-4), #1 == #2] & ; , Null, Union[a, SameTest -> testdiff]

Clear[a, b, c, d]

li = {1, 2, 3, -5, a, b, d, 0.33, -0.73}

Cases[li, _Integer]

Cases[li, _Symbol]

Cases[li, _Real]

Cases[li, _?EvenQ]

Cases[li, _?OddQ]

Cases[li, _?Positive]

Cases[li, _?Negative]

Cases[li, _?NumberQ]

Select[li, IntegerQ]

Select[li, #1[[0]] == Integer & ]

Select[li, #1[[0]] == Real & ]

li

Select[li, #1[[0]] == Symbol & ]

Select[li, EvenQ]

Select[li, OddQ]

Select[li, #1 > 0.5 & ]

Select[li, #1 < 0 & ]

li

DeleteCases[li, _Integer]

DeleteCases[li, _Real]

DeleteCases[li, _Symbol]

DeleteCases[li, _?EvenQ]

DeleteCases[li, _?OddQ]

DeleteCases[li, _?Positive]

DeleteCases[li, _?Negative]

DeleteCases[li, _?NumberQ]

ll = {a, b, c, 1, 2, 3, 1/2, 3/4, 0.5, 0.33, 0.2 + 0.3*I, -4, -5, -0.77}

Head /@ ll

li = {1, 2, 3, 4}; , Null, DeleteCases[li, _?(#1 > 2 & )]

DeleteCases[li, x_ /; x > 2]

Select[ll, NumberQ]

Select[ll, #1[[0]] == Integer || #1[[0]] == Real & ]

Select[ll, #1[[0]] == Integer && #1 < 0 & ]

Count[{1, 0, 0, 1, 2, 3, 7, 1}, 0]

Count[{3, -2, 7, -I, c, -6}, _?Negative]

Count[{7, 0.22, 0.31, 0.3 + I*0.1}, _Real]

ex = c + E^(-x^2) + Exp[z^2] + w^5^x + s^2 + 1/y^2 + 1; 

Count[ex, (x_)^(y_)]

Table[Count[ex, (x_)^(y_), k], {k, 10}]

TreeForm[ex]

Position[ex, Power]
