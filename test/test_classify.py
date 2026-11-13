from __future__ import annotations

import json
from pathlib import Path
import subprocess

import pytest

from fortsym_bench.classify import classify_report, digest, main, prove_polynomial


def _report(outcome="differ"):
    return {"scripts": {"corpus/example": {
        "outcomes": {"fortsym-wl": {"value": {"outcome": outcome, "detail": ""}}},
        "failures": {}, "oracles": {},
    }}}


def _cache(root, left, right, reference="mathics"):
    (root / "corpus").mkdir(exist_ok=True)
    source = root / "corpus/example.wl"
    source.write_text("value = (x + 1)^2\n")
    return {"version": 1, "entries": {
        name: dict(backend=name, source="corpus/example.wl",
                   source_sha256=digest(source), outcome="ok", results={"value": value})
        for name, value in (("fortsym-wl", left), (reference, right))
    }}


def test_different_polynomial_forms_have_an_exact_identity_witness(tmp_path):
    cache = _cache(tmp_path, "(x + 1)^2", "x^2 + 2*x + 1")
    result = classify_report(_report(), cache, root=tmp_path)
    assert result["counts"] == {"equivalent-form": 1}
    assert "exact polynomial identity" in result["records"][0]["evidence"][-1]


def test_cross_syntax_exact_rational_polynomial_is_proved():
    answer = prove_polynomial(
        "x/2 + x/2", "inputform", "Symbol('x')", "srepr")
    # Symbolic division is deliberately excluded, even by a constant.
    assert not answer["proved"]
    answer = prove_polynomial(
        "x*(1/2) + x*(1/2)", "inputform", "Symbol('x')", "srepr")
    assert answer["proved"]


@pytest.mark.parametrize("left,right", [
    ("x/x", "1"),
    ("Sqrt[x^2]", "x"),
    ("0.1 + 0.2", "0.3"),
    ("x + 1", "x + 2"),
    ("((x + 1)^16)^16", "x"),
    ("2^999999999", "1"),
    ("0^0", "1"),
    ("x^0", "1"),
    ("x ** 2", "x^2"),
    ("--x", "x"),
    ("x_y", "x_y"),
    ("True", "True"),
    ("0xF", "15"),
    ("K", "K"),
])
def test_unproved_or_domain_sensitive_results_remain_unknown(tmp_path, left, right):
    cache = _cache(tmp_path, left, right)
    result = classify_report(_report(), cache, root=tmp_path)
    assert result["counts"] == {"unknown": 1}


def test_unsupported_is_an_explicit_refusal_and_missing_coverage_is_not_a_defect(tmp_path):
    report = _report("unsupported")
    result = classify_report(report, root=tmp_path,
                             manifest={"corpus/example.wl": {"skipped_statements": 7}})
    record = result["records"][0]
    assert record["classification"] == "unsupported"
    assert record["coverage"]["skipped_statements"] == 7
    result = classify_report(_report(), root=tmp_path,
                             manifest={"corpus/example.wl": {"skipped_statements": 7}})
    assert result["records"][0]["classification"] == "unknown"


def test_oracle_majority_never_establishes_a_wrong_result(tmp_path):
    cache = _cache(tmp_path, "2", "1")
    source = tmp_path / "corpus/example.py"
    source.write_text("value = 1\n")
    cache["entries"]["sympy"] = dict(
        backend="sympy", source="corpus/example.py", source_sha256=digest(source),
        outcome="ok", results={"value": "Integer(1)"})
    assert classify_report(_report(), cache, root=tmp_path)["counts"] == {"unknown": 1}


def test_partial_execution_marks_mismatch_context_incomplete(tmp_path):
    cache = _cache(tmp_path, "0", "1")
    report = _report()
    report["scripts"]["corpus/example"]["coverage"] = {
        "fortsym-wl": {"status": "partial", "refusals": ["UNSUPPORTED: mutation"]},
    }
    result = classify_report(report, cache, root=tmp_path)
    record = result["records"][0]
    assert record["classification"] == "unknown"
    assert record["execution_context"]["status"] == "incomplete"
    assert record["execution_context"]["backends"]["fortsym-wl"]["refusals"]


def test_missing_mathics_binding_uses_available_sympy_operand(tmp_path):
    cache = _cache(tmp_path, "(x + 1)^2", "x^2 + 2*x + 1")
    cache["entries"]["mathics"].update(outcome="failure", results={})
    source = tmp_path / "corpus/example.py"
    source.write_text("value = (x + 1)**2\n")
    cache["entries"]["sympy"] = dict(
        backend="sympy", source="corpus/example.py", source_sha256=digest(source),
        outcome="ok", results={"value": "Pow(Add(Symbol('x'), Integer(1)), Integer(2))"})
    result = classify_report(_report(), cache, root=tmp_path)
    assert result["counts"] == {"equivalent-form": 1}
    assert result["records"][0]["reference"] == "sympy"


