from __future__ import annotations

import json
from pathlib import Path

from fortsym_bench.backends import (
    BACKENDS,
    Backend,
    RunFailure,
    _parse_wolfram_output,
)
from fortsym_bench.cache import ComparisonCache, ReferenceCache
from fortsym_bench.cli import run_one


def test_sympy_reference_is_reused_after_the_source_run(tmp_path, monkeypatch):
    source = tmp_path / "case.py"
    source.write_text(
        "import sympy as sp\n"
        "def results():\n"
        "    return {'answer': sp.Integer(2) + sp.Integer(2)}\n"
    )
    cache = ReferenceCache(tmp_path / "reference.json")
    stem = source.with_suffix("")

    first, first_times, first_failure, first_cached = run_one(
        "sympy", stem, 1, 5.0, cache
    )

    assert first_failure is None
    assert first_cached is False
    assert first_times
    assert first["answer"] == "Integer(4)"

    def must_not_run(*args, **kwargs):
        raise AssertionError("the cached reference was executed again")

    monkeypatch.setattr("fortsym_bench.cli.run", must_not_run)
    second, second_times, second_failure, second_cached = run_one(
        "sympy", stem, 1, 300.0, cache
    )

    assert second_failure is None
    assert second_cached is True
    assert second_times == []
    assert second == first


def test_mathics_failure_is_reused_at_the_same_timeout(tmp_path, monkeypatch):
    source = tmp_path / "case.wl"
    source.write_text("answer = 2\n")
    cache = ReferenceCache(tmp_path / "reference.json")
    failure = RunFailure("error", "mathics could not evaluate case")

    def fail(*args, **kwargs):
        raise failure

    monkeypatch.setattr("fortsym_bench.cli.run", fail)
    first, first_times, first_failure, first_cached = run_one(
        "mathics", source.with_suffix(""), 1, 5.0, cache
    )

    assert first is None
    assert first_times is None
    assert first_failure is not None
    assert first_failure.kind == "error"
    assert first_cached is False

    def must_not_run(*args, **kwargs):
        raise AssertionError("the cached Mathics failure was executed again")

    monkeypatch.setattr("fortsym_bench.cli.run", must_not_run)
    second, second_times, second_failure, second_cached = run_one(
        "mathics", source.with_suffix(""), 1, 5.0, cache
    )

    assert second is None
    assert second_times == []
    assert second_failure is not None
    assert second_failure.kind == "error"
    assert second_cached is True


def test_source_changes_invalidate_the_reference_entry(tmp_path):
    source = Path(tmp_path / "case.py")
    source.write_text(
        "import sympy as sp\n"
        "def results():\n"
        "    return {'answer': sp.Integer(2)}\n"
    )
    cache = ReferenceCache(tmp_path / "reference.json")
    stem = source.with_suffix("")
    first, _, _, _ = run_one("sympy", stem, 1, 5.0, cache)

    source.write_text(
        "import sympy as sp\n"
        "def results():\n"
        "    return {'answer': sp.Integer(30)}\n"
    )
    second, _, _, cached = run_one("sympy", stem, 1, 5.0, cache)

    assert cached is False
    assert first["answer"] == "Integer(2)"
    assert second["answer"] == "Integer(30)"


def test_reference_runner_version_invalidates_old_results(tmp_path):
    source = tmp_path / "case.wl"
    source.write_text("answer = 2\n")
    cache = ReferenceCache(tmp_path / "reference.json")
    old = Backend("mathics", ".wl", "inputform", cache_version=1)
    current = Backend("mathics", ".wl", "inputform", cache_version=4)

    cache.put_result(old, source, 5.0, {"answer": "2"})

    assert cache.get(old, source, 5.0) is not None
    assert cache.get(current, source, 5.0) is not None

    cache.put_failure(
        old, source, 5.0, RunFailure("error", "no results parsed from: T\\t0.1")
    )
    assert cache.get(current, source, 5.0) is None


