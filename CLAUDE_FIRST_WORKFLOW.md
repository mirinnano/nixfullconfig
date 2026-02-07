# Claude First Development Workflow

## 🚀 Philosophy

**tmuxセッション = レポジトリ**

Neovimなし。Claude Codeがメインのエディタ。
各tmuxセッションは一つのレポジトリ/プロジェクトを表す。

---

## 📦 レイアウト構造

### Claude Repository Layout（Claude-First）

```
┌─────────────────────────┬──────────────┐
│                         │              │
│   Claude Code Main      │  Claude Sub  │
│        (70%)            │    (20%)     │
│   🎯 メイン開発          |  🔬 調査・実験 │
│                         │              │
├─────────────────────────┤              │
│      Terminal (10%)     │              │
│      ⚡ コマンド実行      │              │
└─────────────────────────┴──────────────┘
```

#### 使用例

```bash
# 新規レポジトリ（プロジェクト）作成
repo myproject ~/projects/myproject claude-repo

# 既存レポジトリにアタッチ
ta myproject

# レポジトリ一覧表示
dev-list
# または
repos
```

#### ペインの役割

**左（メイン）**:
- メインのClaude Codeセッション
- 開発・実装・リファクタリング
- `claude` または `claude -c` で起動

**右上（サブ）**:
- サブClaude Codeセッション
- 調査・実験・別タスク
- 新しいアイデアを試す場所
- メインの会話を邪魔せずに実験

**右下（ターミナル）**:
- ビルド・テスト実行
- Git操作
- ファイル監視

---

## 💻 ワークフロー

### 1. 新規プロジェクト開始

```bash
# プロジェクトディレクトリへ
cd ~/projects/new-project

# Claude Repositoryレイアウトで起動
repo newproject $(pwd) claude-repo

# 左ペインでメインClaude起動
claude

# 右上ペインでサブClaude起動（Ctrl+a, 2 で移動）
claude

# 右下でコマンド実行
npm test
cargo build
```

### 2. レポジトリ一覧・選択

```bash
# レポジトリ一覧（美しい表示）
dev-list

# 出力例:
# 🤖 Active Claude Repositories:
#
#   ✅ nixos (attached)
#   📦 myapp
#   📦 sideproject
#   📦 learning-go
#
# 💡 Attach with: ta <repo-name>

# アタッチ
ta myapp

# またはインタラクティブ選択（fzfがある場合）
dev-interactive
```

### 3. レポジトリ間移動

```bash
# 現在のセッションをデタッチ
# tmux内で: Ctrl+a, d

# レポジトリ一覧
dev-list

# 目的のレポジトリにアタッチ
ta sideproject
```

### 4. Claudeとの対話的開発

**メインClaude（左ペイン）**:
```bash
# メインの実装・開発
claude -c
> この関数をリファクタリングして
> テストを書いて
> バグを修正して
```

**サブClaude（右上ペイン）**:
```bash
# 実験・調査
claude
> このライブラリの使い方を教えて
> 別のアプローチを考えて
> 新しいアイデアを試してみて
```

**ターミナル（右下）**:
```bash
# 継続的に実行・確認
npm run dev
cargo test
pytest -x
git status
```

---

## 🎯 使い分け

### メインClaude vs サブClaude

| メイン（左） | サブ（右上） |
|-------------|-------------|
| 実装・開発 | 調査・実験 |
| リファクタリング | ライブラリ調査 |
| バグ修正 | アイデア検証 |
| テスト作成 | プロトタイピング |
| コードレビュー | 別解法探索 |

### 実践例

**シナリオ1: 新機能実装**
```
メインClaude: "ユーザー認証機能を実装して"
ターミナル:     テスト実行
サブClaude:    "JWTのベストプラクティスを教えて"
メインClaude: "サブの情報を使って実装を改良"
```

**シナリオ2: バグ調査**
```
メインClaude: "このバグを修正して"
サブClaude:    "このエラーメッセージの原因を調査して"
ターミナル:     ログ監視
メインClaude: "サブの調査結果を元に修正"
```

**シナリオ3: リファクタリング**
```
メインClaude: "このコードをクリーンアップして"
サブClaude:    "別の設計パターンを提案して"
メインClaude: "サブの提案を採用して実装"
```

---

## 🔧 コマンド一覧

### レポジトリ管理

