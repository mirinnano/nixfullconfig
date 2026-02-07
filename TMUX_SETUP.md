# tmux完全統合開発環境セットアップ完了

## 実装完了した機能

### ✅ 1. tmux基本設定
- **場所:** `dotfiles/.tmux.conf`
- **プレフィックス:** `Ctrl+a`（デフォルトの`Ctrl+b`より押しやすい）
- **機能:**
  - 256色サポート + True Color
  - マウス操作対応
  - Vimライクなキーバインド
  - セッション自動保存・復元（tmux-resurrect/continuum）
  - Catppuccinテーマ

### ✅ 2. 開発レイアウト自動構築スクリプト
- **場所:** `scripts/tmux-dev-layout.sh`
- **レイアウト:**
```
┌─────────────────────────────────────────────┐
│ tmux: session [dev] window 1               │
├──────────────────────┬──────────────────────┤
│                      │                      │
│    Neovim            │    Lazygit           │
│    (コーディング)     │    (Git操作)         │
│                      │                      │
├──────────────────────┴──────────────────────┤
│ Command / Test Output                       │
└─────────────────────────────────────────────┘
```

### ✅ 3. Neovim + tmux統合
- **場所:** `dotfiles/.config/nvim/lua/vj/plugins/tmux.lua`
- **プラグイン:**
  - `vim-tmux-navigator`: `Ctrl+h/j/k/l`でNeovimとtmuxペイン間をシームレス移動
  - `lazygit.nvim`: Neovim内から`<leader>gg`でLazygit起動

### ✅ 4. Hyprlandキーバインド統合
- **場所:** `dotfiles/.config/hypr/keybindings.conf`
- **キーバインド:**
  - `Super + Shift + Enter`: Ghostty + tmux開発環境（カレントディレクトリ）
  - `Super + Ctrl + Enter`: Ghostty + tmux + nixos設定（`/home/mirin/rudra`）
  - `Super + Alt + Enter`: 通常のGhostty（tmux無し）

### ✅ 5. zshエイリアス
- **場所:** `dotfiles/.zshrc`
- **エイリアス:**
  - `t`: tmux
  - `ta <session>`: tmux attach
  - `tl`: tmux list-sessions
  - `tn <name>`: tmux new-session
  - `tk <session>`: tmux kill-session
  - `dev`: 開発環境起動（カレントディレクトリ）
  - `nixdev`: nixos設定開発環境起動

### ✅ 6. パッケージ追加
- **場所:** `hosts/summerpockets/configuration.nix`
- **追加パッケージ:**
  - tmux
  - tmuxPlugins.sensible
  - tmuxPlugins.vim-tmux-navigator
  - tmuxPlugins.resurrect
  - tmuxPlugins.continuum
  - tmuxPlugins.catppuccin

---

## セットアップ手順

### 1. システム再構築
```bash
cd ~/rudra
sudo nixos-rebuild switch --flake .#summerpockets
```

### 2. TPM（tmux Plugin Manager）インストール
```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

### 3. dotfilesリンク
```bash
# .tmux.conf
ln -sf ~/rudra/dotfiles/.tmux.conf ~/.tmux.conf

# Neovim設定（既にリンクされている場合はスキップ）
ln -sf ~/rudra/dotfiles/.config/nvim ~/.config/nvim

# zsh設定（既にリンクされている場合はスキップ）
ln -sf ~/rudra/dotfiles/.zshrc ~/.zshrc
source ~/.zshrc
```

### 4. tmuxプラグインインストール
tmuxを起動してから：
```
Ctrl+a, I  # プラグインインストール（大文字のI）
```

### 5. Hyprland設定再読み込み
```bash
# Hyprland設定リロード
hyprctl reload
```

---

## 使い方

### キーボードショートカット

#### Ghosttyから開発環境起動
- `Super + Shift + Enter`: カレントディレクトリで開発環境起動
- `Super + Ctrl + Enter`: nixos設定ディレクトリで開発環境起動
- `Super + Alt + Enter`: 通常のGhostty起動（tmux無し）

#### ターミナルから起動
```bash
# カレントディレクトリで起動
dev

