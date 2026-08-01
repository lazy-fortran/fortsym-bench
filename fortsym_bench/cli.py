"""Corpus runner: run every script under every backend, compare, and time."""

from __future__ import annotations

import argparse
import json
import statistics
import sys
from pathlib import Path

from .backends import BACKENDS, DEFAULT_BACKENDS, RunFailure, run
from .compare import (
    AGREE,
    DIFFER,
    ERROR,
    ORACLE_DISAGREEMENT,
    TIMEOUT,
    UNAVAILABLE,
    UNSUPPORTED,
    UNTRANSLATED,
    check_oracles,
    compare,
    parse,
)

CORPUS = Path("corpus")


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


def run_one(backend_name: str, script: Path, repeat: int, timeout: float):
    backend = BACKENDS[backend_name]
    source = script.with_suffix(backend.source)
    if not source.exists():
        return None, None, RunFailure("untranslated", f"no {backend.source} for {script.name}")

    times = []
    results = None
    for _ in range(repeat):
        try:
            results, seconds = run(backend, source, timeout)
        except RunFailure as failure:
            return None, None, failure
        times.append(seconds)
    return results, times, None


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(prog="fortsym-bench")
    sub = parser.add_subparsers(dest="command", required=True)

    runner = sub.add_parser("run", help="run the corpus")
    runner.add_argument("paths", nargs="*", type=Path, default=[CORPUS])
    runner.add_argument("--backend", nargs="+", default=list(DEFAULT_BACKENDS))
    runner.add_argument("--repeat", type=int, default=1)
    runner.add_argument("--timeout", type=float, default=300.0)
    runner.add_argument("--report", type=Path)

    args = parser.parse_args(argv)
    scripts = discover(args.paths or [CORPUS])
    if not scripts:
        print("no corpus scripts found", file=sys.stderr)
        return 2

    report = {"scripts": {}}
    for script in scripts:
        report["scripts"][str(script)] = evaluate(script, args)

    if args.report:
        args.report.write_text(json.dumps(report, indent=1))
    return summarise(report)


def evaluate(script: Path, args) -> dict:
    raw, timing, failures = {}, {}, {}
    for name in args.backend:
        results, times, failure = run_one(name, script, args.repeat, args.timeout)
        if failure is not None:
            failures[name] = {"outcome": failure.kind, "detail": str(failure)}
            continue
        raw[name] = results
        # Failures never enter the timing sample. A median over only the runs
        # that happened to succeed describes a different workload than the one
        # asked for, and reads as a performance claim it cannot support.
        timing[name] = {
            "median": statistics.median(times),
            "min": min(times),
            "n": len(times),
        }

    strictness = _strictness(raw)
    outcomes = {}
    for name, results in raw.items():
        backend = BACKENDS[name]
        oracle = "sympy" if backend.source == ".py" else "mathics"
        if name == oracle:
            continue
        outcomes[name] = _score(results, raw.get(oracle), backend, oracle, strictness)

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


def _score(results, oracle_results, backend, oracle_name, strictness) -> dict:
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
        if key not in oracle_results:
            scored[key] = {"outcome": ERROR, "detail": "absent from oracle"}
            continue
        try:
            candidate = parse(text, backend.syntax)
            reference = parse(oracle_results[key], BACKENDS[oracle_name].syntax)
        except Exception as exc:
            scored[key] = {"outcome": ERROR, "detail": f"unparseable: {exc}"}
            continue
        verdict = compare(candidate, reference, strictness.get(key, "structural"))
        scored[key] = {"outcome": verdict.outcome, "detail": verdict.detail}
    return scored


def _cross_check(raw: dict, strictness: dict) -> dict:
    """Where the two oracles disagree, nothing is scored against either."""
    sympy_results, mathics_results = raw.get("sympy"), raw.get("mathics")
    if not sympy_results or not mathics_results:
        return {}
    disagreements = {}
    for key in set(sympy_results) & set(mathics_results):
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
    tally = {AGREE: 0, DIFFER: 0, UNSUPPORTED: 0, UNTRANSLATED: 0,
             UNAVAILABLE: 0, TIMEOUT: 0, ERROR: 0, ORACLE_DISAGREEMENT: 0}
    for script in report["scripts"].values():
        for results in script["outcomes"].values():
            for entry in results.values():
                tally[entry["outcome"]] = tally.get(entry["outcome"], 0) + 1
        for entry in script["failures"].values():
            tally[entry["outcome"]] = tally.get(entry["outcome"], 0) + 1
        tally[ORACLE_DISAGREEMENT] += len(script["oracles"])

    for name, count in tally.items():
        print(f"{name:22s} {count}")

    # Only a wrong answer is a failure. An honest refusal is the expected state
    # for most of this corpus today, and counting it as failure would create
    # pressure to guess instead.
    return 1 if tally[DIFFER] or tally[ERROR] else 0


if __name__ == "__main__":
    raise SystemExit(main())
