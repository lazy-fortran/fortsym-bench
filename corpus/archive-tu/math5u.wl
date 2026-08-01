Solve[24 - 14*x - 13*x^2 + 2*x^3 + x^4 == 0, x]

Sort[x /. %]

Cases[%, _?Positive]

y = Table[{Cos[k*2*(Pi/8)], Sin[k*2*(Pi/8)]}, {k, 0, 7}]

Select[y, #1[[2]] > 0 & ]

num = Range[0, 10, 1]

Insert[num, Pi, 5]

y = Table[Cos[n*x], {n, 1, 7, 2}]; 

Plot[y, {x, 0, Pi}]

num = Range[0, 6]

num = MapAt[Pi^#1 & , num, {{1}, {3}, {5}, {7}}]

num /. Pi -> -3

Null

DivideList = RotateLeft[#1]/#1 & ; , Null, DivideList[{1, 2, 3, 4}]

list = {a, b, c, e, b, e, f, f, a, d, b, c}

Union[list]

Reverse[Sort[%]]

l1 = {2, a, c, 4}; , Null, l2 = {3, c, f, a, 5}; , Null, l3 = Flatten[{l1, l2}]

Position[%, c]

xl = Range[1, 10]; , Null, yl = Range[2, 20, 2]; , Null, xyl = Transpose[{xl, yl}]

lx = {{x11, x12, x13}, {x21, x22, x33}, {x31, x32, x33}}; , Null, ly = {{y11, y12, y13}, {y21, y22, y33}, {y31, y32, y33}}; , Null, lxy = Riffle[lx, ly]
