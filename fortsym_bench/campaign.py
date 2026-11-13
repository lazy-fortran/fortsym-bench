"""Retain raw corpus results before scoring them with a wall-time limit."""

from __future__ import annotations

import argparse
import hashlib
import importlib.metadata
import json
import os
from pathlib import Path
import platform
import signal
import statistics
import subprocess
import sys
import time

from .backends import BACKENDS, DEFAULT_BACKENDS, _signal_group, _stop_group
from .cache import ReferenceCache
from .cli import CACHEABLE_BACKENDS, build_summary, discover, run_one, score_raw


def _write(path: Path, value: dict) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    temporary = path.with_suffix(path.suffix + ".tmp")
    temporary.write_text(json.dumps(value, indent=1) + "\n")
    temporary.replace(path)


def _digest(value: dict) -> str:
    return hashlib.sha256(json.dumps(value, sort_keys=True).encode()).hexdigest()


def inventory_for(scripts: list[Path]) -> dict:
    return {"cases": [
        {"index": index, "script": str(script),
         "source_sha256": source_identity(script)}
        for index, script in enumerate(scripts)
    ]}


def source_identity(script: Path) -> dict:
    return {
        str(path): hashlib.sha256(path.read_bytes()).hexdigest()
        for suffix in (".wl", ".py")
        if (path := script.with_suffix(suffix)).exists()
    }


def _git(path: Path, *args: str) -> str | None:
    result = subprocess.run(
        ["git", "-C", str(path), *args], capture_output=True, text=True,
        check=False,
    )
    return result.stdout.strip() if result.returncode == 0 else None


def runtime_metadata(backends: list[str], cache: ReferenceCache) -> dict:
    versions = {}
    for package in ("sympy", "mathics3", "fortsym-bench"):
        try:
            versions[package] = importlib.metadata.version(package)
        except importlib.metadata.PackageNotFoundError:
            versions[package] = None
    diff = _git(Path.cwd(), "diff", "HEAD", "--")
    return {
        "python": platform.python_version(),
        "platform": platform.platform(),
        "packages": versions,
        "harness_revision": _git(Path.cwd(), "rev-parse", "HEAD"),
        "harness_diff_sha256": hashlib.sha256((diff or "").encode()).hexdigest(),
        "backend_fingerprints": {
            name: cache._execution_fingerprint(BACKENDS[name])
            for name in backends
        },
        "backend_commands": {name: BACKENDS[name].command for name in backends},
        "execution_environment": {
            key: value for key, value in sorted(os.environ.items())
            if key.startswith("FORTSYM_") or key in (
                "OMP_NUM_THREADS", "OPENBLAS_NUM_THREADS", "MKL_NUM_THREADS",
            )
        },
    }


def bounded_score(raw_path: Path, output: Path, timeout: float) -> bool:
    """Return False on a scoring timeout while preserving the raw artifact."""
    if timeout <= 0:
        raise ValueError("comparison timeout must be positive")
    with output.with_suffix(".log").open("w") as log:
        process = subprocess.Popen(
            [sys.executable, "-m", "fortsym_bench.campaign", "_score",
             str(raw_path), str(output)],
            stdout=log, stderr=subprocess.STDOUT, start_new_session=True,
        )
        try:
            status = process.wait(timeout=timeout)
        except subprocess.TimeoutExpired:
            _stop_group(process)
            return False
        except BaseException:
            _stop_group(process)
            raise
        finally:
            _signal_group(process, signal.SIGKILL)
    if status != 0:
        raise RuntimeError(f"comparison failed with exit {status}; see {log.name}")
    return True


