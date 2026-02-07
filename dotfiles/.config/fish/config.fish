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
# History
# ==========================================

set -g fish_history_max_file 100000
set -g fish_history_max_size 100000

# ==========================================
# Abbreviations (Fishの高度なエイリアス)
# 展開するにはTabまたはSpaceを押してください
# ==========================================

# ==========================================
# ディレクトリ操作 / Directory Operations
# ==========================================
abbr .. 'cd ..'                                    # 親ディレクトリへ移動
abbr ... 'cd ../..'                                 # 2階層上へ移動
abbr .3 'cd ../../..'                               # 3階層上へ移動
abbr .4 'cd ../../../..'                            # 4階層上へ移動
abbr .5 'cd ../../../../..'                         # 5階層上へ移動
abbr -- - 'cd -'                                    # 前のディレクトリへ戻る

# ==========================================
# ファイル操作 / File Operations
# ==========================================
abbr l 'eza -lh --icons=auto'                       # 詳細リスト表示
abbr ls 'eza -1 --icons=auto'                       # 1列表示
abbr ll 'eza -lha --icons=auto --sort=name --group-directories-first'  # 隠しファイル含む全表示
abbr la 'eza -la --icons=auto'                      # 隠しファイル含む表示
abbr lt 'eza -lh --icons=auto --tree'               # ツリー表示
abbr ldir 'eza -lhD --icons=auto'                   # ディレクトリのみ表示
abbr lsize 'eza -lhSr --icons=auto'                 # サイズ順ソート

# 基本コマンド強化
abbr mkdir 'mkdir -p'                               # ディレクトリ作成（親ディレクトリも）
abbr tree 'tree -a -I .git'                         # ツリー表示（.git除外）
abbr cat 'bat'                                      # シンタックスハイライト付きcat
abbr rm 'rm -i'                                     # 削除前に確認
abbr cp 'cp -i'                                     # 上書き前に確認
abbr mv 'mv -i'                                     # 移動前に確認
abbr df 'df -h'                                     # ディスク容量（読みやすい形式）
abbr du 'du -sh'                                    # ディレクトリサイズ
abbr dus 'du -sh * | sort -h'                       # サイズ順でディスク使用量表示
abbr free 'free -h'                                 # メモリ使用量
abbr top 'btop'                                     # btopでシステム監視
abbr htop 'btop'                                    # btopでシステム監視

# ==========================================
# システム操作 / System Operations
# ==========================================
abbr ssn 'sudo shutdown now'                        # 今すぐシャットダウン
abbr srn 'sudo reboot now'                          # 今すぐ再起動
abbr sus 'systemctl suspend'                        # サスペンド
abbr hib 'systemctl hibernate'                      # ハイバネート
abbr lock 'hyprlock'                                # 画面ロック
abbr logout 'hyprctl dispatch dpms off'             # ログアウト

# システム情報
abbr uname 'uname -a'                               # システム情報全表示
abbr kern 'uname -r'                                # カーネルバージョン
abbr ip 'ip -br addr'                               # IPアドレス簡易表示
abbr ports 'netstat -tulanp'                        # 開放ポート一覧

# ==========================================
# Git操作 / Git Operations
# ==========================================
abbr gs 'git status'                                # ステータス表示
abbr ga 'git add'                                   # ファイル追加
abbr gaa 'git add .'                                # 全ファイル追加
abbr gac 'git add . && git commit -m'               # 追加してコミット
abbr gc 'git commit -m'                             # コミット
abbr gca 'git commit --amend'                       # 直前のコミット修正
abbr gcm 'git commit -m'                            # コミットメッセージ
abbr gco 'git checkout'                             # ブランチ切り替え
abbr gcob 'git checkout -b'                         # ブランチ作成と切り替え
abbr gcod 'git checkout development'                # developmentブランチへ
abbr gcom 'git checkout main'                       # mainブランチへ
abbr gb 'git branch'                                # ブランチ一覧
abbr gba 'git branch -a'                            # 全ブランチ一覧
abbr gbd 'git branch -d'                            # ブランチ削除
abbr gbD 'git branch -D'                            # ブランチ強制削除
abbr gpush 'git push origin'                        # プッシュ
abbr gpushf 'git push origin --force'               # 強制プッシュ
abbr gpull 'git pull origin'                        # プル
abbr gfetch 'git fetch'                             # フェッチ
abbr gmerge 'git merge'                             # マージ
abbr grebase 'git rebase'                           # リベース
abbr greset 'git reset'                             # リセット
abbr greset-h 'git reset --hard'                    # ハードリセット
abbr gclean 'git clean -fd'                         # 未追跡ファイル削除
abbr gclean! 'git clean -fdx'                       # 未追跡ファイル全削除
abbr glog 'git log --oneline --graph --all'         # グラフ付きログ
abbr lg 'lazygit'                                   # Lazygit起動

