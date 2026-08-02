"""Generated SymPy translation of ``corpus/code-dft_tools-148-derivation/mre2.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 5 non-assignment statement(s) remain.
COMPARE = {
    'runTest': 'numeric',
}
_ASSIGNMENTS = [
    ('rots', '{IdentityMatrix[3],\n        RotationMatrix[Pi/2,{0,0,1}], RotationMatrix[Pi,{0,0,1}], RotationMatrix[3 Pi/2,{0,0,1}],\n        RotationMatrix[Pi,{1,0,0}], RotationMatrix[Pi,{0,1,0}],\n        RotationMatrix[Pi,{1,1,0}], RotationMatrix[Pi,{1,-1,0}]}', ()),
    ('ng', 'Length[rots]', ()),
    ('tinv', '(R[[1,1]] R[[2,2]] - R[[1,2]] R[[2,1]]) < 0', ('R',)),
    ('phaseOf', 'Module[{e=EulerAngles[R],a,b,g}, {a,b,g}=e; If[tinv[R], g-a, a+g]]', ('R',)),
    ('Dl', 'Module[{e=EulerAngles[R],a,b,g}, {a,b,g}=e;\n   If[l==0, {{1}}, Table[Conjugate[WignerD[{l,mp,m},a,b,g]],{mp,l,-l,-1},{m,l,-l,-1}]]]', ('l', 'R')),
    ('mkMat', 'Module[{ph=phaseOf[R], e=0, d=Dl[l,R], z},\n   e=Exp[sgn I ph/2]; z=0 d; ArrayFlatten[{{e d, z},{z, Conjugate[e] d}}]]', ('l', 'R', 'sgn')),
    ('savg', '(1/ng) Sum[\n   With[{g=mkMat[l,rots[[i]],sgn], ti=tinv[rots[[i]]]},\n     g . If[ti, Conjugate[M], M] . ConjugateTranspose[g]], {i,ng}]', ('l', 'sgn', 'M')),
    ('runTest', 'Module[{dim=2(2l+1), A, M0, res},\n  A = RandomComplex[{-1-I,1+I},{dim,dim}]; M0=(A+ConjugateTranspose[A])/2;\n  Print["---- l=",l,"  (spin x orbital dim = ",dim,") ----"];\n  Do[Module[{Ms, Mss, idem, drift},\n     Ms  = savg[l,sgn,M0];\n     Mss = savg[l,sgn,Ms];\n     idem  = Max@Abs@Flatten[N[Mss-Ms]];\n     drift = Max@Abs[ Sort[Re@Eigenvalues[N@Ms]] - Sort[Re@Eigenvalues[N@Mss]] ];\n     Print["  ", If[sgn==1,"CURRENT exp(+i ph/2)","FLIP    exp(-i ph/2)"],\n           ":  idempotency |S^2-S| = ", ScientificForm[idem,3],\n           "   eig-shift = ", ScientificForm[drift,3]];\n     ], {sgn,{1,-1}}];\n]', ('l',)),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/code-dft_tools-148-derivation/mre2.wl')