def test_sympy_cache_upgrade_reuses_sources_unaffected_by_lambda_fix(tmp_path):
    source = tmp_path / "case.py"
    source.write_text("value = x + 1\n")
    cache = ReferenceCache(tmp_path / "reference.json")
    old = Backend("sympy", ".py", "srepr", cache_version=9)
    current = Backend("sympy", ".py", "srepr", cache_version=10)

    cache.put_result(old, source, 5.0, {"value": "Add(Symbol('x'), Integer(1))"})

    cached = cache.get(current, source, 300.0)

    assert cached is not None
    assert cached.results == {"value": "Add(Symbol('x'), Integer(1))"}


def test_sympy_cache_upgrade_reruns_sources_containing_lambda(tmp_path):
    source = tmp_path / "case.py"
    source.write_text("value = f[λ]\n")
    cache = ReferenceCache(tmp_path / "reference.json")
    old = Backend("sympy", ".py", "srepr", cache_version=9)
    current = Backend("sympy", ".py", "srepr", cache_version=10)

    cache.put_result(old, source, 5.0, {"value": "Function('f')(Symbol('λ'))"})

    assert cache.get(current, source, 300.0) is None


def test_mathics_curl_compatibility_reruns_only_old_curl_crashes(tmp_path):
    source = tmp_path / "case.wl"
    source.write_text("answer = Curl[a]\n")
    cache = ReferenceCache(tmp_path / "reference.json")
    old = Backend("mathics", ".wl", "inputform", cache_version=4)
    current = Backend("mathics", ".wl", "inputform", cache_version=5)

    cache.put_failure(
        old,
        source,
        5.0,
        RunFailure("error", "AttributeError: module 'sympy' has no attribute 'curl'"),
    )

    assert cache.get(current, source, 5.0) is None


def test_mathics_curl_compatibility_reuses_unrelated_failures(tmp_path):
    source = tmp_path / "case.wl"
    source.write_text("answer = 1\n")
    cache = ReferenceCache(tmp_path / "reference.json")
    old = Backend("mathics", ".wl", "inputform", cache_version=4)
    current = Backend("mathics", ".wl", "inputform", cache_version=5)

    cache.put_failure(old, source, 5.0, RunFailure("timeout", "exceeded 5s"))

    assert cache.get(current, source, 5.0) is not None


def test_mathics_cylindrical_curl_upgrade_reruns_old_results(tmp_path):
    source = tmp_path / "case.wl"
    source.write_text(
        'answer = Curl[{r^2, r*z, r*theta}, {r, theta, z}, "Cylindrical"]\n'
    )
    cache = ReferenceCache(tmp_path / "reference.json")
    old = Backend("mathics", ".wl", "inputform", cache_version=5)
    current = Backend("mathics", ".wl", "inputform", cache_version=6)

    cache.put_result(old, source, 5.0, {"answer": "Curl[...]"})

    assert cache.get(current, source, 5.0) is None


def test_mathics_cylindrical_curl_upgrade_reuses_unrelated_results(tmp_path):
    source = tmp_path / "case.wl"
    source.write_text("answer = 1\n")
    cache = ReferenceCache(tmp_path / "reference.json")
    old = Backend("mathics", ".wl", "inputform", cache_version=5)
    current = Backend("mathics", ".wl", "inputform", cache_version=6)

    cache.put_result(old, source, 5.0, {"answer": "1"})

    cached = cache.get(current, source, 5.0)

    assert cached is not None
    assert cached.results == {"answer": "1"}


def test_native_runner_version_invalidates_old_results(tmp_path):
    source = tmp_path / "case.wl"
    source.write_text("answer = 2\n")
    cache = ReferenceCache(tmp_path / "reference.json")
    old = Backend("fortsym-wl", ".wl", "inputform", cache_version=1)
    current = Backend("fortsym-wl", ".wl", "inputform", cache_version=2)

    cache.put_result(old, source, 5.0, {"answer": "2"})

    assert cache.get(current, source, 5.0) is None


def test_sympy_cache_upgrade_reuses_sources_without_polynomial_heads(tmp_path):
    source = tmp_path / "case.py"
    source.write_text("value = x + 1\n")
    cache = ReferenceCache(tmp_path / "reference.json")
    old = Backend("sympy", ".py", "srepr", cache_version=10)
    current = Backend("sympy", ".py", "srepr", cache_version=11)

    cache.put_result(old, source, 5.0, {"value": "Add(Symbol('x'), Integer(1))"})

    cached = cache.get(current, source, 300.0)

    assert cached is not None
    assert cached.results == {"value": "Add(Symbol('x'), Integer(1))"}


