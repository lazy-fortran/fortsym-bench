import json
from pathlib import Path

import pytest
import sympy as s

from fortsym_bench.compare import AGREE, DIFFER, compare, parse


CASES = json.loads((Path(__file__).parents[1] / 'fortsym_bench/exact_cases.json').read_text())


@pytest.mark.parametrize('row', CASES, ids=lambda row: row['cases'][0])
def test_each_corpus_certificate_is_reproved(row):
    a, b = parse(row['left'], 'srepr'), parse(row['right'], 'srepr')
    assert compare(a, b, 'structural').outcome == AGREE


def test_an_unregistered_identity_remains_structurally_distinct():
    x = s.Symbol('unregistered_canonical_case')
    assert compare((x + 1)**2, x**2 + 2*x + 1, 'structural').outcome == DIFFER


def test_a_changed_coefficient_does_not_inherit_a_certificate():
    row = next(row for row in CASES if row['cases'][0].endswith(':rhsA'))
    a, b = parse(row['left'], 'srepr'), parse(row['right'], 'srepr')
    assert compare(a + 1, b, 'structural').outcome == DIFFER


def test_registration_without_a_zero_witness_never_passes(monkeypatch):
    import fortsym_bench.compare as comparator
    x = s.Symbol('incorrect_certificate_case')
    a, b = (x + 1)**2, x**2 + 2*x + 2
    key = tuple(sorted((s.srepr(a), s.srepr(b))))
    monkeypatch.setattr(comparator, '_exact_cases', lambda: {key: 'symbolic-zero'})
    assert compare(a, b, 'structural').outcome == DIFFER
