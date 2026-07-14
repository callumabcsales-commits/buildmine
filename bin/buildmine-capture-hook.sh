#!/usr/bin/env bash
# buildmine :: PostToolUse(Bash) hook
# Deterministic backstop for capture. When Claude runs a successful `git commit`,
# this logs the commit subject as a "ship" moment automatically — so real shipped
# work is never missed even if the model forgets to capture it. No LLM involved.
#
# Always exits 0 (non-blocking). Reads the hook JSON payload from stdin.

set -uo pipefail

PLUGIN_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CAPTURE="${PLUGIN_ROOT}/bin/buildmine-capture"

# Need python3 to parse the payload; if absent, do nothing rather than error.
command -v python3 >/dev/null 2>&1 || exit 0

PAYLOAD="$(cat)"

# Emit three lines: status (OK/FAIL), the command, and the extracted -m message.
PARSED="$(printf '%s' "${PAYLOAD}" | python3 -c '
import json, re, sys
try:
    d = json.load(sys.stdin)
except Exception:
    print("FAIL"); print(""); print(""); sys.exit(0)

ti = d.get("tool_input", {}) or {}
cmd = (ti.get("command") or "").replace(chr(10), " ").replace(chr(13), " ")

resp = d.get("tool_response", d.get("tool_output", {})) or {}
ok = True
if isinstance(resp, dict) and (resp.get("success") is False or resp.get("exit_code") not in (None, 0)):
    ok = False

msg = ""
m = re.search(r"-m\s+\"([^\"]+)\"", cmd) or re.search(r"-m\s+\x27([^\x27]+)\x27", cmd)
if m:
    msg = m.group(1).strip()

print("OK" if ok else "FAIL")
print(cmd)
print(msg)
' 2>/dev/null)"

STATUS="$(printf '%s\n' "${PARSED}" | sed -n '1p')"
COMMAND="$(printf '%s\n' "${PARSED}" | sed -n '2p')"
MSG="$(printf '%s\n' "${PARSED}" | sed -n '3p')"

[ "${STATUS}" = "OK" ] || exit 0
case "${COMMAND}" in
  *"git commit"*) : ;;
  *) exit 0 ;;
esac
[ -n "${MSG}" ] || exit 0

"${CAPTURE}" --type ship --source git --text "${MSG}" --tags commit >/dev/null 2>&1 || true
exit 0