def test_sympy_cache_upgrade_reruns_sources_with_coefficient(tmp_path):
    source = tmp_path / "case.py"
    source.write_text("value = Coefficient[x^2, x, 1]\n")
    cache = ReferenceCache(tmp_path / "reference.json")
    old = Backend("sympy", ".py", "srepr", cache_version=10)
    current = Backend("sympy", ".py", "srepr", cache_version=11)

    cache.put_result(old, source, 5.0, {"value": "Integer(0)"})

    assert cache.get(current, source, 300.0) is None


def test_sympy_cache_upgrade_reruns_sources_with_user_cc_symbol(tmp_path):
    source = tmp_path / "case.py"
    source.write_text("value = CC + 1\n")
    cache = ReferenceCache(tmp_path / "reference.json")
    old = Backend("sympy", ".py", "srepr", cache_version=24)
    current = Backend("sympy", ".py", "srepr", cache_version=25)

    cache.put_result(old, source, 5.0, {"value": "Add(CC, Integer(1))"})

    assert cache.get(current, source, 300.0) is None


def test_sympy_cache_upgrade_reuses_sources_without_user_cc_symbol(tmp_path):
    source = tmp_path / "case.py"
    source.write_text("value = x + 1\n")
    cache = ReferenceCache(tmp_path / "reference.json")
    old = Backend("sympy", ".py", "srepr", cache_version=24)
    current = Backend("sympy", ".py", "srepr", cache_version=25)

    cache.put_result(old, source, 5.0, {"value": "Add(Symbol('x'), Integer(1))"})

    cached = cache.get(current, source, 300.0)

    assert cached is not None
    assert cached.results == {"value": "Add(Symbol('x'), Integer(1))"}


def test_sympy_cache_upgrade_reruns_sources_with_do_or_with(tmp_path):
    source = tmp_path / "case.py"
    source.write_text("value = Do[x = x + 1, {x, 1, 2}]\n")
    cache = ReferenceCache(tmp_path / "reference.json")
    old = Backend("sympy", ".py", "srepr", cache_version=25)
    current = Backend("sympy", ".py", "srepr", cache_version=26)

    cache.put_result(old, source, 5.0, {"value": "Symbol('Null')"})

    assert cache.get(current, source, 300.0) is None


def test_sympy_cache_upgrade_reuses_sources_without_do_or_with(tmp_path):
    source = tmp_path / "case.py"
    source.write_text("value = x + 1\n")
    cache = ReferenceCache(tmp_path / "reference.json")
    old = Backend("sympy", ".py", "srepr", cache_version=25)
    current = Backend("sympy", ".py", "srepr", cache_version=26)

    cache.put_result(old, source, 5.0, {"value": "Add(Symbol('x'), Integer(1))"})

    cached = cache.get(current, source, 300.0)

    assert cached is not None
    assert cached.results == {"value": "Add(Symbol('x'), Integer(1))"}


def test_sympy_cache_upgrade_reruns_sources_with_curl(tmp_path):
    source = tmp_path / "case.py"
    source.write_text('value = Curl[{r, theta, z}, {r, theta, z}, "Cylindrical"]\n')
    cache = ReferenceCache(tmp_path / "reference.json")
    old = Backend("sympy", ".py", "srepr", cache_version=26)
    current = Backend("sympy", ".py", "srepr", cache_version=27)

    cache.put_result(old, source, 5.0, {"value": "Function('Curl')()"})

    assert cache.get(current, source, 300.0) is None


def test_sympy_cache_upgrade_reuses_sources_without_curl(tmp_path):
    source = tmp_path / "case.py"
    source.write_text("value = x + 1\n")
    cache = ReferenceCache(tmp_path / "reference.json")
    old = Backend("sympy", ".py", "srepr", cache_version=26)
    current = Backend("sympy", ".py", "srepr", cache_version=27)

    cache.put_result(old, source, 5.0, {"value": "Add(Symbol('x'), Integer(1))"})

    cached = cache.get(current, source, 300.0)

    assert cached is not None
    assert cached.results == {"value": "Add(Symbol('x'), Integer(1))"}


