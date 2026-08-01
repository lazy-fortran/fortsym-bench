(* Shared check harness for memo verification scripts. *)

$failCount = 0;

check[label_String, expr_] := Module[{ok},
  ok = Simplify[expr];
  If[ok === True,
    Print["PASS  ", label],
    $failCount++;
    Print["FAIL  ", label, "  -> ", InputForm[ok]]
  ]
];

reportAndExit[] := (
  Print["----"];
  If[$failCount === 0,
    Print["ALL CHECKS PASSED"],
    Print[$failCount, " CHECK(S) FAILED"]
  ];
  Exit[If[$failCount === 0, 0, 1]]
);
