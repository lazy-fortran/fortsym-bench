from __future__ import annotations

from pathlib import Path

from fortsym_bench.backends import Backend
from fortsym_bench.cache import ReferenceCache
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
    current = Backend("mathics", ".wl", "inputform", cache_version=2)

    cache.put_result(old, source, 5.0, {"answer": "2"})

    assert cache.get(old, source, 5.0) is not None
    assert cache.get(current, source, 5.0) is None
