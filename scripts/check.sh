#!/usr/bin/env bash
# Validate skill frontmatter and that generated harness files match it.
set -euo pipefail
root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
if ! command -v python3 >/dev/null 2>&1; then
  echo "python3 is required." >&2
  exit 1
fi
exec python3 "$root/scripts/wtg_skills.py" check "$@"
