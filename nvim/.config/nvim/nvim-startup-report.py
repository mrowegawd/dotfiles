#!/usr/bin/env python3
"""Extract and rank slow entries from `nvim --startuptime` logs.

Usage:
  python3 nvim_startup_report.py /tmp/nvim-startup.log
  python3 nvim_startup_report.py /tmp/nvim-startup.log --top 30
  python3 nvim_startup_report.py /tmp/nvim-startup.log --min-ms 2
  python3 nvim_startup_report.py /tmp/nvim-startup.log --group

This uses only Python's standard library.
"""
from __future__ import annotations

import argparse
import re
from collections import defaultdict
from pathlib import Path

SECTION_RE = re.compile(r"--- Startup times for process:\s*(.*?)\s*---")
# Typical lines:
# 140.086  026.339  023.699: sourcing /path/to/file.lua
# 144.861  004.369: loading rtp plugins
ENTRY_RE = re.compile(
    r"^\s*(?P<clock>\d+(?:\.\d+)?)\s+"
    r"(?P<elapsed>\d+(?:\.\d+)?)"
    r"(?:\s+(?P<self>\d+(?:\.\d+)?))?:\s*(?P<desc>.*?)\s*$"
)


def parse_log(path: Path):
    section = "(unknown process)"
    entries = []

    for line_no, line in enumerate(
        path.read_text(encoding="utf-8", errors="replace").splitlines(), 1
    ):
        section_match = SECTION_RE.search(line)
        if section_match:
            section = section_match.group(1).strip()
            continue

        match = ENTRY_RE.match(line)
        if not match:
            continue

        elapsed = float(match.group("elapsed"))
        self_time = match.group("self")
        entries.append({
            "section": section,
            "line": line_no,
            "clock": float(match.group("clock")),
            "elapsed": elapsed,
            "self": float(self_time) if self_time is not None else None,
            "desc": match.group("desc"),
        })

    return entries


def print_entries(entries, top: int, min_ms: float):
    selected = [e for e in entries if e["elapsed"] >= min_ms]
    selected.sort(key=lambda e: e["elapsed"], reverse=True)

    if not selected:
        print(f"No entries found with elapsed >= {min_ms:.3f} ms.")
        return

    print(f"\nSlowest {min(top, len(selected))} entries (elapsed time):")
    print(f"{'ms':>9} {'self ms':>9} {'process':<10} {'line':>6}  entry")
    print("-" * 100)
    for e in selected[:top]:
        self_text = f"{e['self']:.3f}" if e["self"] is not None else "-"
        print(
            f"{e['elapsed']:9.3f} {self_text:>9} "
            f"{e['section'][:10]:<10} {e['line']:6d}  {e['desc']}"
        )


def print_grouped(entries, top: int, min_ms: float):
    # Group exact descriptions. Keep max elapsed instead of summing because
    # startup entries can be nested and summing can double-count time.
    groups = defaultdict(list)
    for e in entries:
        if e["elapsed"] >= min_ms:
            groups[e["desc"]].append(e)

    ranked = sorted(
        groups.items(),
        key=lambda item: max(e["elapsed"] for e in item[1]),
        reverse=True,
    )

    print(f"\nSlowest {min(top, len(ranked))} unique entries (grouped by description):")
    print(f"{'max ms':>9} {'runs':>5} {'processes':<22}  entry")
    print("-" * 100)
    for desc, items in ranked[:top]:
        max_ms = max(e["elapsed"] for e in items)
        processes = ",".join(sorted({e["section"] for e in items}))
        print(f"{max_ms:9.3f} {len(items):5d} {processes[:22]:<22}  {desc}")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("logfile", type=Path, help="file produced by nvim --startuptime")
    parser.add_argument("--top", type=int, default=25, help="number of entries to show (default: 25)")
    parser.add_argument("--min-ms", type=float, default=0.5, help="minimum elapsed time in ms (default: 0.5)")
    parser.add_argument(
        "--group", action="store_true",
        help="group identical descriptions; show the maximum time, not a sum",
    )
    args = parser.parse_args()

    if not args.logfile.is_file():
        parser.error(f"file not found: {args.logfile}")

    entries = parse_log(args.logfile)
    if not entries:
        parser.error("no startup entries parsed; check that this is an nvim --startuptime log")

    print(f"Parsed {len(entries)} entries from {args.logfile}")
    if args.group:
        print_grouped(entries, args.top, args.min_ms)
    else:
        print_entries(entries, args.top, args.min_ms)

    print(
        "\nNote: elapsed values can include nested work. Do not add all elapsed "
        "values together; use them to identify candidates for profiling."
    )


if __name__ == "__main__":
    main()
