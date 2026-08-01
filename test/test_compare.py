from __future__ import annotations

from fortsym_bench.cli import _score
from fortsym_bench.compare import ORACLE_MISSING
from fortsym_bench.backends import BACKENDS


def test_candidate_only_binding_is_reported_outside_the_scored_overlap():
    scored = _score(
        {"candidate_only": "Integer(4)"},
        {"oracle_only": "Integer(4)"},
        BACKENDS["fortsym-wl"],
        "mathics",
        {},
    )

    assert scored["candidate_only"]["outcome"] == ORACLE_MISSING