```bash
# 新規レポジトリ作成
repo <name> <path> claude-repo

# レポジトリ一覧
dev-list          # 美しい表示
repos            # シンプル表示

# レポジトリにアタッチ
ta <name>        # 短縮エイリアス
dev-attach <name>

# インタラクティブ選択（fzf必須）
dev-interactive

# レポジトリ削除
dev-kill <name>
tk <name>
```

### tmux操作

```bash
# デタッチ（セッション維持）
Ctrl+a, d

# ペイン移動
Ctrl+a, h/j/k/l    # 左/下/上/右

# ウィンドウ操作
Ctrl+a, c          # 新規ウィンドウ
Ctrl+a, 1/2/3      # ウィンドウ切り替え

# セッション保存・復元
Ctrl+a, Ctrl+s     # 手動保存
Ctrl+a, Ctrl+r     # 手動復元
```

### Claude Code

```bash
# 基本エイリアス
c                 # claude
cc                # claude
c-continue        # claude -c（継続）
c-muso / cm       # 無双モード
ccm               # 継続+無双

# 使用例
c -c "この関数をリファクタリングして"
c-continue "続きから"
cm "許可なしで実行"
```

---

## 📊 セッション自動保存

- **15分ごと**: 自動保存（Continuum）
- **起動時**: 自動復元
- **手動保存**: `Ctrl+a, Ctrl+s`
- **手動復元**: `Ctrl+a, Ctrl+r`

### 保存される内容

✅ ウィンドウ/ペインのレイアウト
✅ 作業ディレクトリ
✅ 実行中のプログラム（Neovimセッション含む）
✅ セッション名

---

## 🎨 レイアウト比較

| レイアウト | 用途 | 起動コマンド |
|-----------|------|------------|
| **Claude Repository** | Claude-First開発 | `repo name path claude-repo` |
| Claude Main | Claude + Neovim | `dev-claude-main` |
| Claude | バランス型 | `dev-claude` |
| Code | Neovimメイン | `dev` |
| Git | Git集中 | `dev-git` |

---

## 💡 ヒント

### ワークフロー最適化

1. **プロジェクト名 = セッション名**
   ```bash
   repo nixos ~/rudra nixos claude-repo
   repo myapp ~/projects/myapp myapp claude-repo
   ```

2. **プロジェクトごとに専用セッション**
   ```bash
   dev-list  # 全プロジェクトを一覧管理
   ```

3. **コンテキストスイッチ**
   ```bash
   Ctrl+a, d     # デタッチ
   dev-list      # 一覧表示
   ta myapp      # 切り替え
   ```

### Claude活用術

**メインClaude**:
- 継続的な開発作業
- `claude -c` で会話を引き継ぐ
- 実装→テスト→修正のサイクル

**サブClaude**:
- 独立した調査・実験
- 新しい会話でアイデア試行
- メインの邪魔にならない

### 複数Claudeの協調

```
サブClaude: "このAPIの使い方を教えて"
          ↓
メインClaude: "それを元に実装して"
          ↓
ターミナル:   テスト実行
          ↓
メインClaude: "テスト結果を元に改良"
```

---

## 🔥 Advanced

### fzfによるインタラクティブ選択

```bash
# ~/.zshrc に既に設定済み
dev-interactive

# セッションをプレビューしながら選択可能
```

### プロジェクトテンプレート

```bash
# ~/.zshrc に追加可能
alias repo-new='mkdir -p ~/projects/$1 && cd ~/projects/$1 && git init && repo $1 $(pwd) claude-repo'
```

### Claudeエイリアス拡張

```bash
# プロジェクト固有のエイリアス
alias c-main='tmux select-pane -t 1.1 && c'
alias c-sub='tmux select-pane -t 1.2 && c'
alias c-term='tmux select-pane -t 1.3'
```

---

## 📚 関連ドキュメント

- **完全ガイド**: `~/rudra/TMUX_SESSION_GUIDE.md`
- **クイックリファレンス**: `~/rudra/TMUX_QUICK_REFERENCE.md`
- **tmux設定**: `~/rudra/dotfiles/.tmux.conf`
- **レイアウトスクリプト**: `~/rudra/scripts/tmux-dev-layout.sh`

---

## 🎉 まとめ

**Claude First Development =**

1. ✅ tmuxセッションをレポジトリとして管理
2. ✅ Claude Codeがメインのエディタ
3. ✅ メインClaude + サブClaudeで効率的開発
4. ✅ 自動保存・復元で作業状態維持
5. ✅ 複数プロジェクトを並行運用

**Neovimなし、Claudeだけで完璧な開発環境！** 🚀
