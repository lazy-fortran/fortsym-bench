"""Generated SymPy translation of ``corpus/code-dft_tools-148-derivation/diag.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 5 non-assignment statement(s) remain.
COMPARE = {
    'closure': 'numeric',
}
_ASSIGNMENTS = [
    ('rots', '{IdentityMatrix[3],\n        RotationMatrix[Pi/2,{0,0,1}], RotationMatrix[Pi,{0,0,1}], RotationMatrix[3 Pi/2,{0,0,1}],\n        RotationMatrix[Pi,{1,0,0}], RotationMatrix[Pi,{0,1,0}],\n        RotationMatrix[Pi,{1,1,0}], RotationMatrix[Pi,{1,-1,0}]}', ()),
    ('ng', 'Length[rots]', ()),
    ('tinv', '(R[[1,1]]R[[2,2]]-R[[1,2]]R[[2,1]])<0', ('R',)),
    ('Dlf', 'Module[{e=EulerAngles[R],a,b,g},{a,b,g}=e;\n   Table[WignerD[{l,mp,m},a,b,g],{mp,l,-l,-1},{m,l,-l,-1}]]', ('l', 'R')),
    ('orbS', '(1/ng) Sum[Dlf[l,rots[[i]]].M.ConjugateTranspose[Dlf[l,rots[[i]]]],{i,ng}]', ('l', 'M')),
    ('orbTest', 'Module[{d=2l+1,A,M,Ms,Mss},A=RandomComplex[{-1-I,1+I},{d,d}];M=(A+ConjugateTranspose[A])/2;\n  Ms=orbS[l,M];Mss=orbS[l,Ms];\n  Print["orbital-only l=",l,"  |S^2-S|=",ScientificForm[N@Max@Abs@Flatten[Mss-Ms],3]]]', ('l',)),
    ('closure', 'Module[{worst=0},Do[worst=Max[worst,\n   Max@Abs@Flatten@N[Dlf[l,rots[[i]]].Dlf[l,rots[[j]]]-Dlf[l,rots[[i]].rots[[j]]]]],{i,ng},{j,ng}];\n   Print["rep closure l=",l,"  max|D(Ri)D(Rj)-D(RiRj)|=",ScientificForm[worst,3]]]', ('l',)),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/code-dft_tools-148-derivation/diag.wl')
