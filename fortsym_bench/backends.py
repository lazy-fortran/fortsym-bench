"""Backend definitions and subprocess runners.

Every backend runs in its own process. Two reasons, both learned the hard way by
anyone who has tried to do this in-process: swapping ``sys.modules["sympy"]``
contaminates whatever imported SymPy earlier, and a CAS that segfaults should
cost one result rather than the whole run.

Results cross the process boundary as text. The Python backends emit ``srepr``;
the Wolfram backends emit ``InputForm``. Neither is parsed here — see
``compare.py``, which does it once, in one place, with one parser per syntax.
"""

from __future__ import annotations

import json
import os
import subprocess
import sys
import tempfile
from dataclasses import dataclass, field
from pathlib import Path

RUNNERS = Path(__file__).parent / "runners"


@dataclass(frozen=True)
class Backend:
    """One system under test or oracle."""

    name: str
    #: Corpus file extension this backend consumes.
    source: str
    #: "srepr" (Python object dump) or "inputform" (Wolfram textual form).
    syntax: str
    #: True when this backend's answers define correctness for its source.
    is_oracle: bool = False
    command: tuple[str, ...] = field(default_factory=tuple)
    #: Bump when the runner or its wrapper changes the meaning of results.
    cache_version: int = 1


BACKENDS = {
    b.name: b
    for b in (
        # The assignment extractor and expression-layout normalisation are
        # part of the oracle contract, so invalidate old raw results when
        # either changes.
        Backend("sympy", ".py", "srepr", is_oracle=True, cache_version=19),
        Backend("fortsym-sympy", ".py", "srepr", cache_version=2),
        Backend("mathics", ".wl", "inputform", is_oracle=True,
                command=("mathics", "-q", "--no-readline", "-c"),
                cache_version=3),
        Backend("fortsym-wl", ".wl", "inputform", command=("fortsym_wl_run",)),
    )
}

# The checked-in implementation is the Fortran backend plus the two
# independent Python/Wolfram oracles. Keep the optional drop-in hook available
# without making the default run report 384 artificial "unavailable" results
# when no separate ``fortsym.sympy`` package is installed.
DEFAULT_BACKENDS = ("sympy", "mathics", "fortsym-wl")


class RunFailure(Exception):
    """The backend did not produce a parseable result set."""

    def __init__(self, kind: str, message: str):
        super().__init__(message)
        #: "unsupported", "error" or "timeout" — never silently "differ".
        self.kind = kind


def run(backend: Backend, script: Path, timeout: float) -> tuple[dict, float]:
    """Run one script under one backend.

    Returns the raw result mapping and the evaluation time in seconds, with
    process startup excluded where the runner can separate it.
    """
    # Resolved before use, not passed through as given. Each run gets a
    # throwaway working directory (below), so a corpus path relative to the
    # repo root would no longer name anything by the time the child looks.
    script = script.resolve()

    if backend.syntax == "srepr":
        argv = [sys.executable, str(RUNNERS / "py_runner.py"), str(script), backend.name]
    elif backend.name == "fortsym-wl":
        # fortsym-wl speaks the R/T protocol itself, so it takes the corpus
        # file directly. It is not a Wolfram interpreter and cannot be handed a
        # wrapper expression to evaluate.
        argv = [*backend.command, str(script)]
    else:
        argv = _wolfram_argv(backend, script)

    env = dict(os.environ, PYTHONHASHSEED="0")
    try:
        # A throwaway working directory per run. The corpus is real research
        # code: it calls Export, Put and Save, and those write to the current
        # directory. Run from the repo root and a scoring pass silently commits
        # a scattering of other people's intermediate output; run two backends
        # from the same directory and each one reads files the other just
        # wrote, which turns an independent oracle into a correlated one.
        # Scripts are handed an absolute path (above) so the change of
        # directory cannot cost them their own source or a Get'd sibling.
        with tempfile.TemporaryDirectory(prefix="fortsym-bench-") as sandbox:
            proc = subprocess.run(
                argv, capture_output=True, text=True, timeout=timeout, env=env,
                stdin=subprocess.DEVNULL, cwd=sandbox,
                # The corpus contains Greek identifiers, and a backend that
                # slices a multi-byte character emits an invalid sequence.
                # Replacing is right here: one mangled identifier costs one
                # result, while a strict decode raises and destroys the entire
                # run's measurement.
                errors="replace",
            )
    except subprocess.TimeoutExpired:
        raise RunFailure("timeout", f"exceeded {timeout}s") from None
    except FileNotFoundError:
        # Not installed is not the same as wrong, and not the same as refusing.
        # It has to stay its own class or an absent oracle silently shrinks the
        # denominator and every rate in the report is overstated.
        raise RunFailure("unavailable", f"{argv[0]} not on PATH") from None

    if proc.returncode != 0:
        stderr = proc.stderr.strip()
        # A backend that names what it cannot do is behaving correctly. Keep
        # that distinct from a crash: conflating the two makes an honest
        # refusal look like a wrong answer.
        kind = "error"
        if "UNSUPPORTED:" in stderr:
            kind = "unsupported"
        elif "UNAVAILABLE:" in stderr:
            kind = "unavailable"
        # Prefer the tagged line over the last one. A Fortran backtrace or a
        # Python traceback puts its least informative frame last, so taking the
        # tail reports "#3 0x... in main" as the reason a construct was
        # declined.
        detail = next(
            (ln for ln in stderr.splitlines()
             if ln.startswith(("UNSUPPORTED:", "UNAVAILABLE:"))),
            stderr.splitlines()[-1] if stderr else "no output",
        )
        raise RunFailure(kind, detail)

    if backend.syntax == "inputform":
        return _parse_wolfram_output(proc.stdout)

    try:
        payload = json.loads(proc.stdout)
    except json.JSONDecodeError:
        raise RunFailure("error", f"unparseable output: {proc.stdout[:200]}") from None

    return payload["results"], float(payload.get("seconds", 0.0))


