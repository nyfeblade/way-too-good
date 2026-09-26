#!/usr/bin/env bash
# Gate checker for the way-too-good pipeline: reports PASS/MISSING per stage artifact.
# Usage: check-gates.sh <project-root> <topic>
# Every location is configurable; set the ones your project uses (defaults shown):
#   WTG_DECISIONS   decision log                 docs/decisions.md
#   WTG_RESEARCH    research folder              research/<topic>
#   WTG_SPEC        spec file glob               docs/spec/*spec*.md
#   WTG_TRACE       traceability map             docs/spec/ui-engine-traceability.md
#   WTG_FINDINGS    Phase 0 findings             docs/spec/phase0-findings.md
#   WTG_QA          QA harness glob              .claude/skills/*fuzz*/SKILL.md
#   WTG_PLANS       plan file glob               docs/plans/*.md
#   WTG_LEDGER      build ledger glob            .superpowers/sdd/*/progress.md
root="${1:?project root}"; topic="${2:?topic (names the research folder)}"
cd "$root" || exit 1
DEC="${WTG_DECISIONS:-docs/decisions.md}"
RES="${WTG_RESEARCH:-research/$topic}"
SPEC="${WTG_SPEC:-docs/spec/*spec*.md}"
TRACE="${WTG_TRACE:-docs/spec/ui-engine-traceability.md}"
FIND="${WTG_FINDINGS:-docs/spec/phase0-findings.md}"
QA="${WTG_QA:-.claude/skills/*fuzz*/SKILL.md}"
PLANS="${WTG_PLANS:-docs/plans/*.md}"
LEDGER="${WTG_LEDGER:-.superpowers/sdd/*/progress.md}"
echo "(Fast/Standard depth: MISSING rows for stages 2-8 can be expected; check the scale in $DEC)"
has() { compgen -G "$1" >/dev/null; }
row() { printf "%-4s %-28s %s\n" "$1" "$2" "$3"; }
check() { local n="$1" name="$2"; shift 2; for g in "$@"; do has "$g" || { row "$n" "$name" "MISSING  ($g)"; return; }; done; row "$n" "$name" "PASS"; }
check 1  "decision log"           "$DEC"
check 2  "research 01-04"         "$RES/01-*.md" "$RES/02-*.md" "$RES/03-*.md" "$RES/04-*.md"
check 3  "internals + archive"    "$RES/05-*.md" "$RES/sources/INDEX.md"
check 4  "ground truth"           "$RES/06-*.md"
check 5  "spec"                   "$SPEC"
if has "$SPEC" && grep -qiE 'original design' $SPEC; then row 6 "gap engineering" PASS; else row 6 "gap engineering" "MISSING  (Original designs section in the spec)"; fi
row 7 "mockup (user approval)" "MANUAL   (confirm the user approved the design)"
if has "$TRACE"; then
  m=$(grep -cE '\| *MISSING *\| *$' "$TRACE"); [ "$m" = 0 ] && row 8 "traceability" PASS || row 8 "traceability" "FAIL     ($m MISSING rows)"
else row 8 "traceability" "MISSING  ($TRACE)"; fi
check 9  "phase 0 findings"       "$FIND"
check 10 "QA harness"             "$QA"
if has "$PLANS"; then
  p=$(grep -liE '\bTBD\b|\bTODO\b|similar to task' $PLANS | wc -l | tr -d ' ')
  row 11 "phase plan(s)" "$([ "$p" = 0 ] && echo PASS || echo "CHECK    ($p plan files mention TBD/TODO: inspect)")"
else row 11 "phase plan(s)" "MISSING  ($PLANS)"; fi
if has "$LEDGER"; then
  row 12 "build ledger" "PASS     ($(cat $LEDGER | grep -cE '^Task [0-9]+: complete') tasks complete)"
else row 12 "build ledger" "MISSING  ($LEDGER)"; fi