def test_sympy_cache_upgrade_reuses_sources_without_solve(tmp_path):
    source = tmp_path / "case.py"
    source.write_text("value = x + 1\n")
    cache = ReferenceCache(tmp_path / "reference.json")
    old = Backend("sympy", ".py", "srepr", cache_version=10)
    current = Backend("sympy", ".py", "srepr", cache_version=13)

    cache.put_result(old, source, 5.0, {"value": "Add(Symbol('x'), Integer(1))"})

    cached = cache.get(current, source, 300.0)

    assert cached is not None
    assert cached.results == {"value": "Add(Symbol('x'), Integer(1))"}


def test_sympy_cache_upgrade_reruns_sources_with_solve(tmp_path):
    source = tmp_path / "case.py"
    source.write_text("value = Solve[x + a == 0, x]\n")
    cache = ReferenceCache(tmp_path / "reference.json")
    old = Backend("sympy", ".py", "srepr", cache_version=11)
    current = Backend("sympy", ".py", "srepr", cache_version=13)

    cache.put_result(old, source, 5.0, {"value": "Tuple(Mul(-1, Symbol('a')))"})

    assert cache.get(current, source, 300.0) is None


def test_sympy_cache_upgrade_reuses_sources_without_fold_list(tmp_path):
    source = tmp_path / "case.py"
    source.write_text("value = x + 1\n")
    cache = ReferenceCache(tmp_path / "reference.json")
    old = Backend("sympy", ".py", "srepr", cache_version=10)
    current = Backend("sympy", ".py", "srepr", cache_version=14)

    cache.put_result(old, source, 5.0, {"value": "Add(Symbol('x'), Integer(1))"})

    cached = cache.get(current, source, 300.0)

    assert cached is not None


def test_sympy_cache_upgrade_reuses_version_13_solve_rows(tmp_path):
    source = tmp_path / "case.py"
    source.write_text("value = Solve[x + a == 0, x]\n")
    cache = ReferenceCache(tmp_path / "reference.json")
    old = Backend("sympy", ".py", "srepr", cache_version=13)
    current = Backend("sympy", ".py", "srepr", cache_version=14)

    cache.put_result(old, source, 5.0, {"value": "Function('Rule')()"})

    cached = cache.get(current, source, 300.0)

    assert cached is not None


def test_sympy_cache_upgrade_reruns_sources_with_fold_list(tmp_path):
    source = tmp_path / "case.py"
    source.write_text("value = FoldList[Plus, 1, {2, 3}]\n")
    cache = ReferenceCache(tmp_path / "reference.json")
    old = Backend("sympy", ".py", "srepr", cache_version=13)
    current = Backend("sympy", ".py", "srepr", cache_version=14)

    cache.put_result(old, source, 5.0, {"value": "Function('FoldList')()"})

    assert cache.get(current, source, 300.0) is None


def test_sympy_cache_upgrade_reuses_sources_without_trigreduce(tmp_path):
    source = tmp_path / "case.py"
    source.write_text("value = x + 1\n")
    cache = ReferenceCache(tmp_path / "reference.json")
    old = Backend("sympy", ".py", "srepr", cache_version=22)
    current = Backend("sympy", ".py", "srepr", cache_version=23)

    cache.put_result(old, source, 5.0, {"value": "Add(Symbol('x'), Integer(1))"})

    assert cache.get(current, source, 300.0) is not None


def test_sympy_cache_upgrade_reruns_sources_with_trigreduce(tmp_path):
    source = tmp_path / "case.py"
    source.write_text("value = TrigReduce[Sin[x] Sin[y]]\n")
    cache = ReferenceCache(tmp_path / "reference.json")
    old = Backend("sympy", ".py", "srepr", cache_version=22)
    current = Backend("sympy", ".py", "srepr", cache_version=23)

    cache.put_result(old, source, 5.0, {"value": "Integer(0)"})

    assert cache.get(current, source, 300.0) is None


