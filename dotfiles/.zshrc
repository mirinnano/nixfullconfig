# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
    mkdir -p "$(dirname "$ZINIT_HOME")"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Load completions
autoload -Uz compinit && compinit

# Add in zsh plugins
zinit light Aloxaf/fzf-tab
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions


# Add in snippets
zinit snippet OMZP::git
zinit snippet OMZP::sudo

zinit cdreplay -q

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region

# History
HISTSIZE=500000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza $realpath'

# Handy change dir shortcuts
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'

# Core Utils Aliases
alias l='eza -lh  --icons=auto'
alias ls='eza -1   --icons=auto' # short list
alias ll='eza -lha --icons=auto --sort=name --group-directories-first' # long list all
alias ldir='eza -lhD --icons=auto' # long list dirs (renamed from ld to avoid conflict)
alias mkdir='mkdir -p'
# aliao ssh='kitten ssh'
alias tree='tree -a -I .git'
alias cat='bat'
alias c='clear' # clear terminal
alias e='exit'
alias vim='nvim'
alias v='nvim'
alias grep='rg --color=auto'
alias ssn='sudo shutdown now'
alias srn='sudo reboot now'

# Git Aliases
alias gac='git add . && git commit -m'
alias gs='git status'
alias gpush='git push origin'
alias lg='lazygit'

# tmux Aliases
alias t='tmux'
alias ta='tmux attach -t'
alias tl='tmux list-sessions'
alias tn='tmux new-session -s'
alias tk='tmux kill-session -t'
alias tls='tmux ls'
alias tkill='tmux kill-server'
alias tsave='tmux save-buffer -'

# Development Environment Layouts
alias dev='~/rudra/scripts/tmux-dev-layout.sh'
alias nixdev='~/rudra/scripts/tmux-dev-layout.sh nixos ~/rudra'
alias dev-claude='~/rudra/scripts/tmux-dev-layout.sh claude'
alias dev-claude-main='~/rudra/scripts/tmux-dev-layout.sh claude-main'
alias dev-git='~/rudra/scripts/tmux-dev-layout.sh git'

# Claude Code Repository Layout (Claude-First Philosophy)
# パス指定なしでカレントディレクトリを使用
alias repo='~/rudra/scripts/tmux-dev-layout.sh'

# 使用例:
# repo myproject claude-repo           # カレントディレクトリでレポジトリ作成
# repo myproject                       # デフォルトclaude-repoレイアウト
# repo myproject /path/to/project code # パス指定も可能

# Repository/Session Management
alias repos='tmux ls -F "#{session_name}"'           # レポジトリリスト表示
alias dev-list='~/rudra/scripts/tmux-dev-layout.sh --list'  # 美しいレポジトリリスト
alias dev-attach='tmux attach-session -t'             # レポジトリにアタッチ
alias dev-kill='tmux kill-session -t'                 # レポジトリを削除

# Interactive (fzfがある場合)
if command -v fzf &> /dev/null; then
    alias dev-interactive='tmux ls -F "#{session_name}" | fzf --preview "tmux lsw -t {} -F "#{window_name}: #{pane_current_command}" | head -5" | xargs -r tmux attach-session -t'
fi

# Claude Code aliases
alias c='claude'
alias cc='claude'
alias c-continue='claude -c'                    # 前回の会話を継続
alias c-muso='claude --dangerously-skip-permissions'  # 無双モード
alias cm='claude --dangerously-skip-permissions'      # 無双モード（短縮）
alias ccm='claude -c --dangerously-skip-permissions' # 継続+無双

# 使用例:
# c -c "この関数をリファクタリングして"         # 新規会話
# c-continue "続きから"                        # 前回の会話を継続
# c-muso "全ファイル書き換えて"                 # 無双モード
# cm "許可なしで実行"                          # 無双モード（短縮）
# ccm "続きで無双"                             # 継続+無双

# Nixos Aliases
alias rebuild='sudo nixos-rebuild switch --flake ~/rudra/.#default'
alias recats='sudo nix flake lock --update-input nixCats && sudo nixos-rebuild switch --flake ~/rudra/.#default'

# Downloads Aliases
alias yd='yt-dlp -f "bestvideo+bestaudio" --embed-chapters --external-downloader aria2c --concurrent-fragments 8 --throttled-rate 100K'
alias td='yt-dlp --external-downloader aria2c -o "%(title)s."'
alias download='aria2c --split=16 --max-connection-per-server=16 --timeout=600 --max-download-limit=10M --file-allocation=none'

# VPN Aliases
alias vu='sudo tailscale up --exit-node=raspberrypi --accept-routes'
alias vd='sudo tailscale down'
warp ()
{
    sudo systemctl "$1" warp-svc
}

# Other Aliases
alias apps-space='expac -H M "%011m\t%-20n\t%10d" $(comm -23 <(pacman -Qqe | sort) <(pacman -Qqg base base-devel | sort)) | sort -n'
alias files-space='sudo ncdu --exclude /.snapshots /'
# ld conflicts with ldir - using lazydocker directly or create specific alias
alias dock='lazydocker'
alias docker-clean='docker container prune -f && docker image prune -f && docker network prune -f && docker volume prune -f'
alias crdown='mpv --yt-dlp-raw-options=cookies-from-browser=brave'
alias cr='cargo run'
alias battery='upower -i /org/freedesktop/UPower/devices/battery_BAT1'
alias y='yazi'
lsfind ()
{
    ll "$1" | grep "$2"
}

