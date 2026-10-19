#!/usr/bin/env bash
#
# validate-bash.sh — Basic safeguard called by the native Copilot CLI
# "preToolUse" hook (see .github/hooks/validate-bash.json) before a
# shell/bash tool is executed.
#
# The hook receives (on stdin) a JSON describing the tool call
# (tool name, arguments). This script:
#   - silently ignores tools that are not shell executions,
#   - blocks commands matching a dangerous pattern by replying
#     {"permissionDecision":"deny","permissionDecisionReason":"..."} on
#     stdout,
#   - lets everything else through (no output / empty output = allowed).
#
# NB: the exact input/output contract of "command" hooks is not publicly
# documented in detail; this script is deliberately defensive (raw text
# scan) rather than depending on a precise JSON schema.

set -euo pipefail

INPUT="$(cat || true)"

# Only react if the call appears to concern a shell/bash tool.
if ! echo "${INPUT}" | grep -Eiq '"toolName"\s*:\s*"(bash|shell|execute)"'; then
  exit 0
fi

UPPER_INPUT=$(echo "${INPUT}" | tr '[:lower:]' '[:upper:]')

# Forbidden patterns (case-insensitive): destructive commands,
# Oracle DDL (schema changes; data CRUD is allowed), exfiltration, critical permission changes, etc.
DENY_PATTERNS=(
  'RM[[:space:]]+-RF[[:space:]]+/'
  'RM[[:space:]]+-RF[[:space:]]+\*'
  'MKFS\.'
  'DD[[:space:]]+IF='
  'CHMOD[[:space:]]+-R[[:space:]]+777'
  'CHOWN[[:space:]]+-R[[:space:]]+ROOT'
  'CURL[^|]*\|[[:space:]]*SH'
  'WGET[^|]*\|[[:space:]]*SH'
  'DROP[[:space:]]+(TABLE|DATABASE|SCHEMA|USER)'
  'TRUNCATE[[:space:]]+TABLE'
  'ALTER[[:space:]]+(TABLE|DATABASE|SYSTEM)'
  'CREATE[[:space:]]+(TABLE|INDEX|VIEW|SEQUENCE)'
  'GRANT[[:space:]]+'
  'REVOKE[[:space:]]+'
  'SHUTDOWN[[:space:]]'
  'REBOOT\b'
)

for pattern in "${DENY_PATTERNS[@]}"; do
  if echo "${UPPER_INPUT}" | grep -Eq "${pattern}"; then
    printf '{"permissionDecision":"deny","permissionDecisionReason":"Command denied by validate-bash.sh (forbidden pattern detected: %s)."}\n' "${pattern}"
    exit 0
  fi
done

exit 0
