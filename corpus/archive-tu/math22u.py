"""Generated SymPy translation of ``corpus/archive-tu/math22u.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 10 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('MyRank', 'Length[m] - Count[RowReduce[m], ConstantArray[0, Length[Transpose[m]]]]', ('m',)),
    ('IsPrimePower', '(If[k > 1 && Length[#1] <= 1, {True, #1}, {False, #1}] & )[FactorInteger[k]]', ('k',)),
    ('Eratosthenes', 'Module[{i, sq, li}, sq = Sqrt[mp]; li = Range[2, mp]; For[i = 1, i <= sq, i++, If[IsPrime[i][[1]], For[j = 2, j <= mp/i, j++, li = DeleteCases[li, i*j]]; ]]; li]', ('mp',)),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/archive-tu/math22u.wl')
