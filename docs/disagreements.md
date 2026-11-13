# Classifying disagreements

A disagreement identifies a question to investigate. Agreement between reference
systems does not establish that another system is wrong, and numerical samples
do not establish symbolic equivalence.

Classify a saved report against its raw-output cache:

```sh
python -m fortsym_bench.classify results.json \
  --cache results.raw-cache.json \
  --root . --out classified.json
```

Run this from the corpus checkout, or pass its location with `--root`. The report
and cache must belong to the same run. The classifier records their file digests
and does not change the benchmark report or its scoring policy. A raw operand is
used only when the cache has one matching backend/source row and its source
digest matches the current file. Ambiguous or missing operands remain unknown.
The report format does not identify a particular executable within several
cached versions, so choosing the last cache entry would not be reliable.
The command above uses the merged files from `fortsym_bench.campaign merge`;
an individual campaign case stores its cache as `raw-cache.json`. For the
ordinary `fortsym-bench run` command, use the cache path recorded in its report.

The output contains one record per non-agreeing comparison or backend failure.
A reference disagreement is counted once as Mathics versus SymPy; the native
candidate's unscored copy of the same disagreement does not add another record.
Each record retains its observed outcome, classification and supporting evidence.

| Classification | Evidence required |
|---|---|
| `equivalent-form` | A bounded exact polynomial identity, or a reviewed argument |
| `unsupported` | An explicit backend refusal, or reviewed evidence |
| `assumption` | A reviewed argument identifying the differing assumptions |
| `branch` | A reviewed argument identifying the differing branch conventions |
| `translation` | A reviewed argument showing a defect in the companion translation |
| `wrong` | Reviewed mathematical evidence and a minimal reproducer tied to the observed output |
| `unknown` | The available evidence does not establish one of these causes |

The automatic proof language contains exact rational constants, symbols,
addition, multiplication and bounded nonnegative integer powers. It excludes
floating-point comparisons, transcendental identities and symbolic division,
including cancellations that could conceal excluded domain points. An
unproved identity remains unknown. An exact polynomial difference also remains
unknown: it does not identify which implementation follows the intended problem.

Parsing and exact arithmetic run in a separate process with a time budget
(`--timeout`, two seconds by default), bounded text, tree size, degree and
expansion size. On Linux the proof process also has a one-gibibyte address-space
limit. Constructor text is read through a restricted syntax tree, without Python
evaluation. These limits can decline valid identities; they cannot establish
equivalence by sampling.

Skipped companion statements are attached as coverage information. Partial
coverage alone is not classified as a translation defect. Explicit refusals
inside successful executions attach incomplete execution context to affected
comparisons; they may have changed later state. Timeout, execution
error, unavailable backend and absent reference results remain unknown unless a
reviewed argument establishes a cause.

## Reviewed evidence

Use `--reviewed reviewed.json` to supply a JSON list of records. Each record
requires `script` (the extension-free path used by the report), `binding`,
`backend`, `classification`, `rationale`, `reviewed_by`, `observed`,
`comparison_sha256`, `source_sha256`,
`artifact` and `artifact_sha256`. The source digest identifies the corpus `.wl`
file for a Wolfram-language backend and its `.py` companion for a Python
backend. `observed` must match the unique raw operand, or the recorded failure
detail for a script-level failure. The artifact contains the argument or
calculation supporting the assigned cause, and its path is relative to `--root`.
For a `translation` record, `wolfram_sha256` and `companion_sha256` additionally
bind both source representations. Causes other than `wrong` and `unsupported`
also require `reference_observed`, matching the raw operand from the reference
backend used by that comparison.
Copy `comparison_sha256` from the classifier's record for the current run. It
binds the candidate and reference text, their source digests, the outcome and
comparison identity, including for reviewed wrong results. A changed operand
invalidates the reviewed record rather than carrying its label to another run.

A `wrong` record additionally requires `expected`, `reproducer` and
`reproducer_sha256`. The reproducer must exist and match its digest, and
`observed` must match the unique raw cached output for the named backend and
binding. `expected` states the result justified by the independent argument,
not a majority vote among implementations. Other causes should explain their
domain, convention or translation evidence in the artifact.

The classifier checks source, artifact and reproducer identities and rejects
unmatched or duplicate records. It does not recheck the mathematics in a reviewed
artifact; the output retains that limitation and the supplied review record.
If a reviewed record concerns a binding currently scored as agreement, that
record is retained too: benchmark agreement does not override an independently
established defect.
