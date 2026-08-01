(* Exact check harness for the ECNL physics monograph. *)

$failCount = 0;

check[label_String, proposition_, assumptions_: True] := Module[{result},
  result = FullSimplify[proposition, assumptions];
  If[TrueQ[result],
    Print["PASS  ", label],
    $failCount++;
    Print["FAIL  ", label, "  -> ", InputForm[result]]
  ]
];

checkZero[label_String, expression_, assumptions_: True] :=
  check[label, expression == 0, assumptions];

reportAndExit[] := (
  Print["----"];
  If[$failCount == 0,
    Print["ALL CHECKS PASSED"],
    Print[$failCount, " CHECK(S) FAILED"]
  ];
  Exit[If[$failCount == 0, 0, 1]]
);