def test_python_candidate_keeps_its_actual_sympy_reference(tmp_path):
    cache = _cache(tmp_path, "2", "2")
    source = tmp_path / "corpus/example.py"
    source.write_text("value = 1\n")
    for backend, value in (("sympy", "Integer(1)"), ("fortsym-sympy", "Integer(2)")):
        cache["entries"][backend] = dict(
            backend=backend, source="corpus/example.py", source_sha256=digest(source),
            outcome="ok", results={"value": value})
    report = _report()
    row = report["scripts"]["corpus/example"]
    row["outcomes"]["fortsym-sympy"] = row["outcomes"].pop("fortsym-wl")
    result = classify_report(report, cache, root=tmp_path)
    assert result["counts"] == {"unknown": 1}
    assert result["records"][0]["reference"] == "sympy"


def test_ambiguous_or_changed_raw_cache_cannot_supply_equivalence(tmp_path):
    cache = _cache(tmp_path, "(x + 1)^2", "x^2 + 2*x + 1")
    cache["entries"]["other-executable"] = dict(cache["entries"]["fortsym-wl"])
    assert classify_report(_report(), cache, root=tmp_path)["counts"] == {"unknown": 1}
    del cache["entries"]["other-executable"]
    (tmp_path / "corpus/example.wl").write_text("changed = 2\n")
    assert classify_report(_report(), cache, root=tmp_path)["counts"] == {"unknown": 1}


def test_oracle_disagreement_is_counted_once_without_a_candidate_vote(tmp_path):
    report = _report("oracle-disagreement")
    report["scripts"]["corpus/example"]["oracles"] = {"value": "references differ"}
    result = classify_report(report, root=tmp_path)
    assert len(result["records"]) == 1
    assert result["records"][0]["backend"] == "mathics"
    assert result["records"][0]["reference"] == "sympy"


def _reviewed(root, cache):
    source = root / "corpus/example.wl"
    artifact = root / "proof.txt"
    artifact.write_text("For input x = 0 the specification is value = 1, not 2.\n")
    reproducer = root / "minimal.wl"
    reproducer.write_text("value = (0 + 1)^2\n")
    return dict(script="corpus/example", binding="value", backend="fortsym-wl",
                classification="wrong", rationale="exact arithmetic at x = 0",
                reviewed_by="test reviewer", source_sha256=digest(source),
                artifact="proof.txt", artifact_sha256=digest(artifact),
                expected="1", observed="2", reproducer="minimal.wl",
                reproducer_sha256=digest(reproducer), comparison_sha256=
                classify_report(_report(), cache, root=root)["records"][0]["comparison_sha256"])


def test_reviewed_wrong_result_requires_matching_evidence_and_reproducer(tmp_path):
    cache = _cache(tmp_path, "2", "1")
    annotation = _reviewed(tmp_path, cache)
    result = classify_report(_report(), cache, root=tmp_path, reviewed=[annotation])
    assert result["counts"] == {"wrong": 1}
    assert result["records"][0]["reviewed_evidence"]["expected"] == "1"
    (tmp_path / "proof.txt").write_text("changed argument")
    with pytest.raises(ValueError, match="does not match"):
        classify_report(_report(), cache, root=tmp_path, reviewed=[annotation])


def test_incomplete_or_unmatched_wrong_result_annotation_is_rejected(tmp_path):
    cache = _cache(tmp_path, "2", "1")
    annotation = _reviewed(tmp_path, cache)
    del annotation["expected"]
    with pytest.raises(ValueError, match="expected, observed and reproducer"):
        classify_report(_report(), cache, root=tmp_path, reviewed=[annotation])
    annotation = _reviewed(tmp_path, cache)
    annotation["binding"] = "misspelled"
    with pytest.raises(ValueError, match="does not identify"):
        classify_report(_report(), cache, root=tmp_path, reviewed=[annotation])


@pytest.mark.parametrize("backend", ["fortsym-wl", "mathics"])
def test_wrong_result_evidence_cannot_be_reused_after_the_output_changes(tmp_path, backend):
    cache = _cache(tmp_path, "2", "1")
    annotation = _reviewed(tmp_path, cache)
    cache["entries"][backend]["results"]["value"] = "3"
    with pytest.raises(ValueError, match="comparison operands"):
        classify_report(_report(), cache, root=tmp_path, reviewed=[annotation])
    cache["entries"][backend]["results"]["value"] = "2" if backend == "fortsym-wl" else "1"
    (tmp_path / "minimal.wl").write_text("value = 3\n")
    with pytest.raises(ValueError, match="reproducer does not match"):
        classify_report(_report(), cache, root=tmp_path, reviewed=[annotation])