# Git履歴・ diff
abbr gl 'git pull'                                  # プル
abbr gp 'git push'                                  # プッシュ
abbr gd 'git diff'                                  # 差分表示
abbr gds 'git diff --staged'                        # ステージ済み差分
abbr gdh 'git diff HEAD'                            # HEADとの差分
abbr gshow 'git show'                               # コミット詳細表示
abbr gblame 'git blame'                             # ブレーム表示

# Git stash
abbr gstash 'git stash'                             # スタッシュ保存
abbr gstash-pop 'git stash pop'                     # スタッシュ復元
abbr gstash-list 'git stash list'                   # スタッシュ一覧
abbr gstash-clear 'git stash clear'                 # スタッシュ全削除

# ==========================================
# tmux操作 / tmux Operations
# ==========================================
abbr t 'tmux'                                       # tmux起動
abbr ta 'tmux attach -t'                            # セッションアタッチ
abbr tl 'tmux list-sessions'                        # セッション一覧
abbr tls 'tmux ls'                                  # セッション一覧（短縮）
abbr tn 'tmux new-session -s'                       # 新規セッション作成
abbr tk 'tmux kill-session -t'                      # セッション削除
abbr tkill 'tmux kill-server'                       # tmuxサーバー停止
abbr tkillw 'tmux kill-window -t'                   # ウィンドウ削除
abbr tsave 'tmux save-buffer -'                     # バッファ保存
abbr tpaste 'tmux paste-buffer -'                   # バッファ貼り付け

# tmuxペイン操作
abbr tsplit-h 'tmux split-window -h'                # 水平分割
abbr tsplit-v 'tmux split-window -v'                # 垂直分割
abbr tnav 'tmux select-pane -t'                     # ペイン移動

# ==========================================
# 開発レイアウト / Development Layouts
# ==========================================
abbr dev '~/rudra/scripts/tmux-dev-layout.sh'                    # デフォルト開発環境
abbr nixdev '~/rudra/scripts/tmux-dev-layout.sh nixos ~/rudra'   # NixOS設定開発環境
abbr dev-claude '~/rudra/scripts/tmux-dev-layout.sh claude'      # Claude Code環境
abbr dev-claude-main '~/rudra/scripts/tmux-dev-layout.sh claude-main'  # Claudeメイン環境
abbr dev-git '~/rudra/scripts/tmux-dev-layout.sh git'            # Git環境

# ==========================================
# Claudeリポジトリ管理 / Claude Repository Management
# ==========================================
abbr repo '~/rudra/scripts/tmux-dev-layout.sh'       # レポジトリ管理
abbr dev-repo 'dev'                                  # レポジトリ開発環境
abbr repos 'tmux ls -F "#{session_name}"'            # セッション一覧
abbr dev-list '~/rudra/scripts/tmux-dev-layout.sh --list'  # レポジトリリスト表示
abbr dev-attach 'tmux attach-session -t'             # セッションアタッチ
abbr dev-kill 'tmux kill-session -t'                 # セッション削除

# ==========================================
# Claude Codeエイリアス / Claude Code Aliases
# ==========================================
abbr c 'claude'                                                 # Claude Code起動
abbr cc 'claude'                                                # Claude Code起動（短縮）
abbr c-continue 'claude -c'                                     # 前回の会話を継続
abbr c-muso 'claude --dangerously-skip-permissions'             # 無双モード（制限なし）
abbr cm 'claude --dangerously-skip-permissions'                 # 無双モード（短縮）
abbr ccm 'claude -c --dangerously-skip-permissions'             # 継続+無双モード

