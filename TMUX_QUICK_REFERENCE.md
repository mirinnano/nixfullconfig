# tmux開発環境 クイックリファレンス

## 🚀 起動方法

### キーボードショートカット（Hyprland）
| キー                    | 動作                                    |
|------------------------|----------------------------------------|
| `Super + Shift + Enter` | tmux開発環境（カレントディレクトリ）      |
| `Super + Ctrl + Enter`  | tmux開発環境（nixos設定）               |
| `Super + Alt + Enter`   | 通常のGhostty（tmux無し）               |

### ターミナルコマンド
```bash
# レイアウト起動
dev                    # Codeレイアウト（Neovim + Terminal×2）
nixdev                 # nixos設定で開発環境起動
dev-claude             # Claude Codeレイアウト（Neovim + Term + Claude）
dev-claude-main        # Claude Codeメインレイアウト（Claude 70%）
dev-git                # Gitレイアウト（Neovim + Lazygit + Terminal）

# 🆕 Claude Repository（Claude-First Philosophy）
repo <name> <path> claude-repo    # 新規レポジトリ作成
dev-list                      # レポジトリ一覧（美しい表示）
repos                         # レポジトリ一覧（シンプル）
dev-attach <name>             # レポジトリにアタッチ
dev-interactive               # インタラクティブ選択（fzf）

# セッション管理
t                      # tmux起動
ta <session>           # セッションにアタッチ
tl                     # セッション一覧
tls                    # セッション一覧（短縮版）
tn <name>              # 新規セッション作成
tk <name>              # セッション削除
```

---

## ⌨️ tmuxキーバインド

### プレフィックスキー: `Ctrl+a`

### ペイン操作
| キー              | 動作                     |
|------------------|-------------------------|
| `Ctrl+a, \|`      | 垂直分割                 |
| `Ctrl+a, -`       | 水平分割                 |
| `Ctrl+a, h/j/k/l` | ペイン移動（Vim風）      |
| `Ctrl+a, H/J/K/L` | ペインリサイズ           |
| `Ctrl+a, x`       | ペイン削除               |
| `Ctrl+a, z`       | ペイン最大化/復元        |

### ウィンドウ操作
| キー           | 動作                 |
|---------------|---------------------|
| `Ctrl+a, c`    | 新規ウィンドウ       |
| `Ctrl+a, n`    | 次のウィンドウ       |
| `Ctrl+a, p`    | 前のウィンドウ       |
| `Ctrl+a, 0-9`  | ウィンドウ番号で移動 |
| `Ctrl+a, ,`    | ウィンドウ名変更     |
| `Ctrl+a, &`    | ウィンドウ削除       |

### セッション操作
| キー          | 動作                 |
|--------------|---------------------|
| `Ctrl+a, d`   | デタッチ             |
| `Ctrl+a, s`   | セッション一覧       |
| `Ctrl+a, $`   | セッション名変更     |

### その他
| キー              | 動作                     |
|------------------|-------------------------|
| `Ctrl+a, r`       | 設定リロード             |
| `Ctrl+a, [`       | コピーモード             |
| `Ctrl+a, ?`       | キーバインド一覧         |
| `Ctrl+a, Ctrl+s`  | セッション手動保存       |
| `Ctrl+a, Ctrl+r`  | セッション復元           |

### コピーモード（`Ctrl+a, [`で起動）
| キー    | 動作                     |
|--------|-------------------------|
| `v`     | 選択開始                 |
| `y`     | コピー（クリップボード）  |
| `q`     | コピーモード終了         |

---

## 🔀 Neovim + tmux統合

### シームレスナビゲーション
| キー       | 動作                              |
|-----------|----------------------------------|
| `Ctrl+h`   | 左のペイン/ウィンドウに移動       |
| `Ctrl+j`   | 下のペイン/ウィンドウに移動       |
| `Ctrl+k`   | 上のペイン/ウィンドウに移動       |
| `Ctrl+l`   | 右のペイン/ウィンドウに移動       |

### Lazygit
| キー         | 動作                    |
|-------------|------------------------|
| `<leader>gg` | Neovim内でLazygit起動   |

---

## 📁 開発レイアウト

