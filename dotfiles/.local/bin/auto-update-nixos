#!/usr/bin/env bash
# Auto-update Nix flakes and push to git

set -euo pipefail

LOG_FILE="/home/mirin/.local/state/nixos-auto-update.log"
RUDRA_DIR="/home/mirin/rudra"

mkdir -p "$(dirname "$LOG_FILE")"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"
}

log "=== Auto-update started ==="

cd "$RUDRA_DIR"

# Nix flake update
log "Running: nix flake update"
if nix flake update >> "$LOG_FILE" 2>&1; then
    log "✅ Flake update successful"
else
    log "❌ Flake update failed"
    exit 1
fi

# Git add
log "Running: git add ."
if git add . >> "$LOG_FILE" 2>&1; then
    log "✅ Git add successful"
else
    log "❌ Git add failed"
    exit 1
fi

# Check if there are changes to commit
if git diff --cached --quiet; then
    log "ℹ️  No changes to commit"
    exit 0
fi

# Generate commit message
log "Generating commit message"
COMMIT_MSG="chore: auto-update flakes and configuration

$(date '+%Y-%m-%d %H:%M:%S')
- nix flake update
- configuration changes"

# Git commit
log "Running: git commit"
if git commit -m "$COMMIT_MSG" >> "$LOG_FILE" 2>&1; then
    log "✅ Git commit successful"
else
    log "❌ Git commit failed"
    exit 1
fi

# Git push
log "Running: git push"
if git push >> "$LOG_FILE" 2>&1; then
    log "✅ Git push successful"
else
    log "❌ Git push failed"
    exit 1
fi

log "=== Auto-update completed successfully ==="