def _wolfram_argv(backend: Backend, script: Path) -> list[str]:
    """Wrap a .wl corpus file so it prints one top-level binding per line.

    The corpus is 359 real derivation scripts that were never written for a
    harness, so the contract has to be something every one of them already
    satisfies: **every global symbol the script assigned**. Requiring a
    designated results variable would mean editing all 359, which is exactly
    the 1:1 property this repository exists to preserve.

    Associations are flattened into their named values before printing:
    Mathics renders ``->`` inside one as U+21FE, which is not textual syntax
    any parser expects. Flat ``R<TAB>name<TAB>value`` lines sidestep the
    pretty-printer entirely.
    """
    wrapper = (
        # SetDirectory so a script that Gets a sibling by relative name finds
        # it, which most of the corpus does. Harness-owned names are excluded
        # from the results or the wrapper reports its own variables as though
        # the derivation had produced them.
        # Absolute path: Mathics resolves a script's own Get["sibling.wl"]
        # through $InputFileName, which is only set correctly when the outer
        # Get was given a full path. Most of the corpus loads a shared
        # checklib.wl that way.
        # Corpus scripts end by calling their own reportAndExit[], which calls
        # Exit[]. That terminates the kernel before any binding can be dumped,
        # and Mathics then reports the outer Get as unopenable -- which reads
        # like a missing file and is not. Neutralising Exit is the only way to
        # observe a script that was written to be run, not imported, without
        # editing all 384 of them.
        'Unprotect[Exit]; Exit[___] := Null; '
        # Side-effect operations are neutralised. The corpus measures symbolic
        # results, not file I/O, and these actively destroy the measurement:
        # a failing CreateDirectory aborts the enclosing Get in Mathics and is
        # then reported as "cannot open" the script -- a wrong diagnostic that
        # looks like a missing file. Export and Put are silenced for the same
        # reason and to keep a corpus run from writing 384 scripts' worth of
        # figures.
        'Unprotect[CreateDirectory, Export, Put, PutAppend]; '
        'CreateDirectory[d___] := Null; '
        'Export[f_, ___] := f; Put[___] := Null; PutAppend[___] := Null; '
        f'fsHarness = {{"fsHarness", "fsTime", "fsName", "fsEmit"}}; '
        f'fsTime = AbsoluteTiming[Get["{script.resolve()}"]][[1]]; '
        'fsEmit[fsName_] := If[ValueQ[Symbol[fsName]] && '
        '!MemberQ[fsHarness, fsName], '
        'If[Head[Symbol[fsName]] === Association, '
        'Scan[Function[fsRule, Print["R\t", ToString[First[fsRule]], "\t", '
        'ToString[InputForm[Last[fsRule]]]]], Normal[Symbol[fsName]]], '
        'Print["R\t", fsName, "\t", ToString[InputForm[Symbol[fsName]]]]]]; '
        'Scan[fsEmit, '
        'Names["Global`*"]]; '
        'Print["T\t", fsTime]'
    )
    return [*backend.command, wrapper]


def _parse_wolfram_output(stdout: str) -> tuple[dict, float]:
    results, seconds = {}, 0.0
    saw_time = False
    for line in stdout.splitlines():
        parts = line.split("\t")
        if parts[0] == "R" and len(parts) >= 3:
            results[parts[1].strip()] = "\t".join(parts[2:]).strip()
        elif parts[0] == "T" and len(parts) >= 2:
            seconds = float(parts[1].strip())
            saw_time = True
    if not saw_time:
        raise RunFailure("error", f"no results parsed from: {stdout[:200]}")
    return results, seconds