def test_sympy_cache_upgrade_reuses_single_integrate_rows(tmp_path):
    source = tmp_path / "case.py"
    source.write_text("value = Integrate[x, {x, 0, 1}]\n")
    cache = ReferenceCache(tmp_path / "reference.json")
    old = Backend("sympy", ".py", "srepr", cache_version=23)
    current = Backend("sympy", ".py", "srepr", cache_version=24)

    cache.put_result(old, source, 5.0, {"value": "Rational(1, 2)"})

    assert cache.get(current, source, 300.0) is not None


def test_sympy_cache_upgrade_reruns_multiple_integrate_rows(tmp_path):
    source = tmp_path / "case.py"
    source.write_text(
        "value = Integrate[x + y, {x, 0, 1}, {y, 0, x}]\n"
    )
    cache = ReferenceCache(tmp_path / "reference.json")
    old = Backend("sympy", ".py", "srepr", cache_version=23)
    current = Backend("sympy", ".py", "srepr", cache_version=24)

    cache.put_result(old, source, 5.0, {"value": "Rational(1, 2)"})

    assert cache.get(current, source, 300.0) is None


def test_sympy_cache_upgrade_reuses_non_string_version_14_rows(tmp_path):
    source = tmp_path / "case.py"
    source.write_text("_ASSIGNMENTS = [('value', 'x + 1', ())]\n")
    cache = ReferenceCache(tmp_path / "reference.json")
    old = Backend("sympy", ".py", "srepr", cache_version=14)
    current = Backend("sympy", ".py", "srepr", cache_version=16)

    cache.put_result(old, source, 5.0, {"value": "Add(Symbol('x'), Integer(1))"})

    assert cache.get(current, source, 300.0) is not None


def test_sympy_cache_upgrade_reruns_version_14_string_rows(tmp_path):
    source = tmp_path / "case.py"
    source.write_text("_ASSIGNMENTS = [('value', '\"figures\"', ())]\n")
    cache = ReferenceCache(tmp_path / "reference.json")
    old = Backend("sympy", ".py", "srepr", cache_version=14)
    current = Backend("sympy", ".py", "srepr", cache_version=16)

    cache.put_result(old, source, 5.0, {"value": "Function('_Str')(Symbol('figures'))"})

    assert cache.get(current, source, 300.0) is None


def test_refresh_prunes_superseded_rows_for_the_same_source(tmp_path):
    source = tmp_path / "case.py"
    source.write_text("answer = 2\n")
    path = tmp_path / "reference.json"
    cache = ReferenceCache(path, autosave=False)
    old = Backend("sympy", ".py", "srepr", cache_version=1)
    current = Backend("sympy", ".py", "srepr", cache_version=2)

    cache.put_result(old, source, 5.0, {"answer": "Integer(1)"})
    cache.put_result(current, source, 5.0, {"answer": "Integer(2)"})
    cache.flush()

    payload = json.loads(path.read_text())
    assert len(payload["entries"]) == 1
    assert ReferenceCache(path).get(current, source, 300.0).results == {
        "answer": "Integer(2)"
    }


def test_empty_wolfram_result_is_a_valid_protocol_result():
    results, seconds = _parse_wolfram_output("T\t0.125\n")

    assert results == {}
    assert seconds == 0.125


def test_native_result_is_reused_until_the_executable_changes(tmp_path, monkeypatch):
    source = tmp_path / "case.wl"
    source.write_text("answer = 2\n")
    executable = tmp_path / "fortsym_wl_run"
    executable.write_bytes(b"native-v1")
    monkeypatch.setattr(
        "fortsym_bench.cache.shutil.which", lambda name: str(executable)
    )
    calls = []

    def fake_run(*args, **kwargs):
        calls.append(1)
        return {"answer": "2"}, 0.01

    monkeypatch.setattr("fortsym_bench.cli.run", fake_run)
    cache_path = tmp_path / "reference.json"
    cache = ReferenceCache(cache_path)
    stem = source.with_suffix("")

    first, first_times, first_failure, first_cached = run_one(
        "fortsym-wl", stem, 1, 5.0, cache
    )

    assert first_failure is None
    assert first_cached is False
    assert first_times
    assert first == {"answer": "2"}
    assert len(calls) == 1

    def must_not_run(*args, **kwargs):
        raise AssertionError("the cached native result was executed again")

    monkeypatch.setattr("fortsym_bench.cli.run", must_not_run)
    second, second_times, second_failure, second_cached = run_one(
        "fortsym-wl", stem, 1, 300.0, cache
    )

    assert second_failure is None
    assert second_cached is True
    assert second_times == []
    assert second == first

    executable.write_bytes(b"native-v2")
    monkeypatch.setattr("fortsym_bench.cli.run", fake_run)
    fresh_cache = ReferenceCache(cache_path)
    third, third_times, third_failure, third_cached = run_one(
        "fortsym-wl", stem, 1, 5.0, fresh_cache
    )

    assert third_failure is None
    assert third_cached is False
    assert third_times
    assert third == first


