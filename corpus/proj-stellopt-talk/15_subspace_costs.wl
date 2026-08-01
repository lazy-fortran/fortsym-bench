(* Slide 15: sensitivity subspaces. J_protected = U Sigma V^T:
     - SVD reconstruction for a random matrix;
     - moving along right singular vectors with the smallest sigma changes
       |J x| least: min over unit vectors of |J x| is sigma_min, attained
       at v_min, and |J v_i| = sigma_i orders the directions;
     - evaluation-count algebra: full FD gradient N+1 evaluations,
       d+1 in a d-dimensional subspace, 2k for k central stochastic
       directional derivatives. *)

failed = 0;
check[name_String, cond_] := Module[{ok = TrueQ[cond]},
    Print[If[ok, "PASS: ", "FAIL: "], name];
    If[! ok, failed++]; ok];

SeedRandom[7];
tol = 10.^-10;
jm = RandomReal[{-1, 1}, {8, 5}];
{u, s, v} = SingularValueDecomposition[jm];
sig = Diagonal[s];
check["SVD reconstruction U.Sigma.V^T = J",
    Max[Abs[u . s . Transpose[v] - jm]] < tol];
check["singular values sorted decreasing, all positive",
    And @@ Thread[Most[sig] >= Rest[sig]] && Min[sig] > 0];

(* ---------- smallest-sigma direction changes |J x| least ---------- *)
vmin = v[[All, -1]]; sigmin = Last[sig];
check["|J v_min| = sigma_min", Abs[Norm[jm . vmin] - sigmin] < tol];
check["|J v_i| = sigma_i for every right singular vector",
    Max[Table[Abs[Norm[jm . v[[All, i]]] - sig[[i]]], {i, 5}]] < tol];
check["v_min gives the smallest response among the singular directions",
    Min[Table[Norm[jm . v[[All, i]]], {i, 4}]] >= Norm[jm . vmin]];
rand = Table[Normalize[RandomReal[{-1, 1}, 5]], {200}];
minRand = Min[Norm[jm . #] & /@ rand];
Print["  sigma_min = ", sigmin, "; min |J x| over 200 random unit x = ",
    minRand];
check["no random unit vector beats sigma_min: |J x| >= sigma_min",
    minRand >= sigmin - tol];
(* exact statement: min_{|x|=1} |J x|^2 = smallest eigenvalue of J^T J *)
check["sigma_min^2 = smallest eigenvalue of J^T J",
    Abs[sigmin^2 - Min[Eigenvalues[Transpose[jm] . jm]]] < tol];

(* ---------- evaluation-count algebra ---------- *)
fdCost = nN + 1;      (* forward-difference gradient in N dims *)
subCost = d + 1;      (* forward-difference gradient in d-dim subspace *)
stochCost = 2 k;      (* k central stochastic directional derivatives *)
check["subspace saving: (N+1) - (d+1) = N - d evaluations",
    Simplify[fdCost - subCost == nN - d] === True];
check["d < N implies d+1 < N+1 (subspace gradient always cheaper)",
    Simplify[subCost < fdCost, Assumptions -> d < nN] === True];
check["k < N/2 implies 2k < N+1 (stochastic probing cheaper than full FD)",
    Simplify[stochCost < fdCost, Assumptions -> 0 < k < nN/2] === True];
inst = {nN -> 100, d -> 7, k -> 3};
Print["  instance N = 100, d = 7, k = 3: costs ", {fdCost, subCost,
    stochCost} /. inst];
check["instance N = 100, d = 7, k = 3 gives costs 101, 8, 6",
    ({fdCost, subCost, stochCost} /. inst) === {101, 8, 6}];

If[failed > 0,
    Print["RESULT: FAIL (", failed, " checks failed)"]; Quit[1],
    Print["RESULT: PASS"]; Quit[0]];
