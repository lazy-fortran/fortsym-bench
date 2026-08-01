ClearAll["Global`*"];
pass = 0; fail = 0;
check[name_, condition_] := If[TrueQ[condition],
  pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]];

(* Schwab 1991, Section 3.3: toroidal node numbers n of one perturbation
   couple only when n_k - n_l or n_k + n_l is an integer multiple of NT.
   On residues mod NT this generates the mode families. *)
coupled[nt_][a_, b_] :=
  Mod[a - b, nt] == 0 || Mod[a + b, nt] == 0;
familyOf[nt_, seed_] := Union[Mod[{seed, -seed}, nt]];
families[nt_] := DeleteDuplicates[
  Table[familyOf[nt, seed], {seed, 1, nt - 1}]];

check["family count is Floor[NT/2] for NT = 2..12",
  And @@ Table[Length[families[nt]] == Floor[nt/2], {nt, 2, 12}]];
check["families partition the nonzero residues",
  And @@ Table[
    Sort[Flatten[families[nt]]] == Range[1, nt - 1], {nt, 2, 12}]];
check["families are closed under the coupling rule",
  And @@ Flatten[Table[
    With[{fams = families[nt]},
      Table[
        And @@ Flatten[Outer[coupled[nt], fam, fam]] &&
          And @@ Table[
            Not[Or @@ Flatten[Outer[coupled[nt], fam, other]]],
            {other, DeleteCases[fams, fam]}],
        {fam, fams}]],
    {nt, 2, 12}]]];
check["n = NT - seed lies in the seed family",
  And @@ Flatten[Table[
    MemberQ[familyOf[nt, seed], Mod[nt - seed, nt]],
    {nt, 2, 12}, {seed, 1, Floor[nt/2]}]]];
check["residue zero couples only to itself: excluded N = 0 class",
  And @@ Table[
    Not[Or @@ Table[coupled[nt][0, n], {n, 1, nt - 1}]], {nt, 3, 12}]];

(* Axis regularity of the CAS3D2 form function f(s) = s^(m/2) (1 - s)
   with flux label s = rho^2: polynomial in rho, so smooth at the axis. *)
formFunction[m_, s_] := s^(m/2) (1 - s);
check["form function is polynomial in rho for m = 0..8",
  And @@ Table[
    PolynomialQ[PowerExpand[formFunction[m, rho^2]], rho], {m, 0, 8}]];
check["form function scales as rho^m at the axis",
  And @@ Table[
    SeriesCoefficient[PowerExpand[formFunction[m, rho^2]],
        {rho, 0, m}] == 1, {m, 0, 8}]];
check["s-derivative bounded at the axis iff m >= 2",
  And @@ Table[
    With[{limit = Limit[D[formFunction[m, s], s], s -> 0,
        Direction -> "FromAbove"]},
      If[m >= 2, FreeQ[limit, DirectedInfinity],
        m == 1 && MatchQ[limit, DirectedInfinity[___]] ||
          m == 0 && limit == -1]],
    {m, 0, 8}]];
check["form function vanishes at the fixed boundary",
  And @@ Table[formFunction[m, 1] == 0, {m, 0, 8}]];

Print["SUMMARY ", pass, " passed, ", fail, " failed"];
Quit[If[fail == 0, 0, 1]];
