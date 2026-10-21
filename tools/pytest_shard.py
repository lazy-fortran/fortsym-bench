"""Run a deterministic, disjoint shard of the complete pytest file inventory."""
from __future__ import annotations
import argparse
from pathlib import Path
import subprocess
import sys


INTEGRATION = frozenset(('test/test_wl_to_fortran.py',
                         'test/test_wl_to_fortran_v99.py',
                         'test/test_fortran_inventory_adapter.py'))


def inventory(root: Path) -> list[str]:
    return sorted(str(p.relative_to(root)) for directory in ('test', 'tests')
                  for p in (root / directory).rglob('test_*.py'))


def partition(files: list[str], count: int) -> list[list[str]]:
    if count < 1:
        raise ValueError('shard count must be positive')
    return [files[i::count] for i in range(count)]


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--shard', type=int)
    parser.add_argument('--integration', action='store_true')
    parser.add_argument('--count', type=int, default=32)
    parser.add_argument('--junitxml')
    args = parser.parse_args()
    root = Path(__file__).resolve().parents[1]
    files = inventory(root)
    if args.integration:
        selected = [p for p in files if p in INTEGRATION]
    else:
        if args.shard is None or not 0 <= args.shard < args.count:
            parser.error('shard must be in [0, count)')
        shards = partition([p for p in files if p not in INTEGRATION], args.count)
        selected = shards[args.shard]
    if not selected:
        parser.error('empty test shard; reduce shard count')
    print(f'selected {len(selected)}/{len(files)} files', flush=True)
    command = [sys.executable, '-m', 'pytest', '-q', '--durations=10']
    if args.junitxml:
        command += ['--junitxml', args.junitxml]
    return subprocess.call(command + selected, cwd=root)


if __name__ == '__main__':
    raise SystemExit(main())
