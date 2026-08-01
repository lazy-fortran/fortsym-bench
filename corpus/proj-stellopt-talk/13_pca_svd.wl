(* Slide 13: PCA as SVD. For fixed random data X (n samples x p features):
     - principal axes (eigenvectors of the sample covariance of centered X)
       equal the right singular vectors of centered X up to sign;
     - variance identity Total[sigma_i^2] = (n-1) Total[eigenvalues];
     - Eckart-Young: the rank-k SVD truncation beats random rank-k
       alternatives in Frobenius norm, and its error is
       Sqrt[Total[sigma_{k+1..}^2]]. *)

failed = 0;
check[name_String, cond_] := Module[{ok = TrueQ[cond]},
    Print[If[ok, "PASS: ", "FAIL: "], name];
    If[! ok, failed++]; ok];

SeedRandom[42];
n = 40; p = 6; tol = 10.^-10;
xraw = RandomReal[{-1, 1}, {n, p}];
xc = # - Mean[xraw] & /@ xraw; (* centered data *)

{u, s, v} = SingularValueDecomposition[xc];
sig = Diagonal[s];
check["SVD reconstruction U.S.V^T = Xc",
    Max[Abs[u . s . Transpose[v] - xc]] < tol];

cov = Transpose[xc] . xc/(n - 1);
{evals, evecs} = Eigensystem[cov]; (* sorted, decreasing for PSD cov *)
check["sigma_i^2/(n-1) equals covariance eigenvalues (sorted)",
    Max[Abs[sig^2/(n - 1) - evals]] < tol];
aligns = Table[Abs[evecs[[i]] . v[[All, i]]], {i, p}];
Print["  |<eigvec_i, v_i>| = ", aligns];
check["principal components equal right singular vectors up to sign",
    Min[aligns] > 1 - tol];
check["captured-variance identity Total[sigma^2] = (n-1) Total[eigenvalues]",
    Abs[Total[sig^2] - (n - 1) Total[evals]] < tol];

(* ---------- Eckart-Young ---------- *)
k = 2;
xk = u[[All, 1 ;; k]] . s[[1 ;; k, 1 ;; k]] . Transpose[v[[All, 1 ;; k]]];
errSVD = Norm[xc - xk, "Frobenius"];
check["rank of SVD truncation is k", MatrixRank[xk, Tolerance -> 10.^-8] == k];
check["truncation error equals Sqrt[Total[sigma_{k+1..}^2]]",
    Abs[errSVD - Sqrt[Total[sig[[k + 1 ;;]]^2]]] < tol];

(* random rank-k competitors: projections onto random k-dim row spaces,
   and fully random rank-k matrices *)
worst = True; errs = {};
Do[
    qq = Orthogonalize[RandomReal[{-1, 1}, {k, p}]];
    bProj = xc . Transpose[qq] . qq;
    bRand = RandomReal[{-1, 1}, {n, k}] . RandomReal[{-1, 1}, {k, p}];
    errs = Join[errs, {Norm[xc - bProj, "Frobenius"],
        Norm[xc - bRand, "Frobenius"]}],
    {trial, 5}];
Print["  errSVD = ", errSVD, "; random rank-k errors min = ", Min[errs],
    ", max = ", Max[errs]];
check["Eckart-Young: SVD truncation beats all 10 random rank-k alternatives",
    Min[errs] >= errSVD - tol];

If[failed > 0,
    Print["RESULT: FAIL (", failed, " checks failed)"]; Quit[1],
    Print["RESULT: PASS"]; Quit[0]];
