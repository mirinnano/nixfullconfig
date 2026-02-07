# 🎮 Hyprland キーバインド完全ガイド
# Hyprland Keybindings Complete Guide

このガイドでは、Hyprland環境で使用できる全てのキーバインドを説明します。
This guide explains all available keybindings in your Hyprland environment.

**メインモディファイア / Main Modifier:** `Super` (Windowsキー / Windows Key)

---

## 📋 目次 / Table of Contents

1. [基本操作 / Basic Operations](#基本操作--basic-operations)
2. [アプリケーション起動 / Application Launch](#アプリケーション起動--application-launch)
3. [ウィンドウ管理 / Window Management](#ウィンドウ管理--window-management)
4. [ワークスペース / Workspaces](#ワークスペース--workspaces)
5. [スクリーンショット / Screenshots](#スクリーンショット--screenshots)
6. [システム / System](#システム--system)
7. [ゲーム関連 / Gaming](#ゲーム関連--gaming)
8. [マウス操作 / Mouse Operations](#マウス操作--mouse-operations)

---

## 基本操作 / Basic Operations

| キー / Key | 機能 / Function |
|-----------|----------------|
| `Super + Enter` | ターミナル起動 (Alacritty) / Launch terminal |
| `Super + Shift + Enter` | 第2ターミナル起動 (Ghostty) / Launch 2nd terminal |
| `Super + Q` | アクティブウィンドウを閉じる / Close active window |
| `Super + Shift + Q` | ログアウトメニュー (wlogout) / Logout menu |
| `Super + Shift + Ctrl + M` | Hyprland終了 / Exit Hyprland |
| `Super + F11` | フルスクリーン切替 / Toggle fullscreen |
| `Super + Shift + F11` | 最大化 / Maximize |
| `Super + Shift + F` | フルスクリーン (代替) / Fullscreen (alt) |
| `Super + O` | 画面ロック / Lock screen |

---

## アプリケーション起動 / Application Launch

| キー / Key | アプリケーション / Application |
|-----------|----------------------------|
| `Super + F` | ブラウザ (Zen) / Browser (Zen) |
| `Super + B` | Braveブラウザ / Brave browser |
| `Super + E` | ファイルマネージャ (Thunar) / File manager |
| `Super + C` | VSCode / Code editor |
| `Super + T` | Telegram / Telegram messenger |
| `Super + G` | Steam / Steam client |
| `Super + D` | DMS検索 / DMS Search |

### 💡 よく使うアプリ / Common Apps
- **Zen Browser:** 日常使い、YouTube、SNS / Daily use, YouTube, SNS
- **Brave:** プライバシー重視、広告ブロック / Privacy-focused, ad blocking
- **Thunar:** 軽量ファイルマネージャ / Lightweight file manager
- **Steam:** ゲーム起動（WS7に自動配置） / Game launcher (auto WS7)

---

## ウィンドウ管理 / Window Management

### フォーカス移動 / Focus Movement (Vim + 矢印 / Arrows)
| キー / Key | 方向 / Direction |
|-----------|----------------|
| `Super + h` or `Super + ←` | 左 / Left |
| `Super + l` or `Super + →` | 右 / Right |
| `Super + k` or `Super + ↑` | 上 / Up |
| `Super + j` or `Super + ↓` | 下 / Down |

### ウィンドウ移動 / Move Window (Vim + 矢印 / Arrows)
| キー / Key | 方向 / Direction |
|-----------|----------------|
| `Super + Shift + h` or `Super + Shift + ←` | 左 / Left |
| `Super + Shift + l` or `Super + Shift + →` | 右 / Right |
| `Super + Shift + k` or `Super + Shift + ↑` | 上 / Up |
| `Super + Shift + j` or `Super + Shift + ↓` | 下 / Down |

### ウィンドウリサイズ / Resize Window (Vim + 矢印 / Arrows)
| キー / Key | サイズ変更 / Resize |
|-----------|-------------------|
| `Super + Ctrl + h` or `Super + Ctrl + ←` | 左に縮小 / Shrink left (-40px) |
| `Super + Ctrl + l` or `Super + Ctrl + →` | 右に拡大 / Expand right (+40px) |
| `Super + Ctrl + k` or `Super + Ctrl + ↑` | 上に縮小 / Shrink up (-40px) |
| `Super + Ctrl + j` or `Super + Ctrl + ↓` | 下に拡大 / Expand down (+40px) |

### ウィンドウ特殊操作 / Window Special Actions
| キー / Key | 機能 / Function |
|-----------|----------------|
| `Super + W` | フローティング切替 / Toggle floating |
| `Super + P` | 疑似タイル / Pseudo-tiling |
| `Super + J` | スプリット方向切替 / Toggle split direction |
| `Super + X` | 全ワークスペースに固定 / Pin to all workspaces |

---

## ワークスペース / Workspaces

### ワークスペース構成 / Workspace Layout
| WS | 用途 / Purpose | 自動配置アプリ / Auto-assigned Apps |
|----|--------------|--------------------------------|
| **WS1** | デフォルト / Default | 汎用 / General |
| **WS2** | ブラウザ / Browser | Zen, Firefox, Brave, Chrome |
| **WS3** | 開発 / Development | VSCode, JetBrains, Zed |
| **WS4** | コミュニケーション / Communication | Vesktop, Discord, Telegram, Element |
| **WS5** | メディア / Media | YouTube Music, Spotify |
| **WS6** | 予備 / Reserved | - |
| **WS7** | ゲーム / Gaming | Steam, Lutris, ゲーム / Games |
| **WS8** | 仮想マシン / VM | Virt-Manager, QEMU |
| **WS-S** | スクラッチパッド / Scratchpad | 一時ウィンドウ / Temp windows |

### ワークスペース切替 / Switch Workspace
| キー / Key | ワークスペース / Workspace |
|-----------|-------------------------|
| `Super + 1-9, 0` | WS1-10に切替 / Switch to WS1-10 |
| `Super + マウスホイール` | 前後のWSに移動 / Scroll through WS |

### ウィンドウ移動 (無音) / Move Window (Silent)
**自分は現在のWSに残る / You stay in current WS**
| キー / Key | 移動先 / Destination |
|-----------|-------------------|
| `Super + Shift + 1-9, 0` | WS1-10に移動 / Move to WS1-10 |

### ウィンドウと一緒に移動 / Move with Window
**ウィンドウと一緒にWSを移動 / Follow window to WS**
| キー / Key | 移動先 / Destination |
|-----------|-------------------|
| `Super + Alt + 1-9, 0` | WS1-10に一緒に移動 / Move together to WS1-10 |

### スクラッチパッド / Scratchpad
| キー / Key | 機能 / Function |
|-----------|----------------|
| `Super + S` | スクラッチパッド表示切替 / Toggle scratchpad |
| `Super + Shift + S` | 現在のウィンドウをスクラッチパッドに / Move to scratchpad |

---

## スクリーンショット / Screenshots

### クイック操作 / Quick Actions
| キー / Key | 機能 / Function |
|-----------|----------------|
| `Print` | スクショメニュー表示 (6オプション) / Screenshot menu (6 options) |
| `Shift + Print` | 範囲選択 → 保存 & クリップボード / Area → Save & Copy |
| `Ctrl + Print` | 全画面 → 保存 & クリップボード / Fullscreen → Save & Copy |
| `Ctrl + Shift + Print` | 範囲選択 → Swappyで編集 / Area → Edit with Swappy |

### メニューオプション (Print) / Menu Options
1. **Selected area:** 範囲選択 → 保存 / Area → Save
2. **Selected area (edit):** 範囲 → Swappyで編集 / Area → Edit
3. **Fullscreen:** 全画面保存 / Save fullscreen
4. **Fullscreen (edit):** 全画面 → 編集 / Fullscreen → Edit
5. **Active window:** アクティブウィンドウ保存 / Save active window
6. **Active window (edit):** ウィンドウ → 編集 / Window → Edit

**保存先 / Save Location:** `~/Pictures/Screenshots/`

---

## システム / System

### 音量 / Volume
| キー / Key | 機能 / Function |
|-----------|----------------|
| `XF86AudioRaiseVolume` | 音量+5% / Volume +5% |
| `XF86AudioLowerVolume` | 音量-5% / Volume -5% |
| `XF86AudioMute` | ミュート切替 / Toggle mute |
| `XF86AudioMicMute` | マイクミュート切替 / Toggle mic mute |

### 明るさ / Brightness
| キー / Key | 機能 / Function |
|-----------|----------------|
| `XF86MonBrightnessUp` | 明るさ+10% / Brightness +10% |
| `XF86MonBrightnessDown` | 明るさ-10% / Brightness -10% |

### メディア再生 / Media Control
| キー / Key | 機能 / Function |
|-----------|----------------|
| `XF86AudioPlay` | 再生/一時停止 / Play/Pause |
| `XF86AudioPause` | 一時停止 / Pause |
| `XF86AudioNext` | 次のトラック / Next track |
| `XF86AudioPrev` | 前のトラック / Previous track |

### クリップボード履歴 / Clipboard History
| キー / Key | 機能 / Function |
|-----------|----------------|
| `Alt + V` | クリップボード履歴表示 (Rofi) / Show clipboard history |

**使い方 / Usage:**
1. 通常通りコピー / Copy as usual (`Ctrl+C`)
2. `Alt+V` で履歴表示 / Press `Alt+V` for history
3. 矢印キーで選択、Enter / Select with arrows, Enter to paste
4. 画像もサポート / Images supported

---

## ゲーム関連 / Gaming

### MangoHud (ゲーム中) / MangoHud (In-Game)
| キー / Key | 機能 / Function |
|-----------|----------------|
| `Shift_R + F12` | MangoHud表示切替 / Toggle overlay |
| `Shift_R + F1` | FPS制限切替 (0/60/120/144/165/240) / Toggle FPS limit |
| `Shift_R + F2` | ロギング開始/停止 / Start/Stop logging |
| `Shift_R + F3` | ログアップロード / Upload log |
| `Shift_R + F4` | 設定リロード / Reload config |

### GameMode
GameModeは自動で有効化されます。手動起動したい場合：
GameMode activates automatically. For manual launch:

```bash
gamemoderun <command>
mangohud gamemoderun steam  # SteamをGameMode+MangoHudで起動
```

### 仮想マシンパススルー / VM Passthrough
| キー / Key | 機能 / Function |
|-----------|----------------|
| `Super + P` | VMパススルーモード開始 / Start VM passthrough |
| `Super + Escape` | パススルー解除 / Exit passthrough |

パススルーモード中は、全てのキー入力がVMに送られます。
In passthrough mode, all key inputs are sent to the VM.

---

## マウス操作 / Mouse Operations

| 操作 / Operation | 機能 / Function |
|-----------------|----------------|
| `Super + 左クリック + ドラッグ` | ウィンドウ移動 / Move window |
| `Super + 右クリック + ドラッグ` | ウィンドウリサイズ / Resize window |
| `Super + マウスホイール↑` | 次のワークスペース / Next workspace |
| `Super + マウスホイール↓` | 前のワークスペース / Previous workspace |

---

## 🎯 よく使う操作クイックリファレンス / Quick Reference

### ゲーマー向け / For Gamers
```
Super + G           → Steam起動
Super + 7           → ゲーム用WS7に移動
Shift_R + F12       → MangoHud表示/非表示
Super + Shift + F   → ゲームをフルスクリーン
```

### 日常使い / Daily Use
```
Super + F           → ブラウザ起動
Super + E           → ファイルマネージャ
Print               → スクリーンショットメニュー
Alt + V             → クリップボード履歴
Super + D           → アプリ/ファイル検索
```

### 開発者向け / For Developers
```
Super + C           → VSCode起動
Super + 3           → 開発用WS3に移動
Super + Enter       → ターミナル起動
Super + Shift + Q   → ログアウトメニュー
```

### ウィンドウ整理 / Window Organization
```
Super + h/j/k/l     → フォーカス移動 (Vim)
Super + Shift + [1-9] → ウィンドウを別WSに移動
Super + W           → フローティング切替
Super + F11         → フルスクリーン
```

---

## 📝 追加情報 / Additional Info

### キーバインドのカスタマイズ / Customizing Keybindings
設定ファイル / Config file:
```
~/.config/hypr/keybindings.conf
```

変更後は `Super + Shift + R` または Hyprland再起動で反映
Changes apply with `Super + Shift + R` or Hyprland restart

### Capslock = Ctrl
この環境では `Capslock` が `Ctrl` として機能します。
In this environment, `Capslock` functions as `Ctrl`.

設定箇所 / Config location:
```conf
input {
    kb_options=ctrl:nocaps
}
```

---

## 🔗 関連ドキュメント / Related Docs

- [Hyprland Wiki](https://wiki.hyprland.org/)
- [MangoHud Documentation](https://github.com/flightlessmango/MangoHud)
- [GameMode Documentation](https://github.com/FeralInteractive/gamemode)

---

**最終更新 / Last Updated:** 2026-02-06
**バージョン / Version:** Hyprland 0.53+
