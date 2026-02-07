# DMS Read-Only File System 問題 - 修正

## 🔍 問題の本質

**あなたの指摘が正しいです！** DMSが起動できない原因は：

### NixOSの不変（Immutable）システム

NixOSでは以下のディレクトリが**読み取り専用**：
- `/nix/store` - すべてのパッケージ（完全にread-only）
- `/etc` - システム設定（主にシンボリンク、read-only）
- `/usr` - 存在しない（NixOSの設計）
- `/bin`, `/lib` - 最小限のシンボリンク

**書き込み可能なディレクトリ：**
- `/home/username` - ユーザーホームディレクトリ
- `/tmp`, `/var/tmp` - 一時ファイル
- `/var` - システム状態

---

## ⚠️ DMSの問題

DMSのmatugen（テーマジェネレーター）が、NixOS管理下の**read-onlyディレクトリ**に書き込もうとしている：

```
Feb 07 15:37:08 rudra dms[3629]: Error:
Feb 07 15:37:08 rudra dms[3629]:    0: Read-only file system (os error 30)
Feb 07 15:37:08 rudra dms[3445]:  ERROR  go: DMS API Error: id=1 error=exit status 1
Feb 07 15:37:08 rudra dms[3475]:   WARN qml: Theme: Matugen worker failed with exit code: 1
```

**推測される問題：**
- Matugenがデフォルトで`/etc/DankMaterialShell`に書き込もうとしている
- または、`/nix/store/...`内のDMSパッケージディレクトリに書き込もうとしている

---

## ✅ 修正方法

### 修正1: systemdサービスに環境変数を追加（既に適用済み）

`configuration.nix`に追加：

```nix
# DMSサービスの環境変数（read-only問題修正）
systemd.user.services.dms = {
  environment = {
    # matugenがユーザーディレクトリに書き込むように設定
    HOME = "/home/${username}";
    XDG_CONFIG_HOME = "/home/${username}/.config";
    XDG_CACHE_HOME = "/home/${username}/.cache";
    XDG_DATA_HOME = "/home/${username}/.local/share";
    XDG_STATE_HOME = "/home/${username}/.local/state";
  };
};
```

### 修正2: ディレクトリ作成とパーミッション設定

```bash
# 必要なディレクトリを事前作成
mkdir -p ~/.config/DankMaterialShell
mkdir -p ~/.cache/DankMaterialShell
mkdir -p ~/.cache/matugen
mkdir -p ~/.local/share/DankMaterialShell
mkdir -p ~/.local/state/DankMaterialShell

# パーミッション設定
chmod 755 ~/.config/DankMaterialShell
chmod 755 ~/.cache/DankMaterialShell
chmod 755 ~/.cache/matugen
chmod 755 ~/.local/share/DankMaterialShell
chmod 755 ~/.local/state/DankMaterialShell
```

### 修正3: DMSの設定ファイルで出力先を明示（オプション）

`~/.config/DankMaterialShell/settings.json`を確認・編集：

```json
{
  "theme": {
    "cache_dir": "$HOME/.cache/DankMaterialShell",
    "config_dir": "$HOME/.config/DankMaterialShell"
  }
}
```

---

## 🧪 テスト

### 1. システム再構築

```bash
cd ~/rudra
sudo nixos-rebuild switch --flake .#summerpockets
```

### 2. ディレクトリ準備

```bash
mkdir -p ~/.config/DankMaterialShell ~/.cache/DankMaterialShell ~/.cache/matugen ~/.local/share/DankMaterialShell ~/.local/state/DankMaterialShell
chmod 755 ~/.config/DankMaterialShell ~/.cache/DankMaterialShell ~/.cache/matugen ~/.local/share/DankMaterialShell ~/.local/state/DankMaterialShell
```

### 3. DMSサービス再起動

```bash
systemctl --user daemon-reload
systemctl --user restart dms.service
```

### 4. ログ確認

```bash
journalctl --user -u dms.service -f
```

**期待される動作：**
- `Read-only file system`エラーが出ない
- `Theme generation failed`エラーが出ない
- DMSが正常に起動

---

## 🔍 デバッグ

### エラーが続く場合

#### ステップ1: 環境変数確認

```bash
systemctl --user show dms.service | grep Environment
```

**期待される出力：**
```
Environment=HOME=/home/mirin XDG_CONFIG_HOME=/home/mirin/.config ...
```

#### ステップ2: Matugen手動実行テスト

```bash
# Matugenを手動で実行してテスト
matugen color hex D0BCFF --mode dark --verbose 2>&1
```

出力でどこに書き込もうとしているかを確認。

#### ステップ3: straceでシステムコール追跡

```bash
# DMSを一旦停止
systemctl --user stop dms.service

# straceで追跡しながら起動
strace -f -e trace=openat,mkdir,write -o /tmp/dms-trace.log systemctl --user start dms.service

# トレースログ確認
grep -i "EROFS\|EACCES\|Permission denied" /tmp/dms-trace.log
```

これで、どのパスに書き込もうとしているかが明確になります。

---

## 💡 代替案: NixOS Home Managerでの管理

より根本的な解決策として、Home Managerを使ってDMS設定を管理：

### `hosts/summerpockets/home.nix`

```nix
{
  # DMS設定ディレクトリを管理
  home.file.".config/DankMaterialShell/.keep".text = "";

  xdg.configFile."DankMaterialShell/settings.json" = {
    source = ../../config/dms/settings.json;
  };

  # キャッシュディレクトリの作成
  home.activation.dmsDirs = lib.hm.dag.entryAfter ["writeBoundary"] ''
    mkdir -p ~/.cache/DankMaterialShell
    mkdir -p ~/.cache/matugen
    mkdir -p ~/.local/share/DankMaterialShell
    mkdir -p ~/.local/state/DankMaterialShell
  '';
}
```

---

## 📊 確認ポイント

### ✅ 成功の確認

```bash
# 1. DMSが起動している
systemctl --user status dms.service
# → Active: active (running)

# 2. エラーログがない
journalctl --user -u dms.service --since "1 minute ago" | grep -i "error\|failed"
# → Read-only file systemエラーが出ない

# 3. テーマファイルが生成されている
ls -la ~/.cache/DankMaterialShell/
# → テーマファイルが存在する
```

---

## 🎯 まとめ

### 問題の原因
- NixOSはimmutableシステム
- DMSのmatugenがread-onlyディレクトリに書き込もうとしている

### 解決策
1. ✅ systemdサービスに環境変数を追加（既に適用）
2. ✅ 書き込み可能なディレクトリを事前作成
3. ⏳ 必要に応じてDMS設定で出力先を明示

### 次のステップ
```bash
# システム再構築
sudo nixos-rebuild switch --flake ~/rudra/.#summerpockets

# ディレクトリ準備
mkdir -p ~/.config/DankMaterialShell ~/.cache/DankMaterialShell ~/.cache/matugen ~/.local/share/DankMaterialShell ~/.local/state/DankMaterialShell

# DMS再起動
systemctl --user daemon-reload
systemctl --user restart dms.service

# ログ確認
journalctl --user -u dms.service -f
```

問題が解決しない場合は、`strace`で正確な書き込み先を特定してください！
