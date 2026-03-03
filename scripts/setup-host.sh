#!/bin/bash
# Create this host's directory in the ledger repo and symlink /doledger to it.
# Run from the repo root (e.g. /doledger-repo or /opt/doledger-repo).

set -e
REPO_ROOT="${REPO_ROOT:-$(git rev-parse --show-toplevel 2>/dev/null || realpath "$(dirname "$0")/..")}"
HOST=$(hostname)
HOST_DIR="$REPO_ROOT/$HOST"

mkdir -p "$HOST_DIR/templates" "$HOST_DIR/log"

LEDGER="$HOST_DIR/ledger.md"
if [[ ! -f "$LEDGER" ]]; then
  printf '%s\n' "| Date | Task | Result |" "|------|------|--------|" "" > "$LEDGER"
fi

BASELINE="$HOST_DIR/baseline.md"
if [[ ! -f "$BASELINE" && -f "$REPO_ROOT/templates/baseline.md.example" ]]; then
  cp "$REPO_ROOT/templates/baseline.md.example" "$BASELINE"
elif [[ ! -f "$BASELINE" ]]; then
  printf '# Baseline: %s\n\nHost: %s\nRole: (edit)\nConstraints: (edit)\n' "$HOST" "$HOST" > "$BASELINE"
fi

if [[ -d /doledger && ! -L /doledger ]]; then
  echo "Warning: /doledger exists and is not a symlink. Move or remove it, then run this script again."
  exit 1
fi
ln -sfn "$HOST_DIR" /doledger
echo "Created $HOST_DIR and linked /doledger -> $HOST_DIR"
