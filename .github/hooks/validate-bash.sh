#!/usr/bin/env bash
#
# validate-bash.sh — Garde-fou basique appelé par le hook natif Copilot CLI
# "preToolUse" (voir .github/hooks/validate-bash.json) avant l'exécution
# d'un outil shell/bash.
#
# Le hook reçoit en entrée (stdin) un JSON décrivant l'appel d'outil
# (nom de l'outil, arguments). Ce script :
#   - ignore silencieusement les outils qui ne sont pas des exécutions shell,
#   - bloque les commandes correspondant à un motif dangereux en répondant
#     {"permissionDecision":"deny","permissionDecisionReason":"..."} sur
#     stdout,
#   - laisse passer tout le reste (aucune sortie / sortie vide = autorisé).
#
# NB : le contrat exact d'entrée/sortie des hooks "command" n'est pas
# publiquement documenté en détail ; ce script reste volontairement
# défensif (scan texte brut) plutôt que de dépendre d'un schéma JSON précis.

set -euo pipefail

INPUT="$(cat || true)"

# Ne réagir que si l'appel semble concerner un outil shell/bash.
if ! echo "${INPUT}" | grep -Eiq '"toolName"\s*:\s*"(bash|shell|execute)"'; then
  exit 0
fi

UPPER_INPUT=$(echo "${INPUT}" | tr '[:lower:]' '[:upper:]')

# Motifs interdits (insensible à la casse) : commandes destructrices,
# DDL/DML Oracle, exfiltration, modification de permissions critiques, etc.
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
  'DELETE[[:space:]]+FROM'
  'INSERT[[:space:]]+INTO'
  'UPDATE[[:space:]]+.*SET'
  'ALTER[[:space:]]+(TABLE|DATABASE|SYSTEM)'
  'GRANT[[:space:]]+'
  'REVOKE[[:space:]]+'
  'SHUTDOWN[[:space:]]'
  'REBOOT\b'
)

for pattern in "${DENY_PATTERNS[@]}"; do
  if echo "${UPPER_INPUT}" | grep -Eq "${pattern}"; then
    printf '{"permissionDecision":"deny","permissionDecisionReason":"Commande refusée par validate-bash.sh (motif interdit détecté: %s)."}\n' "${pattern}"
    exit 0
  fi
done

exit 0
