"""Corpus runner: run every script under every backend, compare, and time."""

from __future__ import annotations

import argparse
from concurrent.futures import ThreadPoolExecutor
import json
import os
import statistics
import sys
from pathlib import Path

from .backends import BACKENDS, DEFAULT_BACKENDS, RunFailure, run
from .cache import ReferenceCache
from .compare import (
    AGREE,
    DIFFER,
    ERROR,
    ORACLE_DISAGREEMENT,
    ORACLE_MISSING,
    TIMEOUT,
    UNAVAILABLE,
    UNSUPPORTED,
    UNTRANSLATED,
    check_oracles,
    compare,
    compare_text,
    parse,
)

CORPUS = Path("corpus")
REFERENCE_BACKENDS = frozenset(("sympy", "mathics"))
CACHEABLE_BACKENDS = frozenset((*REFERENCE_BACKENDS, "fortsym-wl"))


def discover(roots: list[Path]) -> list[Path]:
    """Corpus entries, keyed by extension-less stem path.

    An entry may have a .wl, a .py, or both. Most of the corpus is .wl only
    today — ingested from the original derivations and not yet translated — and
    those still run the Wolfram path against Mathics. A backend whose source
    file is absent reports `untranslated`, which is tracked separately from
    every scored class so an untranslated corpus cannot inflate or deflate a
    pass rate.
    """
    stems = set()
    for root in roots:
        found = sorted(root.rglob("*")) if root.is_dir() else [root]
        for f in found:
            if f.suffix in (".py", ".wl") and not f.name.startswith("_"):
                stems.add(f.with_suffix(""))
    return sorted(stems)


def run_one(
    backend_name: str,
    script: Path,
    repeat: int,
    timeout: float,
    cache: ReferenceCache | None = None,
    refresh: bool = False,
):
    backend = BACKENDS[backend_name]
    source = script.with_suffix(backend.source)
    if not source.exists():
        return (
            None,
            None,
            RunFailure("untranslated", f"no {backend.source} for {script.name}"),
            False,
        )

    if cache is not None and backend_name in CACHEABLE_BACKENDS and not refresh:
        cached = cache.get(backend, source, timeout)
        if cached is not None:
            return cached.results, [], cached.failure, True

    times = []
    results = None
    for _ in range(repeat):
        try:
            results, seconds = run(backend, source, timeout)
        except RunFailure as failure:
            if cache is not None and backend_name in CACHEABLE_BACKENDS:
                cache.put_failure(backend, source, timeout, failure)
            return None, None, failure, False
        times.append(seconds)
    if cache is not None and backend_name in CACHEABLE_BACKENDS:
        cache.put_result(backend, source, timeout, results)
    return results, times, None, False


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(prog="fortsym-bench")
    sub = parser.add_subparsers(dest="command", required=True)

    runner = sub.add_parser("run", help="run the corpus")
    runner.add_argument("paths", nargs="*", type=Path, default=[CORPUS])
    runner.add_argument("--backend", nargs="+", default=list(DEFAULT_BACKENDS))
    runner.add_argument("--repeat", type=int, default=1)
    runner.add_argument(
        "--jobs",
        type=int,
        default=min(4, os.cpu_count() or 1),
        help="number of corpus scripts to evaluate concurrently (default: 4)",
    )
    runner.add_argument("--timeout", type=float, default=300.0)
    runner.add_argument("--report", type=Path)
    runner.add_argument(
        "--cache",
        type=Path,
        default=Path(".cache/reference-results.json"),
        help="reference-result cache (default: .cache/reference-results.json)",
    )
    runner.add_argument(
        "--no-cache",
        action="store_true",
        help="run SymPy and Mathics instead of reading or writing the cache",
    )
    runner.add_argument(
        "--refresh-reference",
        action="store_true",
        help="rerun reference backends and replace their cached entries",
    )
    runner.add_argument(
        "--refresh-cache",
        action="store_true",
        help="rerun all cacheable backends and replace their cached entries",
    )

    args = parser.parse_args(argv)
    scripts = discover(args.paths or [CORPUS])
    if not scripts:
        print("no corpus scripts found", file=sys.stderr)
        return 2
    if args.jobs < 1:
        parser.error("--jobs must be at least 1")

    cache = None
    if not args.no_cache:
        # Corpus workers update the cache in memory. Writing the complete JSON
        # document for every native result is needlessly expensive when a
        # result contains a large expanded expression; one atomic flush after
        # the pass keeps the cache durable without serialising that document
        # hundreds of times.
        cache = ReferenceCache(args.cache, autosave=False)
    report = {
        "cache": None if cache is None else str(args.cache),
        "scripts": {},
    }
    if args.jobs == 1:
        for script in scripts:
            report["scripts"][str(script)] = evaluate(script, args, cache)
    else:
        with ThreadPoolExecutor(max_workers=args.jobs) as pool:
            pending = [
                (script, pool.submit(evaluate, script, args, cache))
                for script in scripts
            ]
            for script, future in pending:
                report["scripts"][str(script)] = future.result()

    if cache is not None:
        cache.flush()

    if args.report:
        args.report.write_text(json.dumps(report, indent=1))
    return summarise(report)