def test_cached_oracle_result_survives_a_missing_executable(tmp_path, monkeypatch):
    source = tmp_path / "case.wl"
    source.write_text("answer = 2\n")
    executable = tmp_path / "mathics"
    executable.write_bytes(b"mathics-v1")
    cache = ReferenceCache(tmp_path / "reference.json")

    monkeypatch.setattr(
        "fortsym_bench.cache.shutil.which", lambda name: str(executable)
    )
    cache.put_result(BACKENDS["mathics"], source, 300.0, {"answer": "2"})

    monkeypatch.setattr("fortsym_bench.cache.shutil.which", lambda name: None)
    reloaded = ReferenceCache(tmp_path / "reference.json")
    cached = reloaded.get(BACKENDS["mathics"], source, 60.0)

    assert cached is not None
    assert cached.results == {"answer": "2"}


def test_deferred_cache_updates_are_written_on_flush(tmp_path):
    source = tmp_path / "case.py"
    source.write_text(
        "import sympy as sp\n"
        "def results():\n"
        "    return {'answer': sp.Integer(4)}\n"
    )
    path = tmp_path / "reference.json"
    cache = ReferenceCache(path, autosave=False)
    stem = source.with_suffix("")

    first, _, failure, _ = run_one("sympy", stem, 1, 5.0, cache)
    assert failure is None
    assert first["answer"] == "Integer(4)"
    assert not path.exists()

    cache.flush()
    loaded = ReferenceCache(path)
    cached = loaded.get(BACKENDS["sympy"], source, 300.0)
    assert cached is not None
    assert cached.results == first


def test_unchanged_cache_flush_skips_serialization(tmp_path, monkeypatch):
    source = tmp_path / "case.py"
    source.write_text("answer = 2\n")
    reference_path = tmp_path / "reference.json"
    comparison_path = tmp_path / "comparisons.json"

    reference = ReferenceCache(reference_path, autosave=False)
    reference.put_result(BACKENDS["sympy"], source, 5.0, {"answer": "2"})
    reference.flush()
    loaded_reference = ReferenceCache(reference_path, autosave=False)

    comparison = ComparisonCache(comparison_path, autosave=False)
    comparison.put("2", "inputform", "2", "srepr", "structural", "agree", "")
    comparison.flush()
    loaded_comparison = ComparisonCache(comparison_path, autosave=False)

    def must_not_serialize(*args, **kwargs):
        raise AssertionError("unchanged cache was serialized")

    monkeypatch.setattr("fortsym_bench.cache.json.dump", must_not_serialize)
    loaded_reference.flush()
    loaded_comparison.flush()

    assert loaded_reference.get(BACKENDS["sympy"], source, 300.0) is not None
    assert loaded_comparison.get(
        "2", "inputform", "2", "srepr", "structural"
    ) == ("agree", "")


def test_comparison_cache_keys_both_operands_and_policy(tmp_path):
    path = tmp_path / "comparisons.json"
    cache = ComparisonCache(path, autosave=False)
    cache.put("1", "inputform", "Integer(1)", "srepr", "structural", "agree", "")
    cache.flush()

    loaded = ComparisonCache(path)
    assert loaded.get("1", "inputform", "Integer(1)", "srepr", "structural") == (
        "agree",
        "",
    )
    assert loaded.get("1", "inputform", "Integer(1)", "srepr", "equivalent") is None
    assert loaded.get("2", "inputform", "Integer(1)", "srepr", "structural") is None
