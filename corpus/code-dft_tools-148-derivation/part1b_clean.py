"""Generated SymPy translation of ``corpus/code-dft_tools-148-derivation/part1b_clean.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 5 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('$Assumptions', '(a|b|g) \\[Element] Reals', ()),
    ('sy', 'PauliMatrix[2]', ()),
    ('sz', 'PauliMatrix[3]', ()),
    ('Dhalf', 'MatrixExp[-I a sz/2].MatrixExp[-I b sy/2].MatrixExp[-I g sz/2]', ('a', 'b', 'g')),
    ('spmt', '{{ Exp[ I (a+g)/2] Cos[b/2],  Exp[-I (a-g)/2] Sin[b/2] },\n                   {-Exp[ I (a-g)/2] Sin[b/2],  Exp[-I (a+g)/2] Cos[b/2] }}', ('a', 'b', 'g')),
    ('z', 'FullSimplify[m]', ('m',)),
    ('isZero', 'FullSimplify[m]==ConstantArray[0,Dimensions[m]]', ('m',)),
    ('srmB0', 'Module[{e=Exp[I (a+g)/2]},  {{e,0},{0,Conjugate[e]}}]', ('a', 'g')),
    ('srmBpi', 'Module[{e=Exp[I (g-a)/2]}, {{0,e},{-Conjugate[e],0}}]', ('a', 'g')),
    ('outB0', 'Module[{e=Exp[I (a+g)/2]}, {{e,0},{0,Conjugate[e]}}]', ('a', 'g')),
    ('outBpi', 'Module[{e=Exp[I (g-a)/2]}, {{e,0},{0,Conjugate[e]}}]', ('a', 'g')),
    ('flipB0', 'Module[{e=Exp[-I (a+g)/2]}, {{e,0},{0,Conjugate[e]}}]', ('a', 'g')),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/code-dft_tools-148-derivation/part1b_clean.wl')