# ==========================================
# NixOS管理 / NixOS Management
# ==========================================
abbr rebuild 'sudo nixos-rebuild switch --flake ~/rudra/.#default'  # システム再構築
abbr recats 'sudo nix flake lock --update-input nixCats && sudo nixos-rebuild switch --flake ~/rudra/.#default'  # nixCats更新
abbr nix-update 'sudo nix-channel --update && sudo nixos-rebuild switch --flake ~/rudra/.#default'  # チャンネル更新
abbr nix-clean 'sudo nix-collect-garbage -d'                    # ゴミ収集（古い世代削除）
abbr nix-optim 'nix-store --optimize'                           # ストア最適化
abbr nix-query 'nix-env -qa'                                    # パッケージ検索
abbr nix-install 'nix-env -iA'                                  # パッケージインストール
abbr nix-remove 'nix-env -e'                                    # パッケージ削除

# ==========================================
# Docker操作 / Docker Operations
# ==========================================
abbr d 'docker'                                     # Dockerコマンド
abbr dps 'docker ps'                                # コンテナ一覧（実行中）
abbr dpsa 'docker ps -a'                            # コンテナ一覧（全て）
abbr di 'docker images'                             # イメージ一覧
abbr dex 'docker exec -it'                          # コンテナ実行
abbr dlog 'docker logs -f'                          # ログ表示
abbr dstop 'docker stop'                            # コンテナ停止
abbr dstart 'docker start'                          # コンテナ起動
abbr drestart 'docker restart'                      # コンテナ再起動
abbr dkill 'docker kill'                            # コンテナ強制終了
abbr dkillall 'docker kill $(docker ps -q)'         # 全コンテナ強制終了
abbr drm 'docker rm'                                # コンテナ削除
abbr drmi 'docker rmi'                              # イメージ削除
abbr dcp 'docker cp'                                # ファイルコピー
abbr dbuild 'docker build -t'                       # イメージビルド
abbr dcom 'docker-compose'                          # Docker Compose
abbr dcomup 'docker-compose up -d'                  # コンテナ起動（バックグラウンド）
abbr dcomdown 'docker-compose down'                 # コンテナ停止
abbr dcomlogs 'docker-compose logs -f'              # ログ表示

# ==========================================
# 開発ツール / Development Tools
# ==========================================
abbr vim 'nvim'                                     # Neovim起動
abbr v 'nvim'                                       # Neovim起動（短縮）
abbr nvim 'nvim'                                    # Neovim起動
abbr vi 'nvim'                                      # Neovim起動
abbr z 'zed'                                        # Zedエディタ起動
abbr code 'code'                                    # VSCode起動
abbr idea 'idea'                                    # IntelliJ IDEA起動

# Node.js/npm
abbr npm 'npm'                                      # npm
abbr npi 'npm install'                              # パッケージインストール
abbr npmg 'npm install -g'                          # グローバルインストール
abbr npmun 'npm uninstall'                          # パッケージアンインストール
abbr nps 'npm start'                                # スタート
abbr npr 'npm run'                                  # スクリプト実行
abbr npml 'npm list'                                # インストール済みパッケージ
abbr npma 'npm audit'                               # セキュリティ監査

# yarn
abbr yr 'yarn'                                      # yarn
abbr yri 'yarn add'                                 # パッケージ追加
abbr yrr 'yarn remove'                              # パッケージ削除
abbr yrg 'yarn global add'                          # グローバル追加

# pnpm
abbr pnpm 'pnpm'                                    # pnpm
abbr ppni 'pnpm add'                                # パッケージ追加
abbr ppng 'pnpm add -g'                             # グローバル追加
abbr ppnun 'pnpm remove'                            # パッケージ削除

# Python
abbr py 'python'                                    # Python
abbr py3 'python3'                                  # Python3
abbr pip 'pip3'                                     # pip3
abbr pipi 'pip3 install'                            # パッケージインストール
abbr piplist 'pip3 list'                            # インストール済みパッケージ

# ==========================================
# ユーティリティ / Utilities
# ==========================================
abbr c 'clear'                                      # 画面クリア
abbr cls 'clear'                                    # 画面クリア
abbr e 'exit'                                       # 終了
abbr q 'exit'                                       # 終了
abbr x 'exit'                                       # 終了
abbr grep 'rg --color=auto'                         # ripgrepで検索
abbr rg 'rg'                                        # ripgrep
abbr rgi 'rg -i'                                    # 大文字小文字無視検索
abbr find 'fd'                                      # fd検索
abbr ps 'ps auxf'                                   # プロセス詳細
abbr psg 'ps aux | grep -i'                         # プロセス検索
abbr killall 'killall -9'                           # 全プロセス強制終了
abbr wget 'wget -c'                                 # ダウンロード（レジューム可能）

