from pathlib import Path

from fortsym_bench.cli import (
    AGREE,
    ERROR,
    UNTRANSLATED,
    build_summary,
    discover,
)


def test_discover_merges_wolfram_and_python_pairs(tmp_path: Path):
    (tmp_path / "sample.wl").write_text("x = 1;\n")
    (tmp_path / "sample.py").write_text("def results(): return {}\n")
    (tmp_path / "only.wl").write_text("y = 2;\n")
    (tmp_path / "_fixture.wl").write_text("ignored = True;\n")

    assert discover([tmp_path]) == [
        tmp_path / "only",
        tmp_path / "sample",
    ]


def test_build_summary_preserves_backend_and_binding_coverage():
    report = {
        "scripts": {
            "corpus/sample": {
                "outcomes": {
                    "fortsym-wl": {
                        "first": {"outcome": AGREE},
                        "second": {"outcome": ERROR},
                    }
                },
                "failures": {
                    "mathics": {
                        "outcome": UNTRANSLATED,
                        "detail": "fixture has no oracle input",
                    }
                },
                "oracles": {"first": "oracle disagreement"},
            }
        }
    }

    summary = build_summary(report)

    assert summary["outcomes"][AGREE] == 1
    assert summary["outcomes"][ERROR] == 1
    assert summary["outcomes"][UNTRANSLATED] == 1
    assert summary["outcomes"]["oracle-disagreement"] == 1
    assert summary["per_backend"]["fortsym-wl"]["bindings"] == 2
    assert summary["per_backend"]["mathics"][UNTRANSLATED] == 1
    assert summary["scripts"] == {"produced": 1, "total": 1}
    assert summary["exit_code"] == 1
