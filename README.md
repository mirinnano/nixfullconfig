# NixOS Hyprland Configuration

<img src="https://img.shields.io/badge/NixOS-24.11-blue.svg" alt="NixOS 24.11"/>
<img src="https://img.shields.io/badge/WM-Hyprland-0077ff.svg" alt="Hyprland"/>
<img src="https://img.shields.io/badge/Shell-Fish-4A8F8F.svg" alt="Fish"/>
<img src="https://img.shields.io/badge/Terminal-Ghostty-FF6C00.svg" alt="Ghostty"/>
<img src="https://img.shields.io/badge/Editor-Neovim-57A143.svg" alt="Neovim"/>

最適化されたNixOS Hyprland環境。Claude Codeを中心とした開発ワークフロー、tmuxセッション管理、Fishシェルによる高速な操作を特徴とします。

## 📋 目次

- [システムアーキテクチャ](#システムアーキテクチャ)
- [主要機能](#主要機能)
- [ファイル構造](#ファイル構造)
- [キーバインド](#キーバインド)
- [開発ワークフロー](#開発ワークフロー)
- [セットアップ](#セットアップ)
- [トラブルシューティング](#トラブルシューティング)

---

## 🏗️ システムアーキテクチャ

```
┌─────────────────────────────────────────────────────────────────┐
│                        NixOS (Summerpockets)                     │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │                    Hyprland (Wayland Compositor)         │  │
│  │  ┌─────────────────────────────────────────────────────┐  │  │
│  │  │          DankMaterialShell (DMS) - Bar              │  │  │
│  │  └─────────────────────────────────────────────────────┘  │  │
│  │                                                           │  │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐    │  │
│  │  │   Workspace  │  │   Workspace  │  │   Workspace  │    │  │
│  │  │      1       │  │      2       │  │      3       │    │  │
│  │  │  (Browser)   │  │  (Terminal)  │  │   (Editor)   │    │  │
│  │  └──────────────┘  └──────────────┘  └──────────────┘    │  │
│  └───────────────────────────────────────────────────────────┘  │
│                                                                 │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │               System Services (systemd)                   │  │
│  │  auto-cpufreq, thermald, ananicy, libvirtd, Docker       │  │
│  └───────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                    Development Environment                      │
│                                                                 │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐         │
│  │   Ghostty    │  │    tmux      │  │   Claude     │         │
│  │  + Fish      │  │   Sessions   │  │    Code      │         │
│  │              │  │              │  │              │         │
│  │ • Abbreviations│ • dev (code) │  │ • AI Editor  │         │
│  │ • Starship   │  │ • claude    │  │ • Chat Mode  │         │
│  │ • Vim Mode   │  │ • git       │  │ • Continue   │         │
│  └──────────────┘  └──────────────┘  └──────────────┘         │
│                                                                 │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐         │
│  │   Neovim     │  │   Lazygit    │  │   Yazi       │         │
│  │              │  │              │  │  (File Mgr)  │         │
│  │ • LSP        │  │ • Git TUI    │  │ • Image Preview│       │
│  │ • Treesitter │  │ • Visual     │  │ • Quick Nav  │         │
│  │ • Telescope  │  │   Diff       │  │              │         │
│  └──────────────┘  └──────────────┘  └──────────────┘         │
└─────────────────────────────────────────────────────────────────┘
```

## ✨ 主要機能

### 🖥️ デスクトップ環境
- **Hyprland**: Waylandコンポジタ、タイル型ウィンドウマネージャー
- **DankMaterialShell (DMS)**: モダンなバー、通知システム、アプリケーションランチャー
- **Multi-monitor**: モニター間でのワークスペース/ウィンドウ移動

### 🐚 シェル環境
- **Fish Shell**: 高度な自動補完、略語システム、Vimモード
- **Ghostty**: 高速なGPUアクセラレーテッドターミナル
- **Starship**: カスタマイズ可能なプロンプト

### 📁 tmuxセッション管理
```
claude-repo レイアウト:
┌──────────────────────────────────────────────────────────────┐
│  Claude Main (70%)  │  Claude Sub (20%)  │  Terminal (10%)  │
│                     │                     │                  │
│  • AI Chat          │  • Secondary Chat   │  • Fish Shell    │
│  • Code Generation  │  • Documentation   │  • Commands      │
└──────────────────────────────────────────────────────────────┘
```

**使用可能なレイアウト**:
- `dev` - 標準開発環境 (Claude 70% + Terminal 20% + Shell 10%)
- `nixdev` - NixOS設定開発 (Claude + Neovim + Terminal)
- `dev-git` - Git環境 (Neovim 70% + Lazygit + Terminal)

### 🎯 Claude Code統合
- **c** / **cc** - Claude Code起動
- **c-continue** - 前回の会話を継続
- **c-muso** - 無双モード（権限制限なし）

### ⚡ パフォーマンス最適化
- **CPU**: auto-cpufreqでschedutilパワーガバナー
- **メモリ**: zram (zstd compression, 25% サイズ)
- **GPU**: NVIDIA forceFullCompositionPipeline
- **ブート**: 不要なサービスを遅延/無効化

## 📂 ファイル構造

```
~/rudra/
├── flake.nix                           # NixOS Flakeエントリーポイント
├── hosts/
│   └── summerpockets/                  # ホスト固有設定
│       ├── configuration.nix           # システム設定
│       ├── hardware.nix                # ハードウェア設定
│       ├── user.nix                    # ユーザーモジュール
│       └── home.nix                    # ホームマネージャー設定
├── modules/                            # 再利用可能なモジュール
│   ├── nvidia-drivers.nix              # NVIDIAドライバー設定
│   ├── amd-drivers.nix                 # AMDドライバー設定
│   └── virtualization.nix              # 仮想化設定
├── scripts/                            # ユーティリティスクリプト
│   ├── tmux-dev-layout.sh              # tmux開発レイアウト
│   ├── setup-tmux-env.sh               # tmux環境セットアップ
│   └── power-profile-manager.sh        # 電源プロファイル管理
└── dotfiles/                           # 設定ファイルのシンボリックリンク元
    ├── .config/
    │   ├── fish/config.fish            # Fishシェル設定
    │   ├── ghostty/config              # Ghosttyターミナル設定
    │   ├── hypr/                       # Hyprland設定
    │   │   ├── hyprland.conf           # Hyprlandメイン設定
    │   │   ├── keybindings.conf        # キーバインド
    │   │   └── rules.conf              # ウィンドウルール
    │   ├── tmux/tmux.conf              # tmux設定
    │   ├── nvim/                       # Neovim設定
    │   ├── starship.toml               # Starshipプロンプト設定
    │   └── yazi/                       # Yaziファイルマネージャー設定
    ├── .gitconfig                      # Git設定
    └── .tmux.conf                      # tmux設定（ルート）
```

## ⌨️ キーバインド

### Hyprland (Super = Windows/Modキー)

| キーバインド | アクション | 説明 |
|------------|----------|------|
| `Super + Enter` | Ghostty起動 | シンプルなターミナル |
| `Super + Shift + Enter` | tmuxセッション | tmuxを起動 |
| `Super + Shift + D` | 開発環境 | Claude Code開発環境 |
| `Super + Shift + G` | Git環境 | Lazygit環境 |
| `Super + Q` | ウィンドウを閉じる | アクティブウィンドウ終了 |
| `Super + Shift + Q` | ログアウト | wlogoutメニュー表示 |
| `Super + M` | 次のモニター | フォーカス移動 |
| `Super + Shift + M` | ウィンドウ移動 | 次のモニターへ |
| `Super + Ctrl + M` | ワークスペース移動 | 次のモニターへ |

### tmux (Prefix = Ctrl + a)

| キーバインド | アクション |
|------------|----------|
| `Ctrl + a c` | 新規ウィンドウ |
| `Ctrl + a n` | 次のウィンドウ |
| `Ctrl + a p` | 前のウィンドウ |
| `Ctrl + a ,` | ウィンドウ名前変更 |
| `Ctrl + a |` | 水平分割 |
| `Ctrl + a -` | 垂直分割 |
| `Ctrl + a h/j/k/l` | ペイン移動（Vimライク） |

### Fish略語（必須30個）

| 略語 | 展開 | 説明 |
|-----|------|------|
| `..` | `cd ..` | 親ディレクトリ |
| `...` | `cd ../..` | 2階層上 |
| `l` | `eza -lh --icons` | 詳細リスト |
| `ll` | `eza -lha` | 全ファイル表示 |
| `gs` | `git status` | Gitステータス |
| `gc` | `git commit -m` | コミット |
| `gpush` | `git push` | プッシュ |
| `lg` | `lazygit` | Lazygit起動 |
| `t` | `tmux` | tmux起動 |
| `ta` | `tmux attach` | セッションアタッチ |
| `tls` | `tmux ls` | セッション一覧 |
| `dev` | `tmux-dev-layout.sh` | 開発環境起動 |
| `rebuild` | `nixos-rebuild switch` | システム再構築 |
| `cc` | `claude` | Claude Code |
| `c-continue` | `claude -c` | 会話継続 |
| `cm` | `claude --dangerously-skip-permissions` | 無双モード |

## 💻 開発ワークフロー

### 1. システム更新
```fish
# NixOSシステムを再構築
rebuild

# チャンネル更新して再構築
nix-update

# 古い世代を削除
nix-clean
```

### 2. Claude Code開発
```fish
# 標準開発環境を起動
dev

# Claude Codeで会話継続
c-continue

# 無双モード（権限制限なし）
cm
```

### 3. Gitワークフロー
```fish
# ステータス確認
gs

# 変更を追加してコミット
gac "メッセージ"

# Lazygitで操作
lg

# プッシュ
gpush
```

### 4. tmuxセッション管理
```fish
# セッション一覧
tls

# 新規セッション作成
tn myproject

# セッションにアタッチ
ta myproject

# セッション削除
tk myproject
```

## 🚀 セットアップ

### 要件
- NixOS 24.11以降
- Flakes有効化
- NVIDIA GPU（最適化済み）

### インストール手順

```bash
# 1. リポジトリをクローン
git clone https://github.com/mirinnano/nixfullconfig.git ~/rudra
cd ~/rudra

# 2. ホスト名を設定（必要に応じて）
# hosts/summerpockets/ をあなたのホスト名に変更

# 3. システムをビルド
sudo nixos-rebuild switch --flake .#summerpockets

# 4. 再起動
reboot
```

### 初期設定

```bash
# Fishシェルがデフォルトになっていることを確認
echo $SHELL  # /run/current-system/sw/bin/fish

# tmuxプラグインをインストール
~/.tmux/plugins/tpm/bin/install_plugins

# 拡張略語をロード（オプション）
load-abbr
```

## 🔧 トラブルシューティング

### Fish変数の書き込みエラー
```
error: Unable to create temporary file: Read-only file system
```

**解決策**:
```bash
# Fishデータディレクトリを作成
mkdir -p ~/.local/share/fish

# システムを再ビルド
sudo nixos-rebuild switch --flake ~/rudra#summerpockets
```

### Ghostty設定エラー
```
unknown field: backend, resize-increases, click-to-copy
```

**解決策**: 設定ファイルが既に修正されています。catppuccin-macchiatoテーマを使用。

### Hyprlandが起動しない
```bash
# ログを確認
journalctl -xe | grep -i hypr

# 設定テスト
hyprctl version
```

## 📊 パフォーマンス

- **ブート時間**: ~15秒
- **メモリ使用量**: ~2.5GB (アイドル時)
- **電力消費**: 10-15W (バッテリー時)

## 🤝 貢献

バグ報告やプルリクエストはお気軽にどうぞ！

## 📄 ライセンス

MIT License

## 👤 作者

**mirinnano** - [GitHub](https://github.com/mirinnano)

---

Made with ❤️ using NixOS, Hyprland, and Claude Code
