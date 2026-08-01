(* Verify`  --  machine-verification harness for the Albert (2017) thesis.
   Each check records a result; EndSuite writes JSON and sets the exit code.
   Symbolic checks use FullSimplify; numeric checks evaluate (and may contain
   NIntegrate / elliptic functions) and compare against a tolerance. *)

BeginPackage["Verify`"];

BeginSuite::usage   = "BeginSuite[name] resets the accumulator for a suite.";
EndSuite::usage     = "EndSuite[outfile] writes JSON, prints a summary, exits 0/1.";
CheckEq::usage      = "CheckEq[label, lhs, rhs, assum:True] symbolic equality (lhs-rhs simplifies to 0).";
CheckTrue::usage    = "CheckTrue[label, claim, assum:True] symbolic truth of a proposition.";
CheckClose::usage   = "CheckClose[label, a, b, tol:10^-8] numeric closeness of two values.";
CheckLimit::usage   = "CheckLimit[label, expr, var->pt, ref, assum:True] symbolic limit equals ref.";
Note::usage         = "Note[label, text] records a non-pass/fail annotation (e.g. a thesis typo).";

Begin["`Private`"];

$results = {};
$suite = "unnamed";

BeginSuite[name_String] := ($suite = name; $results = {};);

record[label_, kind_, pass_, detail_] :=
  AppendTo[$results, <|
     "label" -> label, "kind" -> kind,
     "pass" -> If[pass === None, Null, TrueQ[pass]],
     "detail" -> ToString[detail, InputForm]|>];

symZeroQ[expr_, assum_] := Module[{s},
   s = Quiet @ Check[Simplify[expr, assum], $Failed];
   If[TrueQ[s == 0], Return[True]];
   s = Quiet @ Check[FullSimplify[expr, assum], $Failed];
   TrueQ[s == 0]];

CheckEq[label_, lhs_, rhs_, assum_: True] := Module[{pass, res},
   pass = symZeroQ[lhs - rhs, assum];
   res = If[pass, 0, Quiet @ Check[FullSimplify[lhs - rhs, assum], "simplify-failed"]];
   record[label, "symbolic", pass, res];
   Print[If[pass, "  PASS ", "  FAIL "], label];
   pass];

CheckTrue[label_, claim_, assum_: True] := Module[{pass},
   pass = TrueQ[Quiet @ Check[FullSimplify[claim, assum], $Failed]];
   record[label, "symbolic", pass, If[pass, "True", "not-proven"]];
   Print[If[pass, "  PASS ", "  FAIL "], label];
   pass];

CheckClose[label_, a_, b_, tol_: 10^-8] := Module[{d, pass},
   d = Quiet[N[a - b, 30]];
   If[! NumericQ[d], d = Quiet[N[a - b]]];
   pass = NumericQ[d] && Abs[d] < tol;
   record[label, "numeric", pass, If[NumericQ[d], Abs[d], d]];
   Print[If[pass, "  PASS ", "  FAIL "], label, "  (|err|=", If[NumericQ[d], Abs[d], d], ")"];
   pass];

CheckLimit[label_, expr_, rule_, ref_, assum_: True] := Module[{lim, pass},
   lim = Quiet @ Check[Limit[expr, rule, Assumptions -> assum], $Failed];
   pass = symZeroQ[lim - ref, assum];
   record[label, "limit", pass, lim];
   Print[If[pass, "  PASS ", "  FAIL "], label, "  -> ", lim];
   pass];

Note[label_, text_] := (record[label, "note", None, text];
   Print["  NOTE ", label, ": ", text];);

EndSuite[outfile_] := Module[{checks, ntot, npass, failed},
   checks = Select[$results, #["kind"] =!= "note" &];
   ntot = Length[checks];
   npass = Count[checks, _?(#["pass"] === True &)];
   failed = Select[checks, #["pass"] =!= True &];
   Export[outfile, <|"suite" -> $suite, "total" -> ntot, "passed" -> npass,
      "results" -> $results|>, "JSON"];
   Print["SUITE ", $suite, ": ", npass, "/", ntot, " passed"];
   If[Length[failed] > 0,
      Print["FAILED: ", StringRiffle[failed[[All, "label"]], ", "]]];
   Exit[If[npass === ntot, 0, 1]]];

End[];
EndPackage[];
