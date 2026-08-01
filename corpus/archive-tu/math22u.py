"""Generated SymPy translation of ``corpus/archive-tu/math22u.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 10 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('MyRank', 'Length[m] - Count[RowReduce[m], ConstantArray[0, Length[Transpose[m]]]]', ('m',)),
    ('M', '{{{1, 1, 1, 1}, {1, 2, 3, 4}, {3, 5, 7, 8}, {6, 5, 4, 2}, {2, 1, 3, 5}}, {{1, 3, 2, 4}, {5, 2, 0, 1}, {3, -4, -4, -7}, {-7, 5, 6, 10}}, {{8, 2, 3, 4}, {2, 5, 4, 5}, {3, 4, 5, 6}, {5, 6, 7, 9}}, {{1, 1, 1, 1}, {1, 2, 3, 4}, {3, 5, 7, 8}, {6, 5, 4, 2}}, {{2, 0, -1}, {3, 4, 2}, {0, -8, -7}}, {{1, 3, 5, 2}, {6, 7, 2, 3}, {15, 23, 19, 4}}}', ()),
    ('IsPrimePower', '(If[k > 1 && Length[#1] <= 1, {True, #1}, {False, #1}] & )[FactorInteger[k]]', ('k',)),
    ('IsPrime', '(If[#1[[1]] && #1[[2]][[1]][[2]] == 1, {True, #1[[2]]}, {False, #1[[2]]}] & )[IsPrimePower[k]]', ('k',)),
    ('ArePrime', 'IsPrime /@ K', ('K',)),
    ('PrintPrimeFactors', 'Print @@ Flatten[{{"k = "}, ({#1[[1]], "^", #1[[2]], " "} & ) /@ K}]', ('K',)),
    ('PrintPrime', '(If[#1[[1]], Print["k = ", #1[[2]][[1]][[1]]], PrintPrimeFactors[#1[[2]]]] & ) /@ ArePrime[K]', ('K',)),
    ('Eratosthenes', 'Module[{i, sq, li}, sq = Sqrt[mp]; li = Range[2, mp]; For[i = 1, i <= sq, i++, If[IsPrime[i][[1]], For[j = 2, j <= mp/i, j++, li = DeleteCases[li, i*j]]; ]]; li]', ('mp',)),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/archive-tu/math22u.wl')
