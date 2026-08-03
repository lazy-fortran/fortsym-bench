"""Independent oracle for the recovered Fourier-convergence ``II_tt`` label."""

from __future__ import annotations

import hashlib
import importlib.util
import json
from pathlib import Path

import sympy as sp


def _load_target():
    path = (
        Path(__file__).parents[1]
        / 'corpus/proj-gvec-stability/gvec_fourier_convergence.py'
    )
    spec = importlib.util.spec_from_file_location(
        'gvec_fourier_convergence_v105', path
    )
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_ii_tt_label_is_the_source_tex_string_atom():
    literal = r'\mathrm{II}_{\vartheta\vartheta}'
    digest = hashlib.sha256(
        json.dumps(literal, ensure_ascii=False).encode('utf-8')
    ).hexdigest()

    assert _load_target().results()['II_tt'] == sp.Symbol(
        'fortsymString' + digest
    )
