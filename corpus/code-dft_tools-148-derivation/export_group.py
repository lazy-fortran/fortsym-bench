"""Generated SymPy translation of ``corpus/code-dft_tools-148-derivation/export_group.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 1 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('rots', '{IdentityMatrix[3],RotationMatrix[Pi/2,{0,0,1}],RotationMatrix[Pi,{0,0,1}],\n      RotationMatrix[3Pi/2,{0,0,1}],RotationMatrix[Pi,{1,0,0}],RotationMatrix[Pi,{0,1,0}],\n      RotationMatrix[Pi,{1,1,0}],RotationMatrix[Pi,{1,-1,0}]}', ()),
    ('tinv', '(R[[1,1]]R[[2,2]]-R[[1,2]]R[[2,1]])<0', ('R',)),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/code-dft_tools-148-derivation/export_group.wl')
