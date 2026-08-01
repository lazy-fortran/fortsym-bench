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


BACKENDS = {
    b.name: b
    for b in (
        Backend("sympy", ".py", "srepr", is_oracle=True),
        Backend("fortsym-sympy", ".py", "srepr"),
        Backend("mathics", ".wl", "inputform", is_oracle=True,
                command=("mathics", "-q", "--no-readline", "-c")),
        Backend("fortsym-wl", ".wl", "inputform",
                command=("fortsym-wl", "-c")),
    )
}

DEFAULT_BACKENDS = ("sympy", "fortsym-sympy", "mathics", "fortsym-wl")


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
    if backend.syntax == "srepr":
        argv = [sys.executable, str(RUNNERS / "py_runner.py"), str(script), backend.name]
    else:
        argv = _wolfram_argv(backend, script)

    env = dict(os.environ, PYTHONHASHSEED="0")
    try:
        proc = subprocess.run(
            argv, capture_output=True, text=True, timeout=timeout, env=env,
            stdin=subprocess.DEVNULL,
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
        raise RunFailure(kind, stderr.splitlines()[-1] if stderr else "no output")

    if backend.syntax == "inputform":
        return _parse_wolfram_output(proc.stdout)

    try:
        payload = json.loads(proc.stdout)
    except json.JSONDecodeError:
        raise RunFailure("error", f"unparseable output: {proc.stdout[:200]}") from None

    return payload["results"], float(payload.get("seconds", 0.0))


def _wolfram_argv(backend: Backend, script: Path) -> list[str]:
    """Wrap a .wl corpus file so it prints one result per line.

    Deliberately not printing the association itself: Mathics renders ``->``
    inside an association as U+21FE, which is not the textual syntax any parser
    expects. One flat ``R<TAB>name<TAB>value`` line per result sidesteps the
    pretty-printer entirely, and keeps the corpus file free of harness noise.
    """
    wrapper = (
        f'{{fsTime, fsRes}} = AbsoluteTiming[Get["{script}"]; fortsymBenchResults]; '
        'Scan[Print["R\t", #, "\t", ToString[InputForm[fsRes[#]]]] &, Keys[fsRes]]; '
        'Print["T\t", fsTime]'
    )
    return [*backend.command, wrapper]


def _parse_wolfram_output(stdout: str) -> tuple[dict, float]:
    results, seconds = {}, 0.0
    for line in stdout.splitlines():
        parts = line.split("\t")
        if parts[0] == "R" and len(parts) >= 3:
            results[parts[1].strip()] = "\t".join(parts[2:]).strip()
        elif parts[0] == "T" and len(parts) >= 2:
            seconds = float(parts[1].strip())
    if not results:
        raise RunFailure("error", f"no results parsed from: {stdout[:200]}")
    return results, seconds
