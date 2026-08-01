"""Generated SymPy translation of ``corpus/gh-itpplasma-paper_sympl/sympl__c06e3c.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 19 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('$Assumptions', '{Element[a, Reals], Element[r, Reals], Element[th, Reals], Element[ph, Reals], Element[r0, Reals], eps > 0, eps < R0, R0 > 0, R0 < 1, r > 0, a > 0}', ()),
    ('psitor', '(r^2*Subscript[B, 0])/2', ()),
    ('psipol', 'io0*Subscript[B, 0]*(r^2/2 - r^4/(4*a^2))', ()),
    ('F', '(-Subscript[B, 0])*(r^3/(3*Subscript[R, 0]))*Sin[ϑ]', ()),
    ('io', 'io0*(1 - r^2/a^2)', ()),
    ('psitorpr', 'D[psitor, r]', ()),
    ('psipolpr', 'psitorpr*io', ()),
    ('psipol', 'Integrate[psipolpr, r]', ()),
    ('Ath', 'psitor + D[F, ϑ]', ()),
    ('Aph', '-psipol + D[F, φ]', ()),
    ('hth', 'ι*(r^2/Subscript[R, 0])', ()),
    ('hph', 'Subscript[R, 0] + r*Cos[ϑ]', ()),
    ('sqg', 'FullSimplify[(hph*D[Ath, r] + hth*r*ι*Subscript[B, 0])/B[r, ϑ]]', ()),
    ('Bph', 'D[Ath, eps]/(sqrtg*R0)', ()),
    ('Bth', '-D[Aph, eps]/(sqrtg*R0)', ()),
    ('gtt', 'hth/(Bth/B)', ()),
    ('Bthphys', 'FullSimplify[Sqrt[gtt]*Bth]', ()),
    ('hth', 'io0*(1 - r^2/a^2)*(r^2/Subscript[R, 0])', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/gh-itpplasma-paper_sympl/sympl__c06e3c.wl')