def run_case(
    script: Path,
    output: Path,
    backends: list[str],
    timeout: float,
    comparison_timeout: float,
    metadata: dict,
    *,
    oracle_case: Path | None = None,
    inventory: dict | None = None,
    case_index: int | None = None,
) -> dict:
    """Execute a case once; an existing output directory is never overwritten."""
    output.mkdir(parents=True, exist_ok=False)
    cache = ReferenceCache(output / "raw-cache.json", autosave=False)
    identity = source_identity(script)
    execution = {
        "schema_version": 1,
        "script": str(script),
        "source_sha256": identity,
        "backend_timeout_seconds": timeout,
        "comparison_timeout_seconds": comparison_timeout,
        "backends": backends,
        "runtime": runtime_metadata(backends, cache),
        "experiment": metadata,
    }
    if inventory is not None:
        if case_index is None or inventory["cases"][case_index] != {
            "index": case_index, "script": str(script), "source_sha256": identity,
        }:
            raise ValueError("case does not match the frozen inventory")
        execution["inventory_sha256"] = _digest(inventory)
        execution["case_index"] = case_index
    _write(output / "identity.json", execution)
    raw, timing, failures = {}, {}, {}
    baseline = None
    retained_entries = {}
    if oracle_case is not None:
        baseline_identity = json.loads((oracle_case / "identity.json").read_text())
        if baseline_identity["source_sha256"] != identity:
            raise ValueError("fixed oracle source hashes do not match")
        baseline = json.loads((oracle_case / "raw.json").read_text())
        baseline_entries = json.loads((oracle_case / "raw-cache.json").read_text())["entries"]
        execution["fixed_reference_runtime"] = baseline_identity["runtime"]
        execution["fixed_reference_timeout_seconds"] = baseline_identity["backend_timeout_seconds"]
        execution["fixed_reference_backends"] = [
            name for name in backends if name in ("sympy", "mathics")
        ]
        execution["fixed_oracles"] = {
            "case": str(oracle_case),
            "identity_sha256": hashlib.sha256((oracle_case / "identity.json").read_bytes()).hexdigest(),
            "raw_sha256": hashlib.sha256((oracle_case / "raw.json").read_bytes()).hexdigest(),
        }
        _write(output / "identity.json", execution)
    wall_start = time.monotonic()
    for name in backends:
        if baseline is not None and name in ("sympy", "mathics"):
            if name in baseline["raw"]:
                results = baseline["raw"][name]
                raw[name] = results
                timing[name] = {"cached": True, "fixed_reference": True}
            elif name in baseline["failures"]:
                failures[name] = baseline["failures"][name]
            else:
                raise ValueError(f"fixed oracle {name} has no retained outcome")
            source = script.with_suffix(BACKENDS[name].source)
            retained_entries.update({
                key: entry for key, entry in baseline_entries.items()
                if entry.get("backend") == name
                and entry.get("source") == ReferenceCache._display_source(source)
                and entry.get("source_sha256") == identity.get(str(source))
            })
            continue
        results, times, failure, _ = run_one(
            name, script, 1, timeout, cache, refresh=True,
        )
        if failure is not None:
            failures[name] = {"outcome": failure.kind, "detail": str(failure)}
            if name not in CACHEABLE_BACKENDS and script.with_suffix(BACKENDS[name].source).exists():
                cache.put_failure(BACKENDS[name], script.with_suffix(BACKENDS[name].source), timeout, failure)
        else:
            raw[name] = results
            if name not in CACHEABLE_BACKENDS:
                cache.put_result(BACKENDS[name], script.with_suffix(BACKENDS[name].source), timeout, results)
            timing[name] = {
                "cached": False, "median": statistics.median(times),
                "min": min(times), "n": len(times),
            }
        cache.flush()
        _write(output / "raw.json", {"raw": raw, "timing": timing, "failures": failures})
    payload = {"raw": raw, "timing": timing, "failures": failures}
    _write(output / "raw.json", payload)
    cache.flush()
    cache_payload = (
        json.loads(cache.path.read_text()) if cache.path.exists()
        else {"version": 1, "entries": {}}
    )
    cache_payload["entries"].update(retained_entries)
    _write(cache.path, cache_payload)
    comparison_error = None
    try:
        scored = bounded_score(output / "raw.json", output / "report.json", comparison_timeout)
    except RuntimeError as error:
        scored, comparison_error = False, str(error)
    if scored:
        report = json.loads((output / "report.json").read_text())
    else:
        outcome = "error" if comparison_error else "timeout"
        detail = comparison_error or "comparison wall-time limit; raw output retained"
        report = {
            "outcomes": {
                name: {
                    key: {"outcome": outcome, "detail": detail}
                    for key in results if key != "__compare__"
                }
                for name, results in raw.items() if not BACKENDS[name].is_oracle
            },
            "failures": failures, "timing": timing, "oracles": {},
        }
        report["comparison_timeout"] = comparison_error is None
        if comparison_error:
            report["comparison_error"] = comparison_error
    report["wall_seconds"] = time.monotonic() - wall_start
    _write(output / "report.json", report)
    return report


def _configuration(identity: dict) -> dict:
    runtime = dict(identity["runtime"])
    runtime["execution_environment"] = {
        key: value for key, value in runtime["execution_environment"].items()
        if key != "FORTSYM_TRACE_DELEGATES"
    }
    configuration = {key: identity[key] for key in (
        "backends", "backend_timeout_seconds", "comparison_timeout_seconds", "experiment",
    )} | {"runtime": runtime}
    if "fixed_reference_runtime" in identity:
        references = identity["fixed_reference_backends"]
        original = dict(identity["fixed_reference_runtime"])
        for key in ("backend_fingerprints", "backend_commands"):
            original[key] = {name: original[key][name] for name in references}
        original["execution_environment"] = {
            key: value for key, value in original["execution_environment"].items()
            if key != "FORTSYM_TRACE_DELEGATES"
        }
        configuration["fixed_reference"] = {
            "backends": references, "runtime": original,
            "timeout": identity["fixed_reference_timeout_seconds"],
        }
    return configuration


