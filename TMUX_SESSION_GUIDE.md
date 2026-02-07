# Tmux 完全ガイド

## 📚 目次

1. [基本操作](#基本操作)
2. [開発レイアウト](#開発レイアウト)
3. [セッション管理](#セッション管理)
4. [Neovim + Tmux 統合](#neovim--tmux-統合)
5. [セッションの保存と復元](#セッションの保存と復元)
6. [実践的なワークフロー](#実践的なワークフロー)

---

## 基本操作

### プレフィックスキー
- **デフォルト**: `Ctrl+b`（今回の設定では `Ctrl+a` に変更）
- `Ctrl+a` を押してからコマンドキーを押す

### 基本キーバインド

```bash
# セッション管理
Ctrl+a + d          # デタッチ（セッションを維持したまま離脱）
Ctrl+a + $          # セッション名変更
Ctrl+a + s          # セッション一覧表示・選択

# ウィンドウ管理
Ctrl+a + c          # 新規ウィンドウ作成
Ctrl+a + ,          # ウィンドウ名変更
Ctrl+a + n          # 次のウィンドウ
Ctrl+a + p          # 前のウィンドウ
Ctrl+a + 0-9        # ウィンドウ番号で移動
Ctrl+a + &          # ウィンドウを閉じる

# ペイン操作
Ctrl+a + |          # 垂直分割
Ctrl+a + -          # 水平分割
Ctrl+a + h/j/k/l    # Vim風ペイン移動（左/下/上/右）
Ctrl+a + H/J/K/L    # ペインサイズ変更（Shift）
Ctrl+a + q          # ペイン番号表示
Ctrl+a + x          # ペインを閉じる
Ctrl+a + z          # ペインをズーム（拡大/縮小）

# その他
Ctrl+a + :          # コマンドプロンプト
Ctrl+a + [          # コピーモード（スクロール・コピー）
Ctrl+a + r          # 設定リロード
```

### マウス操作
```bash
# マウスが有効になっている場合：
- クリックでペイン選択
- ドラッグでペインサイズ変更
- ホイールでスクロール
```

---

## 開発レイアウト

### スクリプト使用方法

```bash
# 基本構文
tmux-dev-layout.sh [セッション名] [プロジェクトパス] [レイアウトタイプ]

# デフォルト（Codeレイアウト: Neovim + Terminal×2）
dev

# NixOS設定用（Codeレイアウト）
nixdev

# Claude Codeレイアウト（Neovim + Terminal + Claude）
dev-claude ~/rudra/scripts/tmux-dev-layout.sh claude ~/rudra

# Gitレイアウト（Neovim + Lazygit + Terminal）
dev-git ~/rudra/scripts/tmux-dev-layout.sh git ~/rudra
```

### レイアウトタイプ詳細

#### 1. Codeレイアウト（デフォルト）
```
┌─────────────────────────┬──────────────────┐
│                         │                  │
│                         │  メインターミナル  │
│      Neovim (70%)       │   (ビルド・テスト) │
│                         │                  │
│                         ├──────────────────┤
│                         │                  │
│                         │ サブターミナル   │
│                         │  (ログ監視)      │
└─────────────────────────┴──────────────────┘
```

**使用例**:
```bash
# 右上: ビルド実行
npm run build
cargo build
nixos-rebuild build

# 右下: ログ監視
journalctl -f
tail -f logs/app.log
```

#### 2. Claude Codeメイン レイアウト 🆕
```
┌─────────────────────────┬──────────────┐
│                         │              │
│      Claude Code        │   Neovim     │
│        (70%)            │    (20%)     │
│      (メイン)            │  (コード編集)  │
│                         │              │
├─────────────────────────┤              │
│      Terminal (10%)     │              │
│      (コマンド実行)      │              │
└─────────────────────────┴──────────────┘
```

**起動**: `dev-claude-main`

**使用例**:
```bash
# 左: Claude Code（メイン - ここで作業！）
claude                    # Claude Code CLI
# またはブラウザで https://claude.ai

# 右上: Neovim（コード編集）
# 右下: Terminal（テスト・ビルド実行）
```

**推奨ワークフロー**:
1. 左ペインでClaude Codeを起動（`claude` またはブラウザ）
2. 右上のNeovimでClaudeが指摘したファイルを編集
3. 右下のTerminalでテスト実行
4. Claudeと対話しながら開発

#### 3. Claude Codeレイアウト（バランス型）
```
┌─────────────────┬──────────────────────┬───────────────┐
│                 │                      │               │
│   Neovim (50%)  │  Terminal (25%)      │ Claude (25%)  │
│   (コード編集)   │   (コマンド実行)      │   (AIアシスト) │
│                 │                      │               │
└─────────────────┴──────────────────────┴───────────────┘
```

**起動**: `dev-claude`

**使用例**:
```bash
# 左: Neovimでコード編集
# 中: コマンド実行（テスト・ビルド）
# 右: Claude CodeでAIアシスト

# Claude Code起動方法（右下ペイン）
claude
# または
gh copilot
# またはブラウザ版
```

#### 4. Gitレイアウト
```
┌─────────────────────────┬──────────────┐
│                         │              │
│                         │   Lazygit    │
│      Neovim (70%)       │   (Git操作)  │
│                         │              │
│                         ├──────────────┤
│                         │              │
│                         │  Terminal    │
│                         │ (コマンド)   │
└─────────────────────────┴──────────────┘
```

---

## セッション管理

### 基本コマンド

```bash
# 新規セッション作成
tmux new -s <セッション名>

# セッション一覧
tmux ls
# または
tmux list-sessions

# セッションにアタッチ
tmux attach -t <セッション名>
# または
tmux a -t <セッション名>

# デタッチ（セッション内で）
Ctrl+a + d

# セッションを強制終了
tmux kill-session -t <セッション名>

# 全セッション終了
tmux kill-server
```

### セッション名変更

```bash
# セッション内で
Ctrl+a + $

# コマンドラインから
tmux rename-session -t <旧名> <新名>
```

### セッション間移動

```bash
# セッション内で
Ctrl+a + s          # セッション一覧表示
Ctrl+a + (          # 前のセッション
Ctrl+a + )          # 次のセッション

# コマンドラインからアタッチ
tmux switch-client -t <セッション名>
```

---

## Neovim + Tmux 統合

### シームレスなナビゲーション

**vim-tmux-navigator** が設定されている場合、以下のキーでNeovimとtmux間を移動できます：

```vim
" Neovim内でも同じキーバインド
Ctrl+h    # 左のペインへ（Neovim → tmux）
Ctrl+j    # 下のペインへ
Ctrl+k    # 上のペインへ
Ctrl+l    # 右のペインへ（Neovim → tmux）
Ctrl+\    # 前のペインへ
```

**設定済みファイル**:
- `~/.config/nvim/lua/plugins/tmux.lua`

### LazyGit 統合

```vim
" Neovim内からLazyGit起動
:LazyGit
" またはキーマッピング
<leader>gg
```

---

## セッションの保存と復元

### tmux-resurrect / tmux-continuum

**自動保存・復元が有効化されています**（`.tmux.conf`設定）

```bash
# 手動保存
Ctrl+a + Ctrl+s    # 今すぐセッション保存

# 手動復元
Ctrl+a + Ctrl+r    # 最後のセッションを復元
```

### 保存される内容

- ✅ ウィンドウとペインのレイアウト
- ✅ 各ペインの作業ディレクトリ
- ✅ 実行中のプログラム（Neovimセッション含む）
- ✅ セッション名とウィンドウ名
- ❌ ペイン内のスクロールバッファ
- ❌ シェルの履歴

### 復元設定

現在の設定（`.tmux.conf`）:
```bash
set -g @continuum-restore 'on'              # 起動時自動復元
set -g @continuum-save-interval '15'        # 15分ごとに自動保存
set -g @resurrect-strategy-nvim 'session'   # Neovimセッションも保存
```

### 自動復元の動作

1. **tmux起動時**: 最後のセッションが自動的に復元
2. **15分ごと**: 現在のセッションが自動保存
3. **システム終了時**: 最後の保存状態が維持

---

## 実践的なワークフロー

### ワークフロー1: 新規プロジェクト開始

```bash
# 1. プロジェクトディレクトリへ移動
cd ~/projects/new-project

# 2. tmux開発環境起動
dev myproject ~/projects/new-project

# 3. セッションが自動保存される
# 15分ごと、または手動で Ctrl+a + Ctrl+s
```

### ワークフロー2: 既存セッションに戻る

```bash
# 方法1: エイリアス使用
ta myproject

# 方法2: 直接アタッチ
tmux a -t myproject

# 方法3: セッション一覧から選択
tmux ls
# 出力: myproject: 3 windows
tmux a -t myproject
```

### ワークフロー3: Claude Code開発（バランス型）

```bash
# Claude Codeレイアウトで起動
dev-claude

# 3分割画面:
# 左: Neovimでコード編集
# 中: テスト実行
# 右: Claude CodeでAIアシスト

# Claude Code使用例（右ペイン）
claude                    # Claude Code CLI
gh copilot               # GitHub Copilot
# またはブラウザ版 Claude
```

### ワークフロー3.5: Claude Codeメイン開発 🆕

```bash
# Claude Codeメインレイアウトで起動
dev-claude-main

# 3分割画面（Claude重視）:
# 左: Claude Code（70% - メイン！）
# 右上: Neovim（20% - コード編集）
# 右下: Terminal（10% - テスト実行）

# Claude Code使用例（左ペイン - メイン）
claude                    # Claude Code CLI起動
# またはブラウザで https://claude.ai

# 推奨フロー:
# 1. 左ペインでClaude Codeを起動
# 2. Claudeと対話しながら開発
# 3. 右上のNeovimでClaudeが指摘したファイルを編集
# 4. 右下のTerminalでテスト実行
# 5. 結果をClaudeにフィードバック

# Claude Code CLIコマンド例:
claude                    # 対話モード開始
claude --help            # ヘルプ表示
```

### ワークフロー4: Git集中開発

```bash
# Gitレイアウトで起動
dev-git ~/rudra

# 3分割画面:
# 左: Neovimでコード編集
# 右上: LazygitでGit操作
# 右下: コマンド実行

# Lazygit操作（右上ペイン）
# - ステージング: スペース
# - コミット: c
# - プッシュ: P
# - プル: p
```

### ワークフロー5: セッション切り替え

```bash
# メインプロジェクト
ta main

# 別プロジェクトに切り替え
# Ctrl+a + s でセッション一覧
# 矢印キーで選択 → Enter

# またはコマンドで直接切り替え
tmux switch-client -t side-project

# デタッチして別セッションへ
Ctrl+a + d
ta another-project
```

---

## 高度なテクニック

### 1. 複数のセッションを同時に実行

```bash
# メインプロジェクト
tmux new -s main -c ~/projects/main
# Neovim起動、作業開始
# Ctrl+a + d でデタッチ

# サイドプロジェクト
tmux new -s side -c ~/projects/side
# 作業開始
# Ctrl+a + d でデタッチ

# セッション一覧
tmux ls
# main: 2 windows
# side: 1 windows
```

### 2. セッション間でペインを移動

```bash
# セッションAからセッションBへペインを移動
# セッションAで:
Ctrl+a + :              # コマンドモード
:join-pane -t sesisonB:  # セッションBにペインを結合
```

### 3. Neovimセッションも保存

**Neovim側の設定**（追加推奨）:

```lua
-- ~/.config/nvim/lua/plugins/autosave.lua
return {
  'rmagatti/auto-session',
  config = function()
    require('auto-session').setup {
      auto_session_suppress_dirs = { '~/', '~/Projects', '~/Downloads' },
      session_lens = {
        load_on_setup = true,
      },
    }
  end,
}
```

### 4. スクロールバックバッファの活用

```bash
# コピーモードに入る
Ctrl+a + [

# ナビゲーション（Vim風キーバインド）
j/k       # 上下移動
Ctrl+d/u  # ページスクロール
gg/G      # 先頭/末尾へ
/         # 検索
v         # 選択開始
y         # 選択範囲をコピー（クリップボードへ）
q         # コピーモード終了
```

### 5. ペインテンプレートの作成

```bash
# ~/.tmux/layouts.conf にレイアウト定義
# またはスクリプトで自動化

# 複雑なレイアウトを一発で作成
tmux load-buffer <<EOF
# ここにレイアウト定義
EOF
```

---

## トラブルシューティング

### セッションが復元されない

```bash
# Continuumステータス確認
tmux show-environment -g | grep continuum

# 手動復元
Ctrl+a + Ctrl+r
```

### ペインが小さすぎる/大きすぎる

```bash
# 均等分割
Ctrl+a + :              # コマンドモード
:select-layout even-horizontal
:select-layout even-vertical

# プリセットレイアウト
:select-layout main-horizontal   # メインペイン + 下部サブペイン
:select-layout main-vertical     # メインペイン + 右部サブペイン
:select-layout tiled              # 全ペイン均等タイル
```

### Neovimとのキーバインド衝突

```bash
# 衝突するキーバインドを確認
:tnext    # tmuxの次のウィンドウ
# Neovimでも使用している場合

# 解決策: tmux側を変更
# ~/.tmux.conf で設定
bind C-n next-window
bind C-p previous-window
```

### クリップボードが使えない

```bash
# wl-clipboardがインストールされているか確認
pacman -Q wl-clipboard

# tmux設定でWaylandクリップボード使用
# ~/.tmux.conf で既に設定済み:
bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "wl-copy"
```

---

## エイリアス一覧

**既存のzshrcエイリアス**:

```bash
t          # tmux
ta         # tmux attach -t
tl         # tmux list-sessions
tn         # tmux new-session -s
tk         # tmux kill-session -t

dev        # デフォルトCodeレイアウト
nixdev     # NixOS設定用Codeレイアウト
```

**追加推奨エイリアス**:

```bash
# ~/.zshrc に追加
alias dev-claude='~/rudra/scripts/tmux-dev-layout.sh claude'
alias dev-git='~/rudra/scripts/tmux-dev-layout.sh git'
alias tls='tmux ls'
alias tkill='tmux kill-server'
alias tsave='tmux save-buffer -'
```

---

## まとめ

### 基本フロー

1. **開発開始**: `dev` または `nixdev`
2. **作業中**: 自動保存されるので気にせず作業
3. **終了時**: `Ctrl+a + d` でデタッチ（セッション維持）
4. **再開**: `ta セッション名` でアタッチ

### 自動保存される

- ✅ 15分ごとの自動保存
- ✅ システム終了時も維持
- ✅ tmux起動時に自動復元

### 統合されている

- ✅ Neovim: vim-tmux-navigatorでシームレス移動
- ✅ LazyGit: `<leader>gg` で起動
- ✅ Claude Code: 専用レイアウトでAIアシスト

**完全な開発環境が整いました！** 🎉
