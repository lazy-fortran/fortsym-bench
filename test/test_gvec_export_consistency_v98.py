"""Independent oracle for the recovered gvec ``II_tt`` export label."""

from __future__ import annotations

import hashlib
import importlib.util
import json
from pathlib import Path

import sympy as sp


def _load_target():
    path = (
        Path(__file__).parents[1]
        / 'corpus/proj-gvec-stability/gvec_export_consistency.py'
    )
    spec = importlib.util.spec_from_file_location('gvec_export_consistency_v98', path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_ii_tt_export_label_is_the_source_tex_string_atom():
    values = _load_target().results()
    literal = r'\mathrm{II}_{\vartheta\vartheta}'
    digest = hashlib.sha256(
        json.dumps(literal, ensure_ascii=False).encode('utf-8')
    ).hexdigest()

    assert values['II_tt'] == sp.Symbol('fortsymString' + digest)
