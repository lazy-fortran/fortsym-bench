(* Convert Mathematica notebooks to Wolfram-language source for the corpus.

   Reads a TSV manifest of "<input.nb>\t<output.wl>" lines and writes one .wl
   per notebook, containing the Input cells as InputForm text and nothing else.
   Output cells, formatting and stored results are discarded: the corpus wants
   the derivation, not one machine's record of having run it.

   This is a FORMAT CONVERSION, not a computation. It moves your own notebook
   from one file format to another and produces no mathematical result that
   fortsym relies on. Nothing in fortsym's own build, test suite or CI runs
   this, and the derivations it emits are checked by Mathics and SymPy.
   See LEGAL.md section 5 in the fortsym repository.

   Usage:  NB_MANIFEST=manifest.tsv wolfram -script tools/nb2wl.wls           *)

manifest = Import[Environment["NB_MANIFEST"], "TSV"];
report = {};
Do[
  Module[{in = row[[1]], out = row[[2]], nb, cells, texts, bad = 0},
    nb = Quiet@Check[Get[in], $Failed];
    If[Head[nb] =!= Notebook,
      AppendTo[report, {in, "NOTEBOOK_READ_FAILED", 0, 0}],
      cells = Cases[nb, Cell[b_, "Input", ___] :> b, Infinity];
      texts = Map[
        Function[b,
          Module[{r},
            (* HoldComplete keeps the cell from evaluating during conversion.
               A notebook that computed for an hour must not recompute here,
               and an expression that errors must still convert. *)
            r = Quiet@Check[
              ToString[ToExpression[b, StandardForm, HoldComplete], InputForm],
              $Failed];
            If[!StringQ[r], bad++; "(* UNCONVERTED CELL *)",
              (* strip the HoldComplete[ ... ] wrapper *)
              StringTake[r, {14, -2}]]]],
        cells];
      Quiet@Export[out, StringRiffle[texts, "\n\n"], "Text"];
      AppendTo[report, {in, "OK", Length[cells], bad}]]],
  {row, manifest}];
Export[Environment["NB_REPORT"] /. Except[_String] -> "nb2wl-report.tsv", report, "TSV"];
Print["converted ", Length[report], " notebooks"];
