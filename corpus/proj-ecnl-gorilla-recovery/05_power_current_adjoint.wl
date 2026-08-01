Get[FileNameJoin[{DirectoryName[$InputFileName], "checklib.wl"}]];

ClearAll[l, pbeam, pabs, omega, kpar, dE, dp, e, v, source];

(* Beam power bookkeeping. *)
balance = pbeam[l] + pabs[l];
rules = {pbeam'[l] -> -q[l], pabs'[l] -> q[l]};
checkZero["beam plus absorbed power is constant", D[balance, l] /. rules];

(* Photon/travelling-wave ratio. *)
check["parallel momentum per absorbed energy", dp/dE == kpar/omega,
  dp == kpar hbar && dE == omega hbar && omega != 0];

(* Finite-dimensional adjoint identity: L f=S, L^T chi=jkernel. *)
mat = {{a, b}, {c, d}};
fvec = Inverse[mat].{s1, s2};
chi = Inverse[Transpose[mat]].{j1, j2};
check["adjoint current identity",
  {j1, j2}.fvec == chi.{s1, s2}, Det[mat] != 0];

(* Cylindrical radial-current torque sign: e_r cross e_theta=e_phi. *)
er = {1, 0, 0}; etheta = {0, 1, 0}; ephi = {0, 0, 1};
check["radial current crossed with poloidal field is toroidal",
  Cross[er, etheta] == ephi];

reportAndExit[];
