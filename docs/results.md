# Results

Latest controlled checkpoint (2026-10-21): fresh native output from fortsym commit
`307e2be2`, scored against retained raw oracle outputs. The native backend produced
results for 377 of 384 scripts (six unsupported, one unavailable) and 4597
comparable bindings:

| Outcome | Count |
|---|---:|
| Agreement | 3693 |
| Native result differs from oracle | 188 |
| Oracles disagree with each other | 535 |
| Oracle result missing | 180 |
| Native timeout | 1 |

No native execution error was recorded. The remaining timeout is the `mag_drift`
script under a 60-second limit.

Rescoring against freshly regenerated Mathics output gave a higher agreement count
(3959), but only because Mathics timeouts reduced oracle coverage; it is not evidence
of a native improvement. Comparisons between fortsym versions should use a fixed set
of oracle outputs.

Agreement with two partial oracles does not by itself establish mathematical
correctness, and full parity has not been reached.
