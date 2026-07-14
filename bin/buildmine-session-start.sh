#!/usr/bin/env bash
# buildmine :: SessionStart hook
# Injects a small, standing instruction so Claude captures build "moments" to the
# journal the same way it saves memory snippets — silently, in the background, as
# they happen. This is what makes capture feel automatic without a token-heavy
# generation pass on every turn.

set -euo pipefail

PLUGIN_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
JOURNAL_DIR=".claude/buildmine"
JOURNAL="${JOURNAL_DIR}/journal.jsonl"

mkdir -p "${JOURNAL_DIR}/drafts" 2>/dev/null || true

# How many moments are banked and not yet turned into drafts?
moment_count=0
if [ -f "${JOURNAL}" ]; then
  moment_count=$(grep -c '"text"' "${JOURNAL}" 2>/dev/null || echo 0)
fi

read -r -d '' CONTEXT <<EOF || true
[buildmine is active]

Throughout this session, quietly capture build-in-public "moments" to the buildmine journal — the same way you save memory snippets: in the background, without announcing it, without asking permission each time. Capture a moment the instant one of these happens:

- a bug or blocker is overcome ("type": "win")
- a feature, fix, or change ships / is committed / is deployed ("type": "ship")
- a milestone is reached — first user, launch, metric hit ("type": "milestone")
- a non-obvious insight, decision, or lesson emerges ("type": "insight")
- a real struggle worth showing honestly ("type": "struggle")

To capture one, run:
  ${PLUGIN_ROOT}/bin/buildmine-capture --type <win|ship|milestone|insight|struggle> --text "one crisp sentence, first person, concrete" [--tags a,b]

Keep each moment short, specific, and honest — it is raw material for a future post, not the post itself. Do NOT generate posts automatically. When the user wants drafts they will run /buildmine. There are currently ${moment_count} moment(s) banked. If the count is high (~8+) and a natural pause occurs, you may briefly mention they can run /buildmine to turn recent progress into drafts — mention once, do not nag.
EOF

# Emit as additionalContext for the SessionStart hook.
cat <<JSON
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": $(printf '%s' "${CONTEXT}" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read()))')
  }
}
JSON
