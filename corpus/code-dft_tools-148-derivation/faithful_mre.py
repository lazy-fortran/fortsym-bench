"""Generated SymPy translation of ``corpus/code-dft_tools-148-derivation/faithful_mre.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 3 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('ifac', 'n!', ('n',)),
    ('smalld', 'Module[{f1,s=0,f2,f3,f4,t},\n  f1=(ifac[l+m] ifac[l-m])/(ifac[l+n] ifac[l-n]);\n  Do[If[(l-m-t)>=0&&(l-n-t)>=0&&(t+n+m)>=0,\n     f2=(ifac[l+n] ifac[l-n])/(ifac[l-m-t] ifac[m+n+t] ifac[l-n-t] ifac[t]);\n     f3=If[(2l-m-n-2t)==0,1,Sin[b/2]^(2l-m-n-2t)];\n     f4=If[(2t+n+m)==0,1,Cos[b/2]^(2t+n+m)];\n     s=s+(-1)^(l-m-t) f2 f3 f4], {t,0,2l}];\n  Sqrt[f1] s]', ('l', 'm', 'n', 'b')),
    ('dmatMM', 'Table[\n  (If[det<-0.5,(-1)^l,1]) Exp[I n a] Exp[I m c] smalld[l,m,n,b],\n  {m,-l,l},{n,-l,l}]', ('l', 'a', 'b', 'c', 'det')),
    ('Tflip', 'Table[If[mp==-m,(-1)^m,0],{mp,-l,l},{m,-l,l}]', ('l',)),
    ('timeinvOrb', 'Tflip[l].Conjugate[mat]', ('l', 'mat')),
    ('rots', '{IdentityMatrix[3],RotationMatrix[Pi/2,{0,0,1}],RotationMatrix[Pi,{0,0,1}],\n      RotationMatrix[3Pi/2,{0,0,1}],RotationMatrix[Pi,{1,0,0}],RotationMatrix[Pi,{0,1,0}],\n      RotationMatrix[Pi,{1,1,0}],RotationMatrix[Pi,{1,-1,0}]}', ()),
    ('ng', 'Length[rots]', ()),
    ('tinv', '(R[[1,1]]R[[2,2]]-R[[1,2]]R[[2,1]])<0', ('R',)),
    ('ea', 'EulerAngles[R]', ('R',)),
    ('det3', 'Det[R]', ('R',)),
    ('buildMat', 'Module[{e=ea[R],a,b,g,ph,rotl,rr,eph,z},\n  {a,b,g}=e; ph=If[tinv[R],g-a,a+g];\n  rotl=dmatMM[l,a,b,g,det3[R]];\n  rr=If[tinv[R],timeinvOrb[l,rotl],rotl];\n  eph=Exp[sgn I ph/2]; z=0 rr;\n  ArrayFlatten[{{eph rr, z},{z, Conjugate[eph] rr}}]]', ('l', 'R', 'sgn')),
    ('symmAvg', 'Module[{mats=buildMat[l,#,sgn]&/@rots},\n  (1/ng) Sum[mats[[i]].If[tinv[rots[[i]]],Conjugate[M],M].ConjugateTranspose[mats[[i]]],{i,ng}]]', ('l', 'sgn', 'M')),
    ('runTest', 'Module[{d=2(2l+1),A,M0,res},\n  A=RandomComplex[{-1-I,1+I},{d,d}];M0=(A+ConjugateTranspose[A])/2;\n  Print["---- l=",l," (dim ",d,") ----"];\n  Do[Module[{Ms,Mss,idem,drift},\n    Ms=N@symmAvg[l,sgn,M0];Mss=N@symmAvg[l,sgn,Ms];\n    idem=Max@Abs@Flatten[Mss-Ms];\n    drift=Max@Abs[Sort[Re@Eigenvalues[Ms]]-Sort[Re@Eigenvalues[Mss]]];\n    Print["  ",If[sgn==1,"CURRENT exp(+i ph/2)","FLIP    exp(-i ph/2)"],\n      ": idempotency=",ScientificForm[idem,3]," eig-shift=",ScientificForm[drift,3]];\n   ],{sgn,{1,-1}}]]', ('l',)),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/code-dft_tools-148-derivation/faithful_mre.wl')
