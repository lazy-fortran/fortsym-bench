from dataclasses import replace
import json
from pathlib import Path
import sys

import pytest

from fortsym_bench.backends import BACKENDS
from fortsym_bench.campaign import merge, run_case


def _case(tmp_path, monkeypatch):
    source = tmp_path / "fixture"
    source.with_suffix(".wl").write_text("x = 1;\n")
    source.with_suffix(".py").write_text("import sympy as s\ndef results(): return {'x': s.Integer(1)}\n")
    runner = tmp_path / "native.py"
    runner.write_text("print('R\\tx\\t1')\nprint('T\\t0.001')\n")
    monkeypatch.setitem(BACKENDS, "fortsym-wl", replace(
        BACKENDS["fortsym-wl"], command=(sys.executable, str(runner)),
    ))
    return source


def test_case_retains_outputs_and_scores_in_a_separate_process(tmp_path, monkeypatch):
    source = _case(tmp_path, monkeypatch)
    case = tmp_path / "run" / "case-0000"
    result = run_case(source, case, ["sympy", "fortsym-wl"], 5, 10, {"variant": "full"})
    assert result["outcomes"]["fortsym-wl"]["x"]["outcome"] == "agree"
    raw = json.loads((case / "raw.json").read_text())
    assert raw["raw"]["fortsym-wl"] == {"x": "1"}
    assert raw["raw"]["sympy"] == {"x": "Integer(1)"}
    identity = json.loads((case / "identity.json").read_text())
    assert identity["experiment"]["variant"] == "full"
    assert identity["runtime"]["backend_fingerprints"]["fortsym-wl"]
    combined = merge(case.parent, tmp_path / "report.json", expected_cases=1)
    assert combined["summary"]["outcomes"]["agree"] == 1
    assert Path(combined["cache"]).exists()


def test_comparison_timeout_preserves_raw_results_without_calling_them_wrong(tmp_path, monkeypatch):
    source = _case(tmp_path, monkeypatch)
    case = tmp_path / "case-0000"
    result = run_case(source, case, ["sympy", "fortsym-wl"], 5, 0.001, {})
    assert result["comparison_timeout"] is True
    assert result["outcomes"]["fortsym-wl"]["x"]["outcome"] == "timeout"
    assert json.loads((case / "raw.json").read_text())["raw"]["fortsym-wl"]["x"] == "1"
    assert not result["failures"]


def test_fixed_oracles_do_not_rerun_and_are_tied_to_source_hashes(tmp_path, monkeypatch):
    source = _case(tmp_path, monkeypatch)
    baseline = tmp_path / "full" / "case-0000"
    run_case(source, baseline, ["sympy", "fortsym-wl"], 5, 10, {})
    variant = tmp_path / "variant" / "case-0000"
    result = run_case(source, variant, ["sympy", "fortsym-wl"], 5, 10, {}, oracle_case=baseline)
    assert result["timing"]["sympy"] == {"cached": True, "fixed_reference": True}
    identity = json.loads((variant / "identity.json").read_text())
    assert identity["fixed_oracles"]["raw_sha256"]
    source.with_suffix(".wl").write_text("x = 2;\n")
    with pytest.raises(ValueError, match="source hashes"):
        run_case(source, tmp_path / "changed", ["sympy", "fortsym-wl"], 5, 10, {}, oracle_case=baseline)


def test_merge_refuses_incomplete_coverage(tmp_path, monkeypatch):
    source = _case(tmp_path, monkeypatch)
    case = tmp_path / "run" / "case-0000"
    run_case(source, case, ["sympy", "fortsym-wl"], 5, 10, {})
    with pytest.raises(ValueError, match="expected 2 cases"):
        merge(case.parent, tmp_path / "report.json", expected_cases=2)
    with pytest.raises(FileExistsError):
        run_case(source, case, ["sympy", "fortsym-wl"], 5, 10, {})


def test_fixed_oracle_preserves_original_execution_identity(tmp_path, monkeypatch):
    from fortsym_bench.cache import ReferenceCache

    source = _case(tmp_path, monkeypatch)
    baseline = tmp_path / "full" / "case-0000"
    run_case(source, baseline, ["sympy", "fortsym-wl"], 5, 10, {})
    original = json.loads((baseline / "raw-cache.json").read_text())["entries"]
    oracle = next(row for row in original.values() if row["backend"] == "sympy")
    monkeypatch.setattr(ReferenceCache, "_execution_fingerprint", lambda self, backend: "NEW_EXECUTABLE")
    variant = tmp_path / "variant" / "case-0000"
    run_case(source, variant, ["sympy", "fortsym-wl"], 8, 10, {}, oracle_case=baseline)
    retained = json.loads((variant / "raw-cache.json").read_text())["entries"]
    assert next(row for row in retained.values() if row["backend"] == "sympy") == oracle
    assert oracle["execution_fingerprint"] != "NEW_EXECUTABLE"
    assert oracle["timeout"] == 5


@pytest.mark.parametrize("backend", ["sympy", "fortsym-sympy"])
def test_empty_cache_is_written_when_all_backends_are_untranslated(tmp_path, monkeypatch, backend):
    source = _case(tmp_path, monkeypatch)
    source.with_suffix(".py").unlink()
    case = tmp_path / "run" / "case-0000"
    run_case(source, case, [backend], 5, 10, {})
    assert json.loads((case / "raw-cache.json").read_text())["entries"] == {}
    merge(case.parent, tmp_path / "report.json", expected_cases=1)


