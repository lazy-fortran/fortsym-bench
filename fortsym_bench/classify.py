"""Classify disagreement evidence without treating reference votes as proof."""

from __future__ import annotations

import argparse
import ast
from collections import Counter
import hashlib
import json
import math
from pathlib import Path
import re
import subprocess
import sys
import unicodedata


CATEGORIES = frozenset(("assumption", "branch", "equivalent-form", "unsupported",
                        "translation", "wrong", "unknown"))
MAX_TEXT = 16_384
MAX_NODES = 512
MAX_DEGREE = 16


def digest(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def _polynomial(text: str, syntax: str):
    """Read only a small exact polynomial language, without eval or sympify."""
    import sympy as sp

    if len(text) > MAX_TEXT:
        raise ValueError("expression exceeds the text budget")
    if syntax == "inputform":
        if (not re.fullmatch(r"[\w\s+*/^().,-]+", text)
                or any(token in text for token in ("**", "++", "--", "_"))
                or re.search(r"\b0[xXbBoO]", text)
                or unicodedata.normalize("NFKC", text) != text):
            raise ValueError("outside the exact polynomial input language")
        text = text.replace("^", "**")
    elif syntax != "srepr":
        raise ValueError("unknown operand syntax")
    tree = ast.parse(text, mode="eval")
    if sum(1 for _ in ast.walk(tree)) > MAX_NODES:
        raise ValueError("expression exceeds the tree budget")

    def degree(expression):
        if expression.is_Rational:
            return 0
        if expression.is_Symbol:
            return 1
        if expression.is_Add:
            return max(degree(a) for a in expression.args)
        if expression.is_Mul:
            return sum(degree(a) for a in expression.args)
        if expression.is_Pow:
            return degree(expression.base) * int(expression.exp)
        raise ValueError("not an exact polynomial")

    def power(base, exponent):
        if (not exponent.is_Integer or not 0 <= exponent <= MAX_DEGREE
                or degree(base) * int(exponent) > MAX_DEGREE):
            raise ValueError("power outside the polynomial budget")
        if exponent == 0 and not (base.is_Rational and base != 0):
            raise ValueError("zero power needs a provably nonzero base")
        for number in base.atoms(sp.Rational):
            bits = max(abs(int(number.p)).bit_length(), int(number.q).bit_length())
            if bits * int(exponent) > 4096:
                raise ValueError("coefficient exceeds the arithmetic budget")
        return base ** exponent

    def integer(node):
        if isinstance(node, ast.Constant) and type(node.value) is int:
            if abs(node.value).bit_length() <= 128:
                return node.value
        if isinstance(node, ast.UnaryOp) and isinstance(node.op, ast.USub):
            return -integer(node.operand)
        raise ValueError("expected a bounded integer")

    def read(node):
        if isinstance(node, ast.Constant) and type(node.value) is int:
            return sp.Integer(integer(node))
        if isinstance(node, ast.UnaryOp) and isinstance(node.op, ast.USub):
            return -read(node.operand)
        if isinstance(node, ast.Name) and syntax == "inputform":
            if node.id in ("I", "E", "Pi", "Infinity", "Indeterminate",
                            "True", "False", "Null", "ComplexInfinity",
                            "Catalan", "EulerGamma", "GoldenRatio", "Degree",
                            "Nothing", "All", "Automatic", "None"):
                raise ValueError("non-rational constant")
            return sp.Symbol(node.id)
        if isinstance(node, ast.BinOp) and syntax == "inputform":
            left, right = read(node.left), read(node.right)
            if isinstance(node.op, ast.Add):
                return left + right
            if isinstance(node.op, ast.Sub):
                return left - right
            if isinstance(node.op, ast.Mult):
                if degree(left) + degree(right) > MAX_DEGREE:
                    raise ValueError("product exceeds the polynomial budget")
                return left * right
            if isinstance(node.op, ast.Pow):
                return power(left, right)
            if (isinstance(node.op, ast.Div) and left.is_Rational
                    and right.is_Rational and right != 0):
                return left / right
            # Even cancelled division can hide an excluded source-domain point.
            raise ValueError("division is outside the polynomial proof language")
        if not (syntax == "srepr" and isinstance(node, ast.Call)
                and isinstance(node.func, ast.Name)):
            raise ValueError("outside the exact polynomial constructor language")
        name = node.func.id
        if node.keywords:
            raise ValueError("constructor assumptions need reviewed evidence")
        if name == "Integer" and len(node.args) == 1:
            return sp.Integer(integer(node.args[0]))
        if name == "Rational" and len(node.args) == 2:
            numerator, denominator = (integer(a) for a in node.args)
            if not denominator:
                raise ValueError("zero rational denominator")
            return sp.Rational(numerator, denominator)
        if name == "Symbol" and len(node.args) == 1:
            arg = node.args[0]
            if (isinstance(arg, ast.Constant) and isinstance(arg.value, str)
                    and 0 < len(arg.value) <= 80):
                return sp.Symbol(arg.value)
            raise ValueError("invalid symbol name")
        if name in ("Add", "Mul") and 1 <= len(node.args) <= 32:
            arguments = [read(a) for a in node.args]
            if name == "Mul" and sum(degree(a) for a in arguments) > MAX_DEGREE:
                raise ValueError("product exceeds the polynomial budget")
            return (sp.Add if name == "Add" else sp.Mul)(
                *arguments)
        if name == "Pow" and len(node.args) == 2:
            base, exponent = (read(a) for a in node.args)
            return power(base, exponent)
        raise ValueError("constructor outside the exact polynomial proof language")

    expression = read(tree.body)
    symbols = sorted(expression.free_symbols, key=str)
    if len(symbols) > 8:
        raise ValueError("too many polynomial variables")
    if symbols:
        if math.comb(degree(expression) + len(symbols), len(symbols)) > 4096:
            raise ValueError("polynomial expansion exceeds the proof budget")
        polynomial = sp.Poly(expression, *symbols, domain=sp.QQ)
        if polynomial.total_degree() > MAX_DEGREE or len(polynomial.terms()) > 4096:
            raise ValueError("polynomial expansion exceeds the proof budget")
    return expression


def _proof_worker(payload: dict) -> dict:
    try:
        left = _polynomial(payload["left"], payload["left_syntax"])
        right = _polynomial(payload["right"], payload["right_syntax"])
        import sympy as sp
        symbols = sorted(left.free_symbols | right.free_symbols, key=str)
        difference = left - right
        equal = (sp.Poly(difference, *symbols, domain=sp.QQ).is_zero
                 if symbols else difference == 0)
        return {"proved": bool(equal),
                "detail": "exact polynomial identity over the rationals"
                if equal else "exact polynomial expressions are distinct"}
    except (ValueError, TypeError, SyntaxError, MemoryError, RecursionError) as exc:
        return {"proved": False, "detail": str(exc)}


def prove_polynomial(left: str, left_syntax: str, right: str,
                     right_syntax: str, timeout: float = 2.0) -> dict:
    """Bound parsing and exact arithmetic independently of the corpus runner."""
    if max(len(left), len(right)) > MAX_TEXT:
        return {"proved": False, "detail": "expression exceeds the text budget"}
    payload = dict(left=left, left_syntax=left_syntax, right=right,
                   right_syntax=right_syntax)
    try:
        result = subprocess.run(
            [sys.executable, "-m", "fortsym_bench.classify", "--proof-worker"],
            input=json.dumps(payload), capture_output=True, text=True,
            timeout=timeout, check=False,
        )
    except subprocess.TimeoutExpired:
        return {"proved": False, "detail": "exact proof exceeded its time budget"}
    try:
        answer = json.loads(result.stdout)
        if result.returncode == 0 and isinstance(answer.get("proved"), bool):
            return answer
    except (ValueError, AttributeError):
        pass
    return {"proved": False, "detail": "exact proof process did not complete"}


def _cache_index(cache: dict, root: Path) -> dict:
    grouped = {}
    for entry in cache.get("entries", {}).values():
        source = entry.get("source")
        if not isinstance(source, str):
            continue
        path = root / source
        if not path.is_file() or digest(path) != entry.get("source_sha256"):
            continue
        key = (entry.get("backend"), str(Path(source).with_suffix("")))
        grouped.setdefault(key, []).append(entry)
    # A report does not identify which of several executable versions it used.
    return {key: rows[0] for key, rows in grouped.items() if len(rows) == 1}


def _manual_records(payload: list, root: Path) -> dict:
    records = {}
    for row in payload:
        if row.get("classification") not in CATEGORIES - {"unknown"}:
            raise ValueError("unknown reviewed-evidence classification")
        required = ("script", "binding", "backend", "rationale", "reviewed_by",
                    "source_sha256", "artifact", "artifact_sha256", "observed",
                    "comparison_sha256")
        if any(not isinstance(row.get(k), str) or not row[k] for k in required):
            raise ValueError("reviewed evidence requires complete source and artifact identities")
        suffix = ".py" if row["backend"] in ("sympy", "fortsym-sympy") else ".wl"
        source = root / (row["script"] + suffix)
        artifact = root / row["artifact"]
        if (not source.is_file() or digest(source) != row["source_sha256"]
                or not artifact.is_file() or digest(artifact) != row["artifact_sha256"]):
            raise ValueError("reviewed evidence does not match its source or artifact")
        if row["classification"] == "translation":
            for name, extension in (("companion_sha256", ".py"), ("wolfram_sha256", ".wl")):
                path = root / (row["script"] + extension)
                if not path.is_file() or digest(path) != row.get(name):
                    raise ValueError("translation evidence does not match both source representations")
        if row["classification"] not in ("wrong", "unsupported"):
            if not isinstance(row.get("reference_observed"), str) or not row["reference_observed"]:
                raise ValueError("reviewed cause requires the observed reference operand")
        if row["classification"] == "wrong":
            if any(not isinstance(row.get(k), str) or not row[k]
                   for k in ("expected", "observed", "reproducer", "reproducer_sha256")):
                raise ValueError("wrong-result evidence requires expected, observed and reproducer identity")
            reproducer = root / row["reproducer"]
            if not reproducer.is_file() or digest(reproducer) != row["reproducer_sha256"]:
                raise ValueError("wrong-result reproducer does not match its recorded digest")
        key = (row["script"], row["binding"], row["backend"])
        if key in records:
            raise ValueError("duplicate reviewed evidence")
        records[key] = row
    return records


def classify_report(report: dict, cache: dict | None = None, *,
                    root: Path = Path("."), reviewed: list | None = None,
                    manifest: dict | None = None, timeout: float = 2.0) -> dict:
    """Classify disagreements; evidence for a wrong result is always explicit."""
    index = _cache_index(cache or {}, root)
    annotations = _manual_records(reviewed or [], root)
    records = []
    used_annotations = set()

    def add(script, binding, backend, outcome, detail, reference=None):
        candidate_entry = index.get((backend, script)) or {}
        reference_entry = index.get((reference, script)) or {}
        candidate_value = candidate_entry.get("results", {}).get(binding)
        reference_value = reference_entry.get("results", {}).get(binding)
        identity = dict(script=script, binding=binding, backend=backend,
                        reference=reference, outcome=outcome, detail=detail,
                        candidate=candidate_value, reference_value=reference_value,
                        candidate_source=candidate_entry.get("source_sha256"),
                        reference_source=reference_entry.get("source_sha256"))
        record = dict(script=script, binding=binding, backend=backend,
                      reference=reference, outcome=outcome,
                      classification="unknown", evidence=[detail] if detail else [],
                      comparison_sha256=hashlib.sha256(json.dumps(
                          identity, sort_keys=True, separators=(",", ":")
                      ).encode()).hexdigest())
        coverage = (manifest or {}).get(script + ".wl", {})
        if coverage.get("skipped_statements", 0):
            record["coverage"] = {
                "skipped_statements": coverage["skipped_statements"],
                "note": "partial companion coverage is not evidence of a translation defect",
            }
        annotation = annotations.get((script, binding, backend))
        if annotation:
            if annotation["comparison_sha256"] != record["comparison_sha256"]:
                raise ValueError("reviewed evidence does not match the comparison operands")
            observed = (detail if binding == "__script__" else
                        candidate_value)
            if observed != annotation["observed"]:
                raise ValueError("reviewed result does not match a unique raw operand")
            if annotation["classification"] not in ("wrong", "unsupported"):
                if reference_value != annotation["reference_observed"]:
                    raise ValueError("reviewed cause does not match a unique reference operand")
            used_annotations.add((script, binding, backend))
            record["classification"] = annotation["classification"]
            record["reviewed_evidence"] = annotation
            record["evidence"].append(
                "reviewed source and artifact digests match; mathematical argument not rechecked")
        elif outcome == "unsupported":
            record["classification"] = "unsupported"
            record["evidence"].append("backend explicitly refused the operation")
        elif outcome in ("differ", "oracle-disagreement"):
            left_entry, right_entry = index.get((backend, script)), index.get((reference, script))
            left = (left_entry or {}).get("results", {}).get(binding)
            right = (right_entry or {}).get("results", {}).get(binding)
            syntaxes = {"sympy": "srepr", "fortsym-sympy": "srepr",
                        "mathics": "inputform", "fortsym-wl": "inputform"}
            if (isinstance(left, str) and isinstance(right, str)
                    and backend in syntaxes and reference in syntaxes):
                proof = prove_polynomial(left, syntaxes[backend], right,
                                         syntaxes[reference], timeout)
                record["operands"] = {
                    "left": left, "right": right,
                    "left_syntax": syntaxes[backend], "right_syntax": syntaxes[reference],
                }
                record["evidence"].append(proof["detail"])
                if proof["proved"]:
                    record["classification"] = "equivalent-form"
            else:
                record["evidence"].append("unique source-matching raw operands unavailable")
        records.append(record)

    for script, row in sorted(report.get("scripts", {}).items()):
        for backend, failure in sorted(row.get("failures", {}).items()):
            add(script, "__script__", backend, failure["outcome"], failure.get("detail", ""))
        oracles = row.get("oracles", {})
        for binding, detail in sorted(oracles.items()):
            add(script, binding, "mathics", "oracle-disagreement", detail, "sympy")
        for backend, bindings in sorted(row.get("outcomes", {}).items()):
            for binding, result in sorted(bindings.items()):
                outcome = result["outcome"]
                annotated = (script, binding, backend) in annotations
                if ((outcome == "agree" or outcome == "oracle-disagreement" and binding in oracles)
                        and not annotated):
                    continue
                mathics_value = (index.get(("mathics", script)) or {}).get("results", {}).get(binding)
                reference = ("mathics" if backend == "fortsym-wl"
                             and isinstance(mathics_value, str) else "sympy")
                add(script, binding, backend, outcome, result.get("detail", ""), reference)
    if set(annotations) != used_annotations:
        raise ValueError("reviewed evidence does not identify a reported disagreement")
    return {
        "schema_version": 1,
        "scope": "evidence classification, not independent validation of reviewed arguments",
        "counts": dict(sorted(Counter(r["classification"] for r in records).items())),
        "records": records,
    }


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("report", type=Path)
    parser.add_argument("--cache", type=Path)
    parser.add_argument("--reviewed", type=Path)
    parser.add_argument("--manifest", type=Path)
    parser.add_argument("--root", type=Path, default=Path("."))
    parser.add_argument("--timeout", type=float, default=2.0)
    parser.add_argument("--out", type=Path, required=True)
    args = parser.parse_args(argv)
    args.manifest = args.manifest or args.root / "translation-manifest.json"
    if not 0 < args.timeout <= 60:
        parser.error("--timeout must be between zero and 60 seconds")
    try:
        inputs = [getattr(args, name) for name in ("report", "cache", "reviewed", "manifest")]
        for path in inputs:
            if path and (args.out.resolve() == path.resolve()
                         or args.out.exists() and path.exists() and args.out.samefile(path)):
                raise ValueError("--out must not identify an input file")
        def read(path):
            return json.loads(path.read_text()) if path else None
        result = classify_report(read(args.report), read(args.cache), root=args.root,
                                 reviewed=read(args.reviewed),
                                 manifest=read(args.manifest) if args.manifest.exists() else None,
                                 timeout=args.timeout)
        result["inputs"] = {"report_sha256": digest(args.report)}
        for name in ("cache", "reviewed", "manifest"):
            path = getattr(args, name)
            if path and path.exists():
                result["inputs"][name + "_sha256"] = digest(path)
        args.out.write_text(json.dumps(result, indent=2) + "\n")
    except (OSError, ValueError, KeyError, TypeError) as exc:
        parser.error(str(exc))
    return 0


if __name__ == "__main__":
    if sys.argv[1:] == ["--proof-worker"]:
        try:
            # Linux enforces this bound independently of the Slurm memory request.
            import resource
            if sys.platform.startswith("linux"):
                resource.setrlimit(resource.RLIMIT_AS, (1024 ** 3, 1024 ** 3))
            print(json.dumps(_proof_worker(json.loads(sys.stdin.read(MAX_TEXT * 3)))))
        except (ValueError, OSError, MemoryError) as exc:
            print(json.dumps({"proved": False, "detail": str(exc)}))
    else:
        raise SystemExit(main())
