(* Check: is Dyf0 = d(force)/d(p) a clean invertible cyclotron rotation (3x3),
   or is the parallel direction structurally different (2-fast + 1-slow)?
   Tokamak metric + exact-curl A from cp_cpp_derivation.wl section F. *)
m=1; qc=1; mu=1/10;
gT[r_,th_]:=DiagonalMatrix[{1, r^2, (R0+r Cos[th])^2}]/.R0->3;
AthF[r_,th_]:=B0 (r^2/2 - r^3 Cos[th]/(3 R0))/.{B0->1,R0->3};
AphF[r_,th_]:=-B0 iota0 (r^2/2 - r^4/(4 r0a^2))/.{B0->1,iota0->1,r0a->1};
Acov[r_,th_]:={0,AthF[r,th],AphF[r,th]};
(* field |B|, h from A *)
qv={r,th,ph};
sqrtg[r_,th_]:=Sqrt[Det[gT[r,th]]];
Bctr[r_,th_]:=Module[{Aa=Acov[rr,tt]},
  Table[(1/sqrtg[rr,tt]) Sum[LeviCivitaTensor[3][[i,j,k]] D[Aa[[k]],{rr,tt,ph}[[j]]],{j,3},{k,3}],{i,3}]/.{rr->r,tt->th}];
Bmod[r_,th_]:=Sqrt[Bctr[r,th].gT[r,th].Bctr[r,th]];
(* force_k(p) = (m/2) dg_ij,k u^i u^j + qc dA_j,k u^j - mu dBmod_k, u=(1/m)ginv(p-qcA) *)
force[p_,r0_,th0_,ph0_]:=Module[{u,gi,dg,dA,dB,fk},
  gi=Inverse[gT[rr,tt]];
  u=(1/m) gi.(p-qc Acov[rr,tt]);
  dg=Table[D[gT[rr,tt][[i,j]],{rr,tt,ph}[[k]]],{i,3},{j,3},{k,3}];
  dA=Table[D[Acov[rr,tt][[i]],{rr,tt,ph}[[k]]],{i,3},{k,3}];
  dB=Table[D[Bmod[rr,tt],{rr,tt,ph}[[k]]],{k,3}];
  fk=Table[(m/2) Sum[dg[[i,j,k]] u[[i]] u[[j]],{i,3},{j,3}] + qc Sum[dA[[j,k]] u[[j]],{j,3}] - mu dB[[k]],{k,3}];
  fk/.{rr->r0,tt->th0}];
(* parallel-only seed at (r,th,ph)=(0.5,0.7,0): p = m vpar h + qc A, vpar=0.3 *)
r0=0.5; th0=0.7; vpar=0.3;
hcov=gT[r0,th0].Bctr[r0,th0]/Bmod[r0,th0];
p0=m vpar hcov + qc Acov[r0,th0];
(* Dyf0 = d force/d p at p0 (3x3) *)
ps={px,py,pz};
J=Table[D[force[ps,r0,th0,0][[a]],ps[[b]]],{a,3},{b,3}]/.Thread[ps->p0]//N;
Print["Dyf0 (d force/d p) ="]; Print[MatrixForm[Chop[J]]];
Print["singular values = ", Chop[SingularValueList[J]]];
Print["antisymmetric part (cyclotron) norm = ", Chop[Norm[(J-Transpose[J])/2,"Frobenius"]]];
Print["symmetric part norm = ", Chop[Norm[(J+Transpose[J])/2,"Frobenius"]]];
Print["b (unit field, contravariant) = ", Chop[N[Bctr[r0,th0]/Bmod[r0,th0]]]];
Print["J . b  (should be ~0 if parallel is in kernel of cyclotron) = ",
  Chop[J . N[Inverse[gT[r0,th0]].hcov]]];
Quit[];
