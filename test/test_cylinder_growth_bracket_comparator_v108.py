from __future__ import annotations

import json

from fortsym_bench.cache import ComparisonCache, COMPARISON_CACHE_VERSION
from fortsym_bench.compare import DIFFER, compare_text


def test_mathics_list_arithmetic_is_opaque_and_never_agrees_with_native_text():
    # This is the small shape embedded in the cached cylinder growthBracket
    # result: Mathics emits a List inside arithmetic, which SymPy's
    # Mathematica parser otherwise turns into an invalid Add/Pow tree.
    result = compare_text(
        "refineBracket[lagU, growthBracket, 4, 8]",
        "{Part[{1 + {2}}, 1]}",
        "inputform",
        "structural",
    )

    assert result.outcome == DIFFER
    assert "as_coeff_Mul" not in result.detail


def test_old_comparison_cache_version_cannot_reuse_a_malformed_verdict(tmp_path):
    path = tmp_path / "comparisons.json"
    path.write_text(
        json.dumps(
            {
                "version": COMPARISON_CACHE_VERSION - 1,
                "entries": {
                    "stale": {"outcome": "agree", "detail": ""},
                },
            }
        )
    )

    cache = ComparisonCache(path)

    assert cache.get("candidate", "inputform", "reference", "inputform", "structural") is None