def merge(
    root: Path, output: Path, expected_cases: int | None = None,
    *, inventory: dict | None = None,
) -> dict:
    scripts, entries, provenance = {}, {}, {}
    configuration = None
    cases = sorted(root.glob("case-*"))
    if inventory is not None:
        if expected_cases is not None and expected_cases != len(inventory["cases"]):
            raise ValueError("expected count differs from the frozen inventory")
        expected_cases = len(inventory["cases"])
    if expected_cases is not None and len(cases) != expected_cases:
        raise ValueError(f"expected {expected_cases} cases, found {len(cases)}")
    for index, case in enumerate(cases):
        if case.name != f"case-{index:04d}":
            raise ValueError("corpus case indices must be contiguous from zero")
        identity = json.loads((case / "identity.json").read_text())
        current_configuration = _configuration(identity)
        if configuration is not None and current_configuration != configuration:
            raise ValueError("mixed runtime or experiment configurations")
        configuration = current_configuration
        if inventory is not None:
            expected = inventory["cases"][index]
            actual = {"index": identity.get("case_index"),
                      "script": identity["script"],
                      "source_sha256": identity["source_sha256"]}
            if (identity.get("inventory_sha256") != _digest(inventory)
                    or actual != expected):
                raise ValueError("case does not match the frozen inventory")
        script = identity["script"]
        if script in scripts:
            raise ValueError(f"duplicate corpus case: {script}")
        scripts[script] = json.loads((case / "report.json").read_text())
        for key, entry in json.loads((case / "raw-cache.json").read_text())["entries"].items():
            if key in entries and entries[key] != entry:
                raise ValueError("conflicting raw cache identities")
            entries[key] = entry
        provenance[script] = identity
    if not scripts:
        raise ValueError("no completed corpus cases")
    if expected_cases is not None and len(scripts) != expected_cases:
        raise ValueError(f"expected {expected_cases} cases, found {len(scripts)}")
    cache_path = output.with_name(output.stem + ".raw-cache.json")
    _write(cache_path, {"version": 1, "entries": entries})
    report = {"cache": str(cache_path), "scripts": scripts, "provenance": provenance}
    report["summary"] = build_summary(report)
    _write(output, report)
    return report


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    sub = parser.add_subparsers(dest="command", required=True)
    list_parser = sub.add_parser("list")
    list_parser.add_argument("paths", nargs="*", type=Path, default=[Path("corpus")])
    list_parser.add_argument("--out", type=Path)
    run_parser = sub.add_parser("run")
    run_parser.add_argument("paths", nargs="*", type=Path, default=[Path("corpus")])
    run_parser.add_argument("--out", required=True, type=Path)
    run_parser.add_argument("--case-index", required=True, type=int)
    run_parser.add_argument("--backend", nargs="+", choices=sorted(BACKENDS), default=list(DEFAULT_BACKENDS))
    run_parser.add_argument("--timeout", type=float, default=60)
    run_parser.add_argument("--comparison-timeout", type=float, default=60)
    run_parser.add_argument("--metadata", type=Path)
    run_parser.add_argument("--oracle-root", type=Path)
    run_parser.add_argument("--inventory", required=True, type=Path)
    score_parser = sub.add_parser("_score", help=argparse.SUPPRESS)
    score_parser.add_argument("raw", type=Path)
    score_parser.add_argument("out", type=Path)
    merge_parser = sub.add_parser("merge")
    merge_parser.add_argument("root", type=Path)
    merge_parser.add_argument("--out", required=True, type=Path)
    merge_parser.add_argument("--expected-cases", type=int)
    merge_parser.add_argument("--inventory", required=True, type=Path)
    args = parser.parse_args(argv)
    if args.command == "list":
        inventory = inventory_for(discover(args.paths))
        if args.out:
            _write(args.out, inventory)
        else:
            print(json.dumps(inventory, indent=1))
        return 0
    if args.command == "_score":
        payload = json.loads(args.raw.read_text())
        _write(args.out, score_raw(payload["raw"], payload["timing"], payload["failures"]))
        return 0
    if args.command == "merge":
        merge(args.root, args.out, args.expected_cases,
              inventory=json.loads(args.inventory.read_text()))
        return 0
    scripts = discover(args.paths)
    if not 0 <= args.case_index < len(scripts):
        parser.error(f"case index must be between 0 and {len(scripts) - 1}")
    if args.timeout <= 0 or args.comparison_timeout <= 0:
        parser.error("timeouts must be positive")
    name = f"case-{args.case_index:04d}"
    metadata = json.loads(args.metadata.read_text()) if args.metadata else {}
    run_case(scripts[args.case_index], args.out / name, args.backend,
             args.timeout, args.comparison_timeout, metadata,
             oracle_case=args.oracle_root / name if args.oracle_root else None,
             inventory=json.loads(args.inventory.read_text()), case_index=args.case_index)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