def evaluate(script: Path, args, cache: ReferenceCache | None = None) -> dict:
    raw, timing, failures = {}, {}, {}
    parsed_cache = {}
    for name in args.backend:
        results, times, failure, cached = run_one(
            name,
            script,
            args.repeat,
            args.timeout,
            cache,
            refresh=args.refresh_cache or (
                args.refresh_reference and name in REFERENCE_BACKENDS
            ),
        )
        if failure is not None:
            failures[name] = {"outcome": failure.kind, "detail": str(failure)}
            continue
        raw[name] = results
        # Failures never enter the timing sample. A median over only the runs
        # that happened to succeed describes a different workload than the one
        # asked for, and reads as a performance claim it cannot support.
        timing[name] = {"cached": cached}
        if times:
            timing[name].update(
                {
                    "median": statistics.median(times),
                    "min": min(times),
                    "n": len(times),
                }
            )

    strictness = _strictness(raw)
    outcomes = {}
    for name, results in raw.items():
        backend = BACKENDS[name]
        oracle = "sympy" if backend.source == ".py" else "mathics"
        if name == oracle:
            continue
        outcomes[name] = _score(
            results, raw.get(oracle), backend, oracle, strictness, parsed_cache
        )

    return {
        "outcomes": outcomes,
        "failures": failures,
        "timing": timing,
        "oracles": _cross_check(raw, strictness),
    }


def _strictness(raw: dict) -> dict:
    for results in raw.values():
        if isinstance(results, dict) and "__compare__" in results:
            return results["__compare__"]
    return {}


def _score(
    results, oracle_results, backend, oracle_name, strictness, parsed_cache=None
) -> dict:
    if oracle_results is None:
        # Keyed like every other entry so the tally can walk one shape. A bare
        # dict here made summarise index a string and crash the whole run.
        return {
            "__oracle__": {
                "outcome": UNAVAILABLE,
                "detail": f"oracle {oracle_name} produced no results",
            }
        }
    scored = {}
    for key, text in results.items():
        if key == "__compare__":
            continue
        if key not in oracle_results:
            # The candidate can emit more bindings than a partial oracle. The
            # result is useful coverage, but it is not a scored comparison;
            # treating it as an error made the oracle ceiling look like wrong
            # answers and contradicted the overlap rule in the README.
            scored[key] = {
                "outcome": ORACLE_MISSING,
                "detail": "binding absent from oracle; not scored",
            }
            continue
        verdict = compare_text(
            text,
            oracle_results[key],
            backend.syntax,
            strictness.get(key, "structural"),
            parsed_cache,
        )
        scored[key] = {"outcome": verdict.outcome, "detail": verdict.detail}
    return scored


def _cross_check(raw: dict, strictness: dict) -> dict:
    """Where the two oracles disagree, nothing is scored against either."""
    sympy_results, mathics_results = raw.get("sympy"), raw.get("mathics")
    if not sympy_results or not mathics_results:
        return {}
    disagreements = {}
    for key in set(sympy_results) & set(mathics_results):
        if key == "__compare__":
            continue
        try:
            left = parse(sympy_results[key], "srepr")
            right = parse(mathics_results[key], "inputform")
        except Exception as exc:
            disagreements[key] = f"unparseable: {exc}"
            continue
        verdict = check_oracles(left, right, strictness.get(key, "structural"))
        if verdict is not None:
            disagreements[key] = verdict.detail
    return disagreements


def summarise(report: dict) -> int:
    """Tally outcomes, and report bindings as well as scripts.

    Script-level counts alone hide progress: a script that emits twenty
    bindings and refuses one is indistinguishable from one that emits one and
    refuses twenty. Implementing matrices moved 270 refusals and did not move
    the script count at all, because those refusals were inside scripts that
    already produced something.
    """
    tally = {AGREE: 0, DIFFER: 0, UNSUPPORTED: 0, UNTRANSLATED: 0,
             UNAVAILABLE: 0, TIMEOUT: 0, ERROR: 0, ORACLE_DISAGREEMENT: 0,
             ORACLE_MISSING: 0}
    for script in report["scripts"].values():
        for results in script["outcomes"].values():
            for entry in results.values():
                tally[entry["outcome"]] = tally.get(entry["outcome"], 0) + 1
        for entry in script["failures"].values():
            tally[entry["outcome"]] = tally.get(entry["outcome"], 0) + 1
        tally[ORACLE_DISAGREEMENT] += len(script["oracles"])

    bindings = sum(
        len(results)
        for script in report["scripts"].values()
        for results in script["outcomes"].values()
    )
    scripts = len(report["scripts"])
    produced = sum(
        1 for s in report["scripts"].values()
        if not s["failures"] or any(s["outcomes"].values())
    )

    for name, count in tally.items():
        print(f"{name:22s} {count}")
    print(f"{'scripts':22s} {produced}/{scripts}")
    print(f"{'bindings':22s} {bindings}")

    # Only a wrong answer is a failure. An honest refusal is the expected state
    # for most of this corpus today, and counting it as failure would create
    # pressure to guess instead.
    return 1 if tally[DIFFER] or tally[ERROR] else 0


if __name__ == "__main__":
    raise SystemExit(main())
