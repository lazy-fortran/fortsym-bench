(* Slides 11/12: bootstrap convergence model
       lambda_bB[nu_star] = lambda_SC + Lambda_A/Sqrt[nu_star] + Lambda_B/nu_star.
   Asymptotic structure, pure algebra with Limit/Series:
     - nu_star -> Infinity, collisional side: both offset terms -> 0, so
       lambda_bB -> lambda_SC. NOTE: this is NOT the physical
       collisionless limit.
     - nu_star -> 0+ IS the collisionless limit: the offset terms DIVERGE
       unless Lambda_A = Lambda_B = 0, and the 1/nu_star term dominates
       the 1/Sqrt[nu_star] term.
   Sanity numbers: nautilus libneo coefficients parsed from
   data/rabe/coeffs.txt: C_A, C_B, lambda_SC.
   CAUTION for editors: never write "nu" followed by star-paren in a
   comment; the star-paren pair terminates a Mathematica comment. *)

failed = 0;
check[name_String, cond_] := Module[{ok = TrueQ[cond]},
    Print[If[ok, "PASS: ", "FAIL: "], name];
    If[! ok, failed++]; ok];

termA = la/Sqrt[nu]; termB = lb/nu;
offset = termA + termB;
lambdabB = lsc + offset;

(* ---------- nu* -> Infinity: offset vanishes ---------- *)
check["offset -> 0 as nu* -> Infinity",
    Limit[offset, nu -> Infinity] === 0];
check["lambda_bB -> lambda_SC as nu* -> Infinity",
    Limit[lambdabB, nu -> Infinity] === lsc];
(* expand in t = 1/Sqrt[nu]: offset = Lambda_A t + Lambda_B t^2 exactly,
   so the slowest-decaying term at large nu* is Lambda_A/Sqrt[nu*] *)
serT = Normal[Series[offset /. nu -> 1/t^2, {t, 0, 2}]];
check["series in t = 1/Sqrt[nu*]: offset = Lambda_A t + Lambda_B t^2 exactly",
    Simplify[serT - (la t + lb t^2), Assumptions -> t > 0] === 0];
check["leading large-nu* behavior: Sqrt[nu*] offset -> Lambda_A",
    Limit[Sqrt[nu] offset, nu -> Infinity] === la];

(* ---------- nu* -> 0+ (collisionless): offset diverges ---------- *)
check["term Lambda_A/Sqrt[nu*] diverges as nu* -> 0+ (Lambda_A > 0)",
    Limit[termA, nu -> 0, Direction -> "FromAbove",
        Assumptions -> la > 0] === Infinity];
check["term Lambda_B/nu* diverges as nu* -> 0+ (Lambda_B > 0)",
    Limit[termB, nu -> 0, Direction -> "FromAbove",
        Assumptions -> lb > 0] === Infinity];
check["offset stays 0 for all nu* only if Lambda_A = Lambda_B = 0",
    Simplify[offset /. {la -> 0, lb -> 0}] === 0];
check["1/nu* dominates 1/Sqrt[nu*]: |term_B/term_A| -> Infinity as nu* -> 0+",
    Limit[Abs[termB/termA], nu -> 0, Direction -> "FromAbove",
        Assumptions -> la > 0 && lb > 0] === Infinity];
check["ratio term_B/term_A = (Lambda_B/Lambda_A)/Sqrt[nu*] exactly",
    Simplify[termB/termA - (lb/la)/Sqrt[nu]] === 0];

(* ---------- nautilus sanity numbers from coeffs.txt ---------- *)
file = "/home/ert/proj/stellopt-talk/data/rabe/coeffs.txt";
num[s_String, key_String] := ToExpression[StringReplace[First[
    StringCases[s, key ~~ "=" ~~ x : Except[WhitespaceCharacter] .. :> x]],
    {"e" -> "*^", "E" -> "*^"}]];
line = First[Select[Import[file, "Lines"], StringContainsQ[#, "nautilus libneo"] &]];
{caN, cbN, lscN} = {num[line, "C_A"], num[line, "C_B"], num[line, "lambda_SC"]};
Print["  nautilus libneo: C_A = ", caN, ", C_B = ", cbN, ", lambda_SC = ", lscN];
check["parsed nautilus coefficients are nonzero reals",
    VectorQ[{caN, cbN, lscN}, NumericQ] && caN != 0 && cbN != 0];

lamN[nuv_] := lscN + caN/Sqrt[nuv] + cbN/nuv;
offs = Table[Abs[lamN[10.^e] - lscN], {e, {-8, -6, -4, -2, 0}}];
Print["  |lambda_bB - lambda_SC| at nu* = 1e-8..1: ", offs];
check["nautilus: offset magnitude decreases monotonically with nu*",
    And @@ Thread[Most[offs] > Rest[offs]]];
check["nautilus: offset at nu* = 1e-8 exceeds offset at nu* = 1 by > 1e3",
    First[offs] > 10.^3 Last[offs]];

If[failed > 0,
    Print["RESULT: FAIL (", failed, " checks failed)"]; Quit[1],
    Print["RESULT: PASS"]; Quit[0]];