# ==========================================
# ネットワーク / Network
# ==========================================
abbr ping 'ping -c 4'                               # 4回ping
abbr ports 'ss -tulwn'                              # 開放ポート
abbr netstat 'netstat -tulanp'                      # ネットワーク統計
abbr ifconfig 'ip addr show'                        # IPアドレス表示
abbr iwget 'wget -c'                                # ダウンロード

# ==========================================
# アーカイブ操作 / Archive Operations
# ==========================================
abbr untar 'tar -xzvf'                              # tar解凍
abbr mktar 'tar -czvf'                              # tar圧縮

# ==========================================
# 権限操作 / Permissions
# ==========================================
abbr chx 'chmod +x'                                 # 実行権限付与
abbr cx 'chmod +x'                                  # 実行権限付与（短縮）
abbr 755 'chmod 755'                                # 755権限
abbr 644 'chmod 644'                                # 644権限

# ==========================================
# その他 / Others
# ==========================================
abbr path 'echo $PATH'                              # PATH表示
abbr now 'date'                                     # 現在日時
abbr cal 'cal -3'                                   # カレンダー（前後3ヶ月）
abbr weather 'curl wttr.in'                         # 天気予報
abbr myip 'curl ifconfig.me'                        # グローバルIP表示
abbr localip 'ip addr show | grep inet'             # ローカルIP表示

# SSH
abbr ssh 'ssh'                                      # SSH接続
abbr scp 'scp'                                      # SCPコピー

# systemctl
abbr sc 'systemctl'                                 # systemctl
abbr scs 'systemctl status'                         # ステータス確認
abbr scr 'systemctl restart'                        # 再起動
abbr scstart 'systemctl start'                      # サービス起動
abbr scstop 'systemctl stop'                        # サービス停止
abbr scenable 'systemctl enable'                    # 自動起動有効
abbr scdisable 'systemctl disable'                  # 自動起動無効
abbr scu 'systemctl --user'                         # ユーザーサービス

# Journalctl
abbr jl 'journalctl'                                # ジャーナル表示
abbr jlf 'journalctl -f'                            # ジャーナル追従
abbr jle 'journalctl -p err'                        # エラーのみ
abbr jlu 'journalctl -u'                            # ユニット指定

# ==========================================
# Key Bindings
# ==========================================

# Vim mode
fish_vi_key_bindings

# History search
function fish_user_key_bindings
    bind \cr history_search_forward
    bind \cf forward_char
end

# ==========================================
# Plugins (Fisher - Fish plugin manager)
# ==========================================

# Install Fisher if not present
if not functions -q fisher
    echo "Installing Fisher..."
    curl -sL https://git.io/fisher | source && fisher install fzf
end

# Essential plugins
set -g fish_plugins autopair-fish fish-abbreviations fish-autosuggestions

# ==========================================
# Colors & Theme
# ==========================================

# Starship prompt
if type -q starship
    starship init fish | source
end

# Syntax highlighting
if type -q fish
    set -g fish_color_autosuggestion brblack
    set -g fish_color_command brgreen
    set -g fish_color_error red
    set -g fish_color_param cyan
end

# ==========================================
# Functions
# ==========================================

# mkcd - mkdir and cd
function mkcd
    mkdir -p $argv[1] && cd $argv[1]
end

# exa alias for compatibility
function exa
    eza $argv
end

# ==========================================
# Hooks
# ==========================================

# Create directory on cd if not exists
function __cd_hook --on-variable PWD
    if test ! -d "$PWD"
        echo "Directory does not exist: $PWD"
    end
end

# ==========================================
# Welcome Message
# ==========================================

function fish_greeting
    # Show neofetch or fastfetch
    if type -q fastfetch
        fastfetch
    end
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

# Disable greeting
set -g fish_greeting

# Better tab completion
set -g fish_autosuggestion_enabled 1

# Faster command-not-found handling
if type -q command-not-found
    command-not-found
end