def test_frozen_inventory_rejects_changed_sources_and_mixed_runtime(tmp_path, monkeypatch):
    from fortsym_bench.campaign import inventory_for

    source = _case(tmp_path, monkeypatch)
    other = source.with_name("other")
    for suffix in (".wl", ".py"):
        other.with_suffix(suffix).write_bytes(source.with_suffix(suffix).read_bytes())
    inventory = inventory_for([source, other])
    root = tmp_path / "run"
    for index, script in enumerate((source, other)):
        run_case(script, root / f"case-{index:04d}", ["sympy", "fortsym-wl"],
                 5, 10, {}, inventory=inventory, case_index=index)
    merge(root, tmp_path / "report.json", inventory=inventory)
    path = root / "case-0001" / "identity.json"
    identity = json.loads(path.read_text())
    original = json.loads(path.read_text())
    identity["source_sha256"][str(other.with_suffix(".wl"))] = "CHANGED"
    path.write_text(json.dumps(identity))
    with pytest.raises(ValueError, match="frozen inventory"):
        merge(root, tmp_path / "changed.json", inventory=inventory)
    original["backend_timeout_seconds"] = 6
    path.write_text(json.dumps(original))
    with pytest.raises(ValueError, match="mixed runtime"):
        merge(root, tmp_path / "mixed.json", inventory=inventory)
    source.with_suffix(".wl").write_text("x = 7;\n")
    with pytest.raises(ValueError, match="frozen inventory"):
        run_case(source, tmp_path / "stale", ["sympy"], 5, 10, {},
                 inventory=inventory, case_index=0)



def test_merge_compares_fixed_oracle_identity_without_native_baseline_identity():
    from fortsym_bench.campaign import _configuration
    from copy import deepcopy

    runtime = {"execution_environment": {}, "backend_fingerprints": {
        "sympy": "ORACLE", "fortsym-wl": "NATIVE"},
        "backend_commands": {"sympy": [], "fortsym-wl": ["native"]},
        "packages": {"sympy": "1.14"}}
    identity = {"runtime": runtime, "backends": ["sympy", "fortsym-wl"],
                "backend_timeout_seconds": 5, "comparison_timeout_seconds": 10,
                "experiment": {}, "fixed_reference_runtime": deepcopy(runtime),
                "fixed_reference_backends": ["sympy"],
                "fixed_reference_timeout_seconds": 5}
    changed = deepcopy(identity)
    changed["fixed_reference_runtime"]["backend_fingerprints"]["fortsym-wl"] = "OTHER_NATIVE"
    assert _configuration(changed) == _configuration(identity)
    changed["fixed_reference_runtime"]["backend_fingerprints"]["sympy"] = "OTHER_ORACLE"
    assert _configuration(changed) != _configuration(identity)
    changed = deepcopy(identity)
    changed["fixed_reference_timeout_seconds"] = 8
    assert _configuration(changed) != _configuration(identity)



def test_comparison_cancellation_reaps_the_process(tmp_path, monkeypatch):
    import os
    import signal
    import subprocess
    from fortsym_bench.campaign import bounded_score

    original_popen = subprocess.Popen
    children = []

    def interrupted_process(argv, **kwargs):
        process = original_popen([sys.executable, "-c", "import time; time.sleep(30)"], **kwargs)
        children.append(process)
        original_wait = process.wait
        interrupted = False

        def wait(*args, **options):
            nonlocal interrupted
            if not interrupted:
                interrupted = True
                raise KeyboardInterrupt
            return original_wait(*args, **options)

        process.wait = wait
        return process

    monkeypatch.setattr(subprocess, "Popen", interrupted_process)
    try:
        with pytest.raises(KeyboardInterrupt):
            bounded_score(tmp_path / "raw.json", tmp_path / "report.json", 10)
        assert children[0].poll() is not None
    finally:
        for process in children:
            if process.poll() is None:
                os.killpg(process.pid, signal.SIGKILL)
                process.wait()



@pytest.mark.parametrize("alias", ["inside", "hardlink", "cache-symlink"])
def test_merge_cannot_overwrite_retained_case_artifacts(tmp_path, monkeypatch, alias):
    import os

    source = _case(tmp_path, monkeypatch)
    case = tmp_path / "run" / "case-0000"
    run_case(source, case, ["sympy", "fortsym-wl"], 5, 10, {})
    original = {path: path.read_bytes() for path in case.iterdir() if path.is_file()}
    output = tmp_path / "merged.json"
    if alias == "inside":
        output = case / "report.json"
    elif alias == "hardlink":
        os.link(case / "report.json", output)
    else:
        output.with_name("merged.raw-cache.json").symlink_to(case / "raw.json")
    with pytest.raises(ValueError, match="retained case"):
        merge(case.parent, output, expected_cases=1)
    assert all(path.read_bytes() == content for path, content in original.items())



def test_merge_cli_cannot_replace_the_frozen_inventory(tmp_path):
    from fortsym_bench.campaign import main

    inventory = tmp_path / "inventory.json"
    inventory.write_text('{"cases": []}\n')
    original = inventory.read_bytes()
    with pytest.raises(SystemExit) as stopped:
        main(["merge", str(tmp_path / "run"), "--inventory", str(inventory),
              "--out", str(inventory)])
    assert stopped.value.code == 2
    assert inventory.read_bytes() == original
