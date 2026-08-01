MyRank[m_] := Length[m] - Count[RowReduce[m], ConstantArray[0, Length[Transpose[m]]]]; , Null, M = {{{1, 1, 1, 1}, {1, 2, 3, 4}, {3, 5, 7, 8}, {6, 5, 4, 2}, {2, 1, 3, 5}}, {{1, 3, 2, 4}, {5, 2, 0, 1}, {3, -4, -4, -7}, {-7, 5, 6, 10}}, {{8, 2, 3, 4}, {2, 5, 4, 5}, {3, 4, 5, 6}, {5, 6, 7, 9}}, {{1, 1, 1, 1}, {1, 2, 3, 4}, {3, 5, 7, 8}, {6, 5, 4, 2}}, {{2, 0, -1}, {3, 4, 2}, {0, -8, -7}}, {{1, 3, 5, 2}, {6, 7, 2, 3}, {15, 23, 19, 4}}}; 

(MyRank[#1] & ) /@ M

(MatrixRank[#1] & ) /@ M

IsPrimePower[k_] := (If[k > 1 && Length[#1] <= 1, {True, #1}, {False, #1}] & )[FactorInteger[k]]; , Null, IsPrime[k_] := (If[#1[[1]] && #1[[2]][[1]][[2]] == 1, {True, #1[[2]]}, {False, #1[[2]]}] & )[IsPrimePower[k]]; , Null, ArePrime[K_] := IsPrime /@ K; , Null, PrintPrimeFactors[K_] := Print @@ Flatten[{{"k = "}, ({#1[[1]], "^", #1[[2]], " "} & ) /@ K}]; , Null, PrintPrime[K_] := (If[#1[[1]], Print["k = ", #1[[2]][[1]][[1]]], PrintPrimeFactors[#1[[2]]]] & ) /@ ArePrime[K]; 

PrintPrime[Range[1, 20]]; 

Eratosthenes[mp_] := Module[{i, sq, li}, sq = Sqrt[mp]; li = Range[2, mp]; For[i = 1, i <= sq, i++, If[IsPrime[i][[1]], For[j = 2, j <= mp/i, j++, li = DeleteCases[li, i*j]]; ]]; li]

Eratosthenes[100]

Length[%]