### 0. Claude Repository レイアウト 🆕 **（Claude-First Philosophy）**
```
┌─────────────────────────┬──────────────┐
│                         │              │
│   Claude Code Main      │  Claude Sub  │
│        (70%)            │    (20%)     │
│   🎯 メイン開発          │  🔬 調査・実験 │
│                         │              │
├─────────────────────────┤              │
│      Terminal (10%)     │              │
│      ⚡ コマンド実行      │              │
└─────────────────────────┴──────────────┘
```
**起動**: `repo <name> <path> claude-repo`

**理念**: tmuxセッション = レポジトリ。Neovimなし、Claude Codeがメイン。

**使用例**:
```bash
# 新規レポジトリ作成
repo myproject ~/projects/myproject claude-repo

# レポジトリ一覧
dev-list

# アタッチ
ta myproject
```

**詳細ガイド**: `~/rudra/CLAUDE_FIRST_WORKFLOW.md`

---

### 1. Code レイアウト（デフォルト）
```
┌───────────────────────┬──────────────────┐
│                       │                  │
│                       │  メインターミナル  │
│    Neovim (70%)       │  (テスト実行)     │
│                       │                  │
│                       ├──────────────────┤
│                       │                  │
│                       │ サブターミナル    │
│                       │  (ログ監視)      │
└───────────────────────┴──────────────────┘
```
**起動**: `dev`

### 2. Claude Code メイン レイアウト 🆕
```
┌─────────────────────────┬──────────────┐
│                         │              │
│      Claude Code        │   Neovim     │
│        (70%)            │    (20%)     │
│                         │              │
├─────────────────────────┤              │
│      Terminal (10%)     │              │
│                         │              │
└─────────────────────────┴──────────────┘
```
**起動**: `dev-claude-main` または `Super+Shift+Alt+C`
- 左: Claude Code（メイン - `claude` またはブラウザ）
- 右上: Neovim（コード編集）
- 右下: Terminal（コマンド実行）

### 3. Claude Code レイアウト（バランス型）
```
┌────────────┬────────────┬────────────┐
│            │            │            │
│  Neovim    │ Terminal   │  Claude    │
│  (50%)     │  (25%)     │  (25%)     │
│            │            │            │
└────────────┴────────────┴────────────┘
```
**起動**: `dev-claude`
- 左: Neovimでコード編集
- 中: コマンド実行（テスト・ビルド）
- 右: Claude Code（`claude` または `gh copilot`）

### 3. Git レイアウト
```
┌───────────────────────┬──────────────┐
│                       │              │
│                       │   Lazygit   │
│    Neovim (70%)       │  (Git操作)  │
│                       │              │
│                       ├──────────────┤
│                       │              │
│                       │  Terminal    │
└───────────────────────┴──────────────┘
```
**起動**: `dev-git`

---

## 💡 ヒント

### セッション管理
- セッション名をプロジェクト名にすると管理しやすい
- 複数プロジェクトを同時に開発する場合、各プロジェクトで別セッション

### ワークフロー例
```bash
# プロジェクトAの作業
dev projectA ~/projects/project-a

# デタッチ（Ctrl+a, d）

# プロジェクトBの作業
dev projectB ~/projects/project-b

# セッション一覧確認
tl

# プロジェクトAに戻る
ta projectA
```

### カスタマイズ
- `~/.tmux.conf`: tmux設定
- `~/rudra/scripts/tmux-dev-layout.sh`: レイアウトスクリプト
- `~/rudra/dotfiles/.config/nvim/lua/vj/plugins/tmux.lua`: Neovim統合

---

## 🔧 トラブルシューティング

### 問題: 色が正しく表示されない
```bash
# ターミナル設定確認
echo $TERM
# 期待値: screen-256color または tmux-256color
```

### 問題: Ctrl+h/j/k/lが効かない
1. tmux設定リロード: `Ctrl+a, r`
2. Neovim再起動

### 問題: プラグインが動作しない
```bash
# tmux内で
Ctrl+a, I  # プラグイン再インストール
```

---

## 📚 詳細ドキュメント

完全なセットアップガイドは `TMUX_SETUP.md` を参照
