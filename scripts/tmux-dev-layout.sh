#!/usr/bin/env bash
# tmux開発環境レイアウト自動構築（Claude-First Repository Philosophy）

# ========================================
# Repository Management
# ========================================

# List all active repositories/sessions
if [ "$1" = "--list" ]; then
    echo "🤖 Active Claude Repositories:"
    echo ""
    tmux list-sessions -F "#{?session_attached,* ,}#{session_name} #{?session_attached,(attached),}" 2>/dev/null | while read -r line; do
        if [[ "$line" == *" (attached)"* ]]; then
            echo "  ✅ $line"
        else
            echo "  📦 $line"
        fi
    done

    echo ""
    echo "📊 Session Details:"
    tmux list-sessions -F "  #{session_name}: #{session_windows} windows, created #{session_created_string}" 2>/dev/null
    echo ""
    echo "💡 Attach with: ta <repo-name>"
    echo "   Or: dev-attach <repo-name>"
    exit 0
fi

# ========================================
# Parse Arguments
# ========================================

SESSION_NAME="${1:-dev}"

# スマート引数解析: 第2引数がレイアウト名ならパスは$PWD
LAYOUTS="^(code|claude|claude-main|claude-repo|git)$"
if [[ "$2" =~ $LAYOUTS ]]; then
    PROJECT_PATH="$PWD"
    LAYOUT="$2"
else
    PROJECT_PATH="${2:-$PWD}"
    LAYOUT="${3:-claude-repo}"  # デフォルトはclaude-repo
fi

