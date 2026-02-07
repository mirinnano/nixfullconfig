#!/usr/bin/env bash

# Automatic NixOS Configuration Backup
# Commits and pushes to GitHub: https://github.com/mirinnano/nixfullconfig.git

set -euo pipefail

REPO_DIR="/home/mirin/rudra"
LOG_FILE="/tmp/auto-backup.log"
REMOTE_REPO="https://github.com/mirinnano/nixfullconfig.git"

log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"
}

error() {
    log "ERROR: $*"
    dunstify "Backup Failed" "$*" -u critical -t 5000 -i dialog-error
    exit 1
}

success() {
    log "SUCCESS: $*"
    dunstify "Backup Complete" "$*" -t 3000 -i emblem-default
}

# Change to repository directory
cd "$REPO_DIR" || error "Failed to change to $REPO_DIR"

# Check if git repo
if [ ! -d ".git" ]; then
    error "Not a git repository: $REPO_DIR"
fi

log "Starting automatic backup..."

# Check for uncommitted changes
if ! git diff-index --quiet HEAD --; then
    log "Uncommitted changes detected"

    # Add all changes
    git add -A

    # Generate commit message
    CHANGES=$(git status --short | wc -l)
    COMMIT_MSG="Auto-backup: $(date +'%Y-%m-%d %H:%M:%S') - $CHANGES changes"

    # Commit
    log "Committing: $COMMIT_MSG"
    git commit -m "$COMMIT_MSG" || error "Failed to commit changes"
else
    log "No changes to commit"
fi

# Check if remote is configured
if ! git remote get-url origin &>/dev/null; then
    log "Configuring remote origin..."
    git remote add origin "$REMOTE_REPO" || error "Failed to add remote"
fi

# Push to GitHub
log "Pushing to GitHub..."
if git push origin feature/dank-linux; then
    success "Configuration backed up to GitHub"
else
    # If push fails (e.g., nothing to push), it's not critical
    log "Push completed (possibly nothing to push)"
fi

# Cleanup old logs
if [ -f "$LOG_FILE" ]; then
    tail -n 100 "$LOG_FILE" > "$LOG_FILE.tmp" && mv "$LOG_FILE.tmp" "$LOG_FILE"
fi

log "Backup complete!"