def test_translation_evidence_is_bound_to_both_sources_and_outputs(tmp_path):
    cache = _cache(tmp_path, "2*x", "x^2")
    companion = tmp_path / "corpus/example.py"
    companion.write_text("value = x + x\n")
    cache["entries"]["sympy"] = dict(
        backend="sympy", source="corpus/example.py", source_sha256=digest(companion),
        outcome="ok", results={"value": "Mul(Integer(2), Symbol('x'))"})
    annotation = _reviewed(tmp_path, cache)
    annotation.update(classification="translation", observed="2*x",
                      reference_observed="x^2", companion_sha256=digest(companion),
                      wolfram_sha256=digest(tmp_path / "corpus/example.wl"))
    assert classify_report(_report(), cache, root=tmp_path, reviewed=[annotation])["counts"] == {"translation": 1}
    companion.write_text("value = x**2\n")
    with pytest.raises(ValueError, match="both source representations"):
        classify_report(_report(), cache, root=tmp_path, reviewed=[annotation])


def test_python_review_evidence_hashes_the_actual_python_source(tmp_path):
    cache = _cache(tmp_path, "2", "1")
    companion = tmp_path / "corpus/example.py"
    companion.write_text("value = 2\n")
    cache["entries"]["fortsym-sympy"] = dict(
        backend="fortsym-sympy", source="corpus/example.py", source_sha256=digest(companion),
        outcome="ok", results={"value": "Integer(2)"})
    report = _report()
    row = report["scripts"]["corpus/example"]
    row["outcomes"]["fortsym-sympy"] = row["outcomes"].pop("fortsym-wl")
    annotation = _reviewed(tmp_path, cache)
    annotation.update(backend="fortsym-sympy", observed="Integer(2)",
                      source_sha256=digest(companion), comparison_sha256=
                      classify_report(report, cache, root=tmp_path)["records"][0]["comparison_sha256"])
    assert classify_report(report, cache, root=tmp_path, reviewed=[annotation])["counts"] == {"wrong": 1}
    companion.write_text("value = 1\n")
    with pytest.raises(ValueError, match="does not match its source"):
        classify_report(report, cache, root=tmp_path, reviewed=[annotation])


def test_constructor_text_cannot_execute_python(tmp_path):
    marker = tmp_path / "should-not-exist"
    malicious = f"__import__('pathlib').Path({str(marker)!r}).touch()"
    result = prove_polynomial(malicious, "srepr", "Integer(1)", "srepr")
    assert not result["proved"]
    assert not marker.exists()


def test_proof_timeout_stays_unknown(monkeypatch):
    def expire(*args, **kwargs):
        raise subprocess.TimeoutExpired(args[0], 0.1)
    monkeypatch.setattr(subprocess, "run", expire)
    result = prove_polynomial("x", "inputform", "x", "inputform", timeout=0.1)
    assert result == {"proved": False, "detail": "exact proof exceeded its time budget"}


def test_cli_records_input_identities_without_modifying_the_report(tmp_path):
    cache = _cache(tmp_path, "(x + 1)^2", "x^2 + 2*x + 1")
    report_path, cache_path = tmp_path / "report.json", tmp_path / "cache.json"
    output = tmp_path / "classified.json"
    report_path.write_text(json.dumps(_report()))
    cache_path.write_text(json.dumps(cache))
    before = report_path.read_bytes()
    assert main([str(report_path), "--cache", str(cache_path), "--root", str(tmp_path),
                 "--out", str(output)]) == 0
    result = json.loads(output.read_text())
    assert result["counts"] == {"equivalent-form": 1}
    assert result["inputs"]["report_sha256"] == digest(report_path)
    assert result["inputs"]["cache_sha256"] == digest(cache_path)
    assert report_path.read_bytes() == before


@pytest.mark.parametrize("alias", ["same", "symlink", "hardlink"])
def test_cli_refuses_to_overwrite_an_input_file(tmp_path, alias):
    report = tmp_path / "report.json"
    report.write_text(json.dumps(_report()))
    output = report if alias == "same" else tmp_path / "alias.json"
    if alias == "symlink":
        output.symlink_to(report)
    elif alias == "hardlink":
        output.hardlink_to(report)
    before = report.read_bytes()
    with pytest.raises(SystemExit) as caught:
        main([str(report), "--root", str(tmp_path), "--out", str(output)])
    assert caught.value.code == 2
    assert report.read_bytes() == before
