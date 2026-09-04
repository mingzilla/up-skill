#!/usr/bin/env bash
# _push_to_prod.sh - release the code on main to the prod branch and push it.
#
# Run this when you are happy with the code: it refuses if work is uncommitted,
# pushes main, then sets prod to that same commit. prod only ever advances this way.
set -euo pipefail

cd "$(dirname "$0")"

# refuse if there is uncommitted work on the current branch
if ! git diff --quiet || ! git diff --cached --quiet; then
  echo "error: uncommitted changes - commit or stash them first" >&2
  exit 1
fi

if [[ "$(git branch --show-current)" != "main" ]]; then
  echo "error: run this from the main branch" >&2
  exit 1
fi

git fetch origin

echo "-- pushing main"
git push origin main

echo "-- updating prod = main"
git push origin origin/main:refs/heads/prod

echo "prod updated to $(git rev-parse --short origin/main)"
