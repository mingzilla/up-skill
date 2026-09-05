#!/usr/bin/env bash
# upskill__home.sh - print the /upskill home screen: every address book, who is in each (with
# skill counts when their repo is on this machine), which one is current, and the three actions.
# Read-only. The upskill entry skill prints this output verbatim, then acts on the user's pick.
#
# Console layout (measured widths, no wrapping guesswork):
#   team name  <=17 chars, then " *" marks the current team (2 chars) = 19, padded to 20
#   people count right-aligned in 2 chars, then 2 spaces
#   each member token "<count>:<name>" <=14 chars (overflow hidden), 1 space between tokens,
#   3 tokens per row, continuation rows indented under the Members column
#
# usage: bash upskill__home.sh     (run from the workspace, or set UP_SKILL_WORKSPACE)
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# the sibling receive skill ships the workspace-resolution lib; both skills install together
LIB="$SCRIPT_DIR/../../upskill__action__receive-skills/scripts/upskill__sharing__lib.sh"
if [[ ! -f "$LIB" ]]; then
  echo "error: upskill__action__receive-skills lib not found next to this skill (expected $LIB)" >&2
  exit 1
fi
# shellcheck source=../../upskill__action__receive-skills/scripts/upskill__sharing__lib.sh
source "$LIB"

us_init "${UP_SKILL_WORKSPACE:-$PWD}"

python3 - "$US_WORKSPACE" "$US_TEAM" <<'PY'
import glob
import json
import os
import sys

ws, current = sys.argv[1], sys.argv[2]
base = os.path.join(ws, "address_books")

NAME_MAX, TOKEN_W, TEAM_W, PEOPLE_W, PER_ROW = 17, 14, 20, 2, 3
rows = []            # (sort_current, sort_alpha, cell, people, tokens)

if os.path.isdir(base):
    for team in sorted(os.listdir(base)):
        td = os.path.join(base, team)
        if not os.path.isdir(td):
            continue
        cand = glob.glob(os.path.join(td, "*", "address_book.json"))
        if not cand:
            continue
        try:
            users = json.load(open(cand[0])).get("users", {})
        except Exception:
            continue
        label = (team[6:] if team.startswith("team__") else team)[:NAME_MAX]
        tokens = []
        for name, m in users.items():
            folder = m.get("folder", "") if isinstance(m, dict) else ""
            clone = os.path.join(td, folder) if folder else ""
            count = 0
            has_clone = os.path.isdir(clone)
            if has_clone:
                for sub in os.listdir(clone):
                    if os.path.isdir(os.path.join(clone, sub)) and \
                            os.path.isfile(os.path.join(clone, sub, "SKILL.md")):
                        count += 1
            # cloned repo -> "count:name" (0 is real); no local clone -> name only (unknown)
            token = (f"{count}:{name}" if has_clone else name)[:TOKEN_W]
            tokens.append(token)
        cell = label + (" *" if team == current else "")
        rows.append((0 if team == current else 1, label.lower(), cell, len(users), tokens))

print("Address Books       NN  Members")
print("-" * 70)
if not rows:
    print("(no address books installed - add one to get started)")
else:
    rows.sort(key=lambda r: (r[0], r[1]))
    cont = " " * (TEAM_W + PEOPLE_W + 2)   # indent continuation member rows under Members
    for _, _, cell, people, tokens in rows:
        line = f"{cell:<{TEAM_W}}{people:>{PEOPLE_W}}  "
        for i in range(0, len(tokens), PER_ROW):
            seg = " ".join(f"{t:<{TOKEN_W}}" for t in tokens[i:i + PER_ROW])
            if i == 0:
                print(line + seg)
            else:
                print(cont + seg)
        if not tokens:
            print(line.rstrip())
PY

echo
echo "What can you do?"
echo "  1  Add or change address book"
echo "  2  Show someone's skills  ->  add a skill to your project"
echo "  3  Share one of your skills"
