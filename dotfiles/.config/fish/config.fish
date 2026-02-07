# ==========================================
# Fish Shell Configuration
# ==========================================

# ==========================================
# Environment Variables
# ==========================================

# PNPM
set -gx PNPM_HOME "/home/mirin/.local/share/pnpm"
set -gx PATH $PNPM_HOME $PATH

# XDG Base Directory
set -gx XDG_DATA_HOME "$HOME/.local/share"
set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_STATE_HOME "$HOME/.local/state"
set -gx XDG_CACHE_HOME "$HOME/.cache"

# ==========================================
# Essential Abbreviations (Fast Startup)
# ==========================================

# Directory navigation
abbr .. 'cd ..'
abbr ... 'cd ../..'
abbr .3 'cd ../../..'

# File operations
abbr l 'eza -lh --icons=auto'
abbr ll 'eza -lha --icons=auto --group-directories-first'
abbr cat 'bat'
abbr c 'clear'
abbr e 'exit'
abbr v 'nvim'

# Git - most used
abbr gs 'git status'
abbr ga 'git add'
abbr gc 'git commit -m'
abbr gpush 'git push'
abbr gpull 'git pull'
abbr lg 'lazygit'

# tmux - most used
abbr t 'tmux'
abbr ta 'tmux attach -t'
abbr tls 'tmux ls'
abbr tn 'tmux new-session -s'

# Development
abbr dev '~/rudra/scripts/tmux-dev-layout.sh'
abbr rebuild 'sudo nixos-rebuild switch --flake ~/rudra#summerpockets'

# Claude Code
abbr cc 'claude'
abbr c-continue 'claude -c'
abbr cm 'claude --dangerously-skip-permissions'

# System
abbr ssn 'sudo shutdown now'
abbr srn 'sudo reboot now'

# ==========================================
# Load Extended Abbreviations (Lazy Load)
# ==========================================

function load_extended_abbr --description 'Load extended abbreviations'
    # Git extended
    abbr gaa 'git add .'
    abbr gac 'git add . && git commit -m'
    abbr gco 'git checkout'
    abbr gcob 'git checkout -b'
    abbr glog 'git log --oneline --graph --all'

    # tmux extended
    abbr tk 'tmux kill-session -t'
    abbr tkill 'tmux kill-server'

    # Docker
    abbr dps 'docker ps'
    abbr di 'docker images'

    # systemctl
    abbr scs 'systemctl status'
    abbr scr 'systemctl restart'
end

# Create command to load extended abbreviations
abbr load-abbr 'load_extended_abbr'

# ==========================================
# History & Variables
# ==========================================

# Use global variables instead of universal to avoid /nix/store writes
set -g fish_history_max_file 100000
set -g fish_history_max_size 100000

# Disable universal variables completely
set -g fish_features no-implicit-universal-variables

# ==========================================
# Key Bindings
# ==========================================

# Vim mode
fish_vi_key_bindings

# ==========================================
# Colors & Theme
# ==========================================

# Starship prompt
if type -q starship
    starship init fish | source
end

# ==========================================
# Functions
# ==========================================

# mkcd - mkdir and cd
function mkcd
    mkdir -p $argv[1] && cd $argv[1]
end

# ==========================================
# User-specific paths
# ==========================================

# Add local bin to PATH if exists
if test -d "$HOME/.local/bin"
    set -gx PATH "$HOME/.local/bin" $PATH
end

# Add cargo bin to PATH if exists
if test -d "$HOME/.cargo/bin"
    set -gx PATH "$HOME/.cargo/bin" $PATH
end

# Add rudra scripts to PATH if exists
if test -d "$HOME/rudra/scripts"
    set -gx PATH "$HOME/rudra/scripts" $PATH
end

# ==========================================
# Optimizations
# ==========================================

# Disable greeting (use global, not universal)
set -g fish_greeting

# Better tab completion (global, not universal)
set -g fish_autosuggestion_enabled 1

# Syntax highlighting colors (global, not universal)
set -g fish_color_autosuggestion brblack
set -g fish_color_command brgreen
set -g fish_color_error red
set -g fish_color_param cyan