if [ $? != 0 ]; then
    # 新規セッション作成
    tmux new-session -d -s "$SESSION_NAME" -c "$PROJECT_PATH"
    tmux rename-window -t "$SESSION_NAME:1" "dev"

    case "$LAYOUT" in
        claude-repo)
            # ========================================
            # Claude Code Repository Layout (Claude-First Philosophy)
            # 左: Claude Code Main (70%) | 右: Claude Code Sub (20%) + Terminal (10%)
            #
            # 理念: tmuxセッションをリポジトリのように扱う
            #       Neovimなし、Claude Codeがメインのエディタ
            #       メインClaudeで開発、サブClaudeで調査・実験
            # ========================================
            echo "🤖 Creating Claude Code REPOSITORY layout (Claude-First)..."

            # 左ペイン: Claude Code Main（70%幅 - メイン開発用）
            tmux send-keys -t "$SESSION_NAME:1" "clear" C-m
            tmux send-keys -t "$SESSION_NAME:1" "echo '🤖 Claude Code Repository - Claude-First Development'" C-m
            tmux send-keys -t "$SESSION_NAME:1" "echo ''" C-m
            tmux send-keys -t "$SESSION_NAME:1" "echo '📦 左: メインClaude - 開発・実装'" C-m
            tmux send-keys -t "$SESSION_NAME:1" "echo '📦 右上: サブClaude - 調査・実験'" C-m
            tmux send-keys -t "$SESSION_NAME:1" "echo '📦 右下: ターミナル - コマンド実行'" C-m
            tmux send-keys -t "$SESSION_NAME:1" "echo ''" C-m
            tmux send-keys -t "$SESSION_NAME:1" "echo '🚀 Start: claude | claude -c | c-continue'" C-m
            tmux send-keys -t "$SESSION_NAME:1" ""

            # 垂直分割（右側30%）
            tmux split-window -h -t "$SESSION_NAME:1" -c "$PROJECT_PATH" -p 30

            # 右側を水平分割（上: Claude Sub、下: Terminal）
            tmux split-window -v -t "$SESSION_NAME:1.2" -c "$PROJECT_PATH" -p 20

            # 右上ペイン: Claude Code Sub（調査・実験用）
            tmux send-keys -t "$SESSION_NAME:1.2" "clear" C-m
            tmux send-keys -t "$SESSION_NAME:1.2" "echo '🔬 Claude Sub - Research & Experiment'" C-m
            tmux send-keys -t "$SESSION_NAME:1.2" "echo 'Start: claude | claude -c'" C-m
            tmux send-keys -t "$SESSION_NAME:1.2" ""

            # 右下ペイン: Terminal（コマンド実行用）
            tmux send-keys -t "$SESSION_NAME:1.3" "clear" C-m

            # 左ペイン（Claude Code Main）にフォーカス
            tmux select-pane -t "$SESSION_NAME:1.1"
            ;;

        claude-main)
            # ========================================
            # Claude Code Main Layout (Claude-focused)
            # 左: Claude Code (70%) | 右: Neovim (20%) + Terminal (10%)
            # ========================================
            echo "🤖 Creating Claude Code MAIN layout..."

            # 左ペイン: Claude Code（70%幅 - メイン！）
            tmux send-keys -t "$SESSION_NAME:1" "clear" C-m
            tmux send-keys -t "$SESSION_NAME:1" "echo '🤖 Claude Code Main - Claudeを起動してください'" C-m
            tmux send-keys -t "$SESSION_NAME:1" "echo '   CLI: claude'" C-m
            tmux send-keys -t "$SESSION_NAME:1" "echo '   Browser: https://claude.ai'" C-m
            tmux send-keys -t "$SESSION_NAME:1" ""

            # 垂直分割（右側30%）
            tmux split-window -h -t "$SESSION_NAME:1" -c "$PROJECT_PATH" -p 30

            # 右側を水平分割（上: Neovim、下: Terminal）
            tmux split-window -v -t "$SESSION_NAME:1.2" -c "$PROJECT_PATH" -p 25

            # 右上ペイン: Neovim（コード編集用）
            tmux send-keys -t "$SESSION_NAME:1.2" "nvim" C-m

            # 右下ペイン: Terminal（コマンド実行用）
            tmux send-keys -t "$SESSION_NAME:1.3" "clear" C-m

            # 左ペイン（Claude Code）にフォーカス
            tmux select-pane -t "$SESSION_NAME:1.1"
            ;;

        claude)
            # ========================================
            # Claude Code Layout (3分割)
            # 左: Neovim | 中: Terminal | 右: Claude Code
            # ========================================
            echo "🤖 Creating Claude Code development layout..."

            # 左ペイン: Neovim（50%幅）
            tmux send-keys -t "$SESSION_NAME:1" "nvim" C-m

            # 垂直分割（右側50%）
            tmux split-window -h -t "$SESSION_NAME:1" -c "$PROJECT_PATH" -p 50

            # 右側を水平分割（上: Terminal、下: Claude Code）
            tmux split-window -v -t "$SESSION_NAME:1.2" -c "$PROJECT_PATH" -p 50

            # 中上ペイン: Terminal（コマンド実行用、クリアしておく）
            tmux send-keys -t "$SESSION_NAME:1.2" "clear" C-m

            # 右下ペイン: Claude Code
            tmux send-keys -t "$SESSION_NAME:1.3" "clear" C-m
            tmux send-keys -t "$SESSION_NAME:1.3" "echo '🤖 Claude Code - 次のコマンドで起動:'" C-m
            tmux send-keys -t "$SESSION_NAME:1.3" "echo '   CLI: claude'" C-m
            tmux send-keys -t "$SESSION_NAME:1.3" "echo '   Copilot: gh copilot'" C-m
            tmux send-keys -t "$SESSION_NAME:1.3" ""

            # 左ペイン（Neovim）にフォーカス
            tmux select-pane -t "$SESSION_NAME:1.1"
            ;;

        git)
            # ========================================
            # Git Layout (3分割)
            # 左: Neovim | 右上: Lazygit | 右下: Terminal
            # ========================================
            echo "Creating Git development layout..."

            # 左ペイン: Neovim（70%幅）
            tmux send-keys -t "$SESSION_NAME:1" "nvim" C-m

            # 垂直分割（右側30%）
            tmux split-window -h -t "$SESSION_NAME:1" -c "$PROJECT_PATH" -p 30

            # 右側を水平分割（上: Lazygit、下: Terminal）
            tmux split-window -v -t "$SESSION_NAME:1.2" -c "$PROJECT_PATH" -p 50

            # 右上ペイン: Lazygit
            tmux send-keys -t "$SESSION_NAME:1.2" "lazygit" C-m

            # 右下ペイン: Terminal（コマンド実行用）
            tmux send-keys -t "$SESSION_NAME:1.3" "clear" C-m

            # 左ペイン（Neovim）にフォーカス
            tmux select-pane -t "$SESSION_NAME:1.1"
            ;;

        code|*)
            # ========================================
            # Code Layout (3分割 - デフォルト)
            # 左: Neovim (70%) | 右上: Terminal (20%) | 右下: Terminal (10%)
            # ========================================
            echo "Creating Code development layout..."

            # 左ペイン: Neovim（70%幅）
            tmux send-keys -t "$SESSION_NAME:1" "nvim" C-m

            # 垂直分割（右側30%）
            tmux split-window -h -t "$SESSION_NAME:1" -c "$PROJECT_PATH" -p 30

            # 右側を水平分割（上: メインTerminal、下: サブTerminal）
            tmux split-window -v -t "$SESSION_NAME:1.2" -c "$PROJECT_PATH" -p 40

            # 右上ペイン: メインTerminal（コマンド実行用）
            tmux send-keys -t "$SESSION_NAME:1.2" "clear" C-m
            tmux send-keys -t "$SESSION_NAME:1.2" "echo '📝 メインターミナル - ビルド・テスト実行用'" C-m
            tmux send-keys -t "$SESSION_NAME:1.2" ""

            # 右下ペイン: サブTerminal（ログ・ファイル監視用）
            tmux send-keys -t "$SESSION_NAME:1.3" "clear" C-m
            tmux send-keys -t "$SESSION_NAME:1.3" "echo '📊 サブターミナル - ログ・ファイル監視用'" C-m
            tmux send-keys -t "$SESSION_NAME:1.3" ""

            # 左ペイン（Neovim）にフォーカス
            tmux select-pane -t "$SESSION_NAME:1.1"
            ;;
    esac

    # ========================================
    # 追加ウィンドウ作成
    # ========================================

    # ウィンドウ2: Git & Terminal
    tmux new-window -t "$SESSION_NAME:2" -n "git" -c "$PROJECT_PATH"
    tmux send-keys -t "$SESSION_NAME:2" "lazygit" C-m

    # ウィンドウ3: コマンド実行用
    tmux new-window -t "$SESSION_NAME:3" -n "term" -c "$PROJECT_PATH"

    # 最初のウィンドウに戻る
    tmux select-window -t "$SESSION_NAME:1"
    tmux select-pane -t "$SESSION_NAME:1.1"

    echo "✅ セッション '$SESSION_NAME' 作成完了！"
else
    echo "⚠️  セッション '$SESSION_NAME' は既に存在します"
    echo "アタッチします..."
fi

# セッションにアタッチ
tmux attach-session -t "$SESSION_NAME"
