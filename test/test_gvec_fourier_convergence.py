"""Independent oracle for one recovered Fourier-convergence binding."""

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
        'gvec_fourier_convergence', path
    )
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_ii_tz_label_is_the_source_tex_string_atom():
    literal = r'\mathrm{II}_{\vartheta\zeta}'
    digest = hashlib.sha256(
        json.dumps(literal, ensure_ascii=False).encode('utf-8')
    ).hexdigest()

    assert _load_target().results()['II_tz'] == sp.Symbol(
        'fortsymString' + digest
    )