# X11 Clipboard Aliases `xsel`
# alias pbcopy='xsel --input --clipboard'
# alias pbpaste='xsel --output --clipboard'

# Wayland Clipboard Aliases `wl-clipboard`
alias pbcopy='wl-copy'
alias pbpaste='wl-paste'


# Shell Intergrations
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"
eval "$(starship init zsh)"
eval "$(fnm env --use-on-cd)"


# Export Paths

# pnpm
export PNPM_HOME="/home/mirin/.local/share/pnpm"
case ":$PATH:" in
    *":$PNPM_HOME:"*) ;;
    *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# Cargo Bin
export PATH="$HOME/.cargo/bin:$PATH"

# Local Bin
export PATH="$HOME/.local/bin:$PATH"

# Android Studio Paths
# export JAVA_HOME="/opt/android-studio/jbr"
# export ANDROID_HOME="$HOME/Android/Sdk"
# export NDK_HOME="$ANDROID_HOME/ndk/$(ls -1 $ANDROID_HOME/ndk)"

# Turso
# export PATH="$PATH:/home/vasu/.turso"  # Uncommented - incorrect user path

source "$HOME/.sdkman/bin/sdkman-init.sh"

# ===============================
# Advanced Development Aliases
# ===============================

# Git advanced
alias gaa='git add --all'
alias gcm='git commit -m'
alias gcam='git commit -am'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gpl='git pull'
alias gps='git push'
alias gst='git status -sb'
alias glog='git log --oneline --decorate --graph --all'
alias gdiff='git diff --color-words'
alias gundo='git reset --soft HEAD~1'

# Docker shortcuts
alias dps='docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'
alias dimg='docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}"'
alias dstop='docker stop $(docker ps -q)'
alias drm='docker rm $(docker ps -aq)'
alias drmi='docker rmi $(docker images -q)'
alias dlog='docker logs -f'

# NixOS shortcuts
alias nrs='sudo nixos-rebuild switch --flake ~/rudra#summerpockets'
alias nrb='sudo nixos-rebuild boot --flake ~/rudra#summerpockets'
alias nrt='sudo nixos-rebuild test --flake ~/rudra#summerpockets'
alias nfu='nix flake update'
alias ngc='sudo nix-collect-garbage -d'
alias hms='home-manager switch --flake ~/rudra#mirin'

# System monitoring
alias meminfo='free -h'
alias cpuinfo='lscpu'
alias diskinfo='df -h'
alias ports='ss -tulpn'
alias psgrep='ps aux | grep -v grep | grep -i -e VSZ -e'

# Quick edits
alias zshrc='nvim ~/.zshrc && source ~/.zshrc'
alias hyprconf='nvim ~/.config/hypr/hyprland.conf'
alias hyprkeys='nvim ~/.config/hypr/keybindings.conf'
alias nixconf='cd ~/rudra && nvim hosts/summerpockets/configuration.nix'

# ===============================
# Useful Functions
# ===============================

# Extract any archive
extract() {
    if [ -f "$1" ] ; then
        case "$1" in
            *.tar.bz2)   tar xjf "$1"     ;;
            *.tar.gz)    tar xzf "$1"     ;;
            *.bz2)       bunzip2 "$1"     ;;
            *.rar)       unrar x "$1"     ;;
            *.gz)        gunzip "$1"      ;;
            *.tar)       tar xf "$1"      ;;
            *.tbz2)      tar xjf "$1"     ;;
            *.tgz)       tar xzf "$1"     ;;
            *.zip)       unzip "$1"       ;;
            *.Z)         uncompress "$1"  ;;
            *.7z)        7z x "$1"        ;;
            *)           echo "'$1' cannot be extracted" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Create directory and cd into it
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Find and kill process by name
killp() {
    ps aux | grep "$1" | grep -v grep | awk '{print $2}' | xargs kill -9
}

# Git commit with Co-Authored-By
gcco() {
    git commit -m "$1

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>"
}

# Quick Python HTTP server
serve() {
    python3 -m http.server "${1:-8000}"
}

# Show largest files/dirs
largest() {
    du -ah "${1:-.}" | sort -rh | head -n "${2:-20}"
}

# Port check
portcheck() {
    sudo ss -tulpn | grep ":$1"
}

# Git branch cleanup
gbclean() {
    git branch --merged | grep -v "\*" | grep -v "main" | grep -v "master" | xargs -n 1 git branch -d
}

# System update shortcut
update() {
    echo "Updating NixOS..."
    nix flake update ~/rudra
    sudo nixos-rebuild switch --flake ~/rudra#summerpockets
}

# Quick backup
backup() {
    tar -czf "${1%/}_$(date +%Y%m%d_%H%M%S).tar.gz" "$1"
}

# Man pages with colors
man() {
    LESS_TERMCAP_md=$'\e[01;31m' \
    LESS_TERMCAP_me=$'\e[0m' \
    LESS_TERMCAP_se=$'\e[0m' \
    LESS_TERMCAP_so=$'\e[01;44;33m' \
    LESS_TERMCAP_ue=$'\e[0m' \
    LESS_TERMCAP_us=$'\e[01;32m' \
    command man "$@"
}
