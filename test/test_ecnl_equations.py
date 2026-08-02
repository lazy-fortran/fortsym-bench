import hashlib
import importlib.util
import json
import re
from pathlib import Path


_SOURCE = Path(__file__).parents[1] / "corpus/proj-ecnl-gorilla-recovery/equations.py"
_SPEC = importlib.util.spec_from_file_location("ecnl_equations", _SOURCE)
ecnl = importlib.util.module_from_spec(_SPEC)
assert _SPEC.loader is not None
_SPEC.loader.exec_module(ecnl)


def test_equation_catalogue_returns_all_source_records_as_string_atoms():
    values = ecnl.results()

    assert len(ecnl._EQUATION_TEX) == 31
    assert set(ecnl._EQUATION_TEX) <= set(values)
    assert all(str(values[name]).startswith("fortsymString") for name in ecnl._EQUATION_TEX)


def test_string_atom_matches_inputform_normalisation_protocol():
    value = ecnl._EQUATION_TEX["gamma"]
    literal = json.dumps(value, ensure_ascii=False)
    digest = hashlib.sha256(literal.encode("utf-8")).hexdigest()
    expected = re.sub(r"([eE][+-]?)0+(\d+)", r"\1\2", digest)

    assert str(ecnl._string_atom(value)) == "fortsymString" + expected
