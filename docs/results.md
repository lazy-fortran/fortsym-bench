# Results

Full agreement between fortsym, SymPy and Mathics has not been established.
The benchmark reports agreement, differences, explicit refusals, timeouts,
execution errors and disagreements between the two reference systems separately.
Agreement between partial reference systems does not prove mathematical
correctness.

A measured result is the JSON report from `fortsym-bench run`, together with
its backend versions and raw-output cache. Compare implementations using the
same corpus, reference outputs, timeout and comparison policy. A larger agreement
count caused by missing or timed-out reference results does not establish an
improvement. Keep such results in the coverage totals and out of timing samples.

[Running the benchmark](running.md) describes report generation and cache
invalidation; [Comparison and outcomes](comparison.md) defines the verdicts.