# nixos設定で起動
nixdev

# カスタムセッション
~/rudra/scripts/tmux-dev-layout.sh myproject ~/path/to/project
```

#### tmux基本操作（プレフィックス: Ctrl+a）

**ペイン操作:**
- `Ctrl+a, |`: 垂直分割
- `Ctrl+a, -`: 水平分割
- `Ctrl+a, h/j/k/l`: ペイン移動（Vim風）
- `Ctrl+a, H/J/K/L`: ペインリサイズ
- `Ctrl+a, q`: ペイン番号表示

**ウィンドウ操作:**
- `Ctrl+a, c`: 新規ウィンドウ
- `Ctrl+a, n`: 次のウィンドウ
- `Ctrl+a, p`: 前のウィンドウ
- `Ctrl+a, 0-9`: ウィンドウ番号で移動
- `Ctrl+a, ,`: ウィンドウ名変更

**セッション操作:**
- `Ctrl+a, d`: デタッチ
- `Ctrl+a, s`: セッション一覧
- `Ctrl+a, $`: セッション名変更

**その他:**
- `Ctrl+a, r`: 設定リロード
- `Ctrl+a, [`: コピーモード（`v`で選択開始、`y`でコピー）
- `Ctrl+a, Ctrl+s`: セッション手動保存
- `Ctrl+a, Ctrl+r`: セッション復元

#### Neovim + tmux統合

**シームレスナビゲーション:**
- `Ctrl+h/j/k/l`: Neovimウィンドウとtmuxペイン間を移動

**Lazygit起動:**
- `<leader>gg`: Neovim内からLazygit起動

---

## セッション管理

### セッション一覧
```bash
tmux ls
# または
tl
```

### 既存セッションにアタッチ
```bash
tmux attach -t dev
# または
ta dev
```

### セッション削除
```bash
tmux kill-session -t dev
# または
tk dev
```

### 全セッション削除
```bash
tmux kill-server
```

---

## カスタマイズ

### プロジェクト固有レイアウト

各プロジェクトで異なるレイアウトが必要な場合、`.tmux.conf.local`を作成：

```bash
# プロジェクトルートに作成
cat > .tmux.conf.local << 'EOF'
# プロジェクト固有設定
bind-key T split-window -h "npm run test:watch"
EOF
```

### 自動起動セッション

`.zshrc`に追加：
```bash
# ログイン時に自動的にtmuxセッションにアタッチ
if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
    tmux attach -t default || tmux new -s default
fi
```

---

## トラブルシューティング

### 1. 色が正しく表示されない
```bash
# .tmux.confに追加済み
set -g default-terminal "screen-256color"
set -ga terminal-overrides ",*256col*:Tc"
```

### 2. Ctrl+h/j/k/lが効かない
- Neovim内の場合: `vim-tmux-navigator`プラグインが正しくインストールされているか確認
- tmux内の場合: `.tmux.conf`が正しくロードされているか確認（`Ctrl+a, r`でリロード）

### 3. セッションが自動保存されない
```bash
# tmux内で確認
tmux show-option -g @continuum-save-interval
# 15が返ってくるはずです

# 手動保存
Ctrl+a, Ctrl+s
```

### 4. プラグインが動作しない
```bash
# TPMの再インストール
rm -rf ~/.tmux/plugins/tpm
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# tmux内でプラグイン再インストール
Ctrl+a, I
```

---

## 次のステップ

### 推奨プラグイン（オプション）
1. **tmux-yank**: クリップボード統合強化
2. **tmux-fzf**: fzfでセッション・ウィンドウ管理
3. **tmux-fingers**: テキスト選択をキーボードで高速化

### ワークフロー最適化
1. **プロジェクトテンプレート**: よく使うレイアウトをスクリプト化
2. **セッション管理**: 複数プロジェクトを並行作業
3. **ペアプログラミング**: tmuxセッションを共有

---

## 参考資料

- [tmux公式ドキュメント](https://github.com/tmux/tmux/wiki)
- [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator)
- [tmux-resurrect](https://github.com/tmux-plugins/tmux-resurrect)
- [TPM](https://github.com/tmux-plugins/tpm)
