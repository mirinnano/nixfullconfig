# システム安定性修正 - 適用ガイド

## 🎯 修正内容

以下の3つの重大な問題を修正しました：

### ✅ 1. スリープ後に復帰できない問題
**原因:** NVIDIAドライバーが無効で、Nouveauが使われていた
**修正:** NVIDIA専用ドライバーを有効化 + サスペンド対応

### ✅ 2. DMS起動失敗
**原因:** `graphical-session.target`が起動していない
**修正:** `default.target`に変更 + 環境変数追加

### ✅ 3. Hyprland起動の不安定性
**原因:** NouveauとEGL/Mesaの相性問題
**修正:** NVIDIAドライバーに切り替え

---

## 📋 変更されたファイル

### `hosts/summerpockets/configuration.nix`

#### 追加された設定:

1. **NVIDIAドライバー有効化**
   ```nix
   drivers.nvidia.enable = true;

   hardware.nvidia = {
     powerManagement.enable = true;
     powerManagement.finegrained = false;
   };
   ```

2. **NVIDIAモジュール早期ロード**
   ```nix
   boot.initrd.kernelModules = [
     "nvidia"
     "nvidia_modeset"
     "nvidia_uvm"
     "nvidia_drm"
   ];

   boot.blacklistedKernelModules = [ "nouveau" ];
   ```

3. **カーネルパラメータ（サスペンド修正）**
   ```nix
   boot.kernelParams = [
     "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
     "nvidia.NVreg_TemporaryFilePath=/var/tmp"
     "nvidia-drm.modeset=1"
     "modprobe.blacklist=nouveau"
   ];
   ```

4. **DMS設定修正**
   ```nix
   programs.dank-material-shell.systemd.target = "default.target";
   ```

5. **環境変数**
   ```nix
   environment.variables = {
     LIBVA_DRIVER_NAME = "nvidia";
     GBM_BACKEND = "nvidia-drm";
     __GLX_VENDOR_LIBRARY_NAME = "nvidia";
     XDG_CONFIG_HOME = "$HOME/.config";
     XDG_CACHE_HOME = "$HOME/.cache";
   };
   ```

6. **NVIDIAサスペンドサービス**
   ```nix
   systemd.services = {
     nvidia-suspend.enable = true;
     nvidia-resume.enable = true;
     nvidia-hibernate.enable = true;
   };
   ```

---

## 🚀 適用手順

### ステップ1: 事前準備

```bash
cd ~/rudra

# DMS設定ディレクトリを作成（権限修正）
mkdir -p ~/.config/DankMaterialShell
mkdir -p ~/.cache/DankMaterialShell
chmod 755 ~/.config/DankMaterialShell ~/.cache/DankMaterialShell

# 現在の設定をバックアップ（オプション）
cp hosts/summerpockets/configuration.nix hosts/summerpockets/configuration.nix.backup
```

### ステップ2: 設定の確認

変更を確認：
```bash
git diff hosts/summerpockets/configuration.nix
```

### ステップ3: ビルドテスト

```bash
# ビルドのみ（適用しない）
sudo nixos-rebuild build --flake .#summerpockets

# エラーがないことを確認
echo $?  # 0が返ってくればOK
```

### ステップ4: 適用

```bash
# システムに適用
sudo nixos-rebuild switch --flake .#summerpockets
```

**予想される出力:**
- NVIDIAドライバーのコンパイル（初回は時間がかかる）
- サービスの再起動
- 最後に "system activated" と表示される

### ステップ5: 再起動

**重要:** 変更を完全に反映するために再起動が必要です。

```bash
sudo reboot
```

---

## 🧪 起動後の確認

### 1. NVIDIAドライバー確認

```bash
# NVIDIAドライバーが動作しているか確認
nvidia-smi
```

**期待される出力:**
```
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 565.xx.xx    Driver Version: 565.xx.xx    CUDA Version: 12.x  |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
|   0  NVIDIA GeForce ...  Off  | 00000000:01:00.0  On |                  N/A |
+-------------------------------+----------------------+----------------------+
```

### 2. カーネルモジュール確認

```bash
# NVIDIAモジュールがロードされているか
lsmod | awk '/nvidia/'
```

**期待される出力:**
```
nvidia_drm            ...
nvidia_modeset        ...
nvidia_uvm            ...
nvidia                ...
```

```bash
# Nouveauがロードされていないことを確認
lsmod | awk '/nouveau/'
```

**期待される出力:** （何も表示されない）

### 3. DMS状態確認

```bash
# DMSが起動しているか
systemctl --user status dms.service
```

**期待される出力:**
```
● dms.service - DankMaterialShell
     Loaded: loaded
     Active: active (running)
```

### 4. Hyprland確認

```bash
# Hyprlandが動作しているか
ps aux | awk '/[H]yprland/'
```

DMSパネルやバーが表示されていればOK。

---

## 🛏️ スリープテスト

### テスト手順

```bash
# 1. 重要なデータを保存

# 2. ターミナルでログ監視を開始（別ウィンドウで）
journalctl -f -g "suspend|resume|nvidia"

# 3. スリープ実行
systemctl suspend

# 4. 5-10秒待つ

# 5. 電源ボタンを押して復帰

# 6. ログを確認
journalctl -b -0 -g "suspend|resume" --no-pager | tail -50
```

### 期待される動作

✅ 画面が暗くなる（スリープ）
✅ 電源ボタンで復帰
✅ ログイン画面またはロック画面が表示
✅ Hyprland/DMSが正常に動作
✅ アプリケーションが保持されている

---

## ⚠️ トラブルシューティング

### 問題1: `nvidia-smi`がない

**原因:** NVIDIAドライバーがまだビルド中、または有効化されていない

**解決策:**
```bash
# configuration.nixを確認
grep "drivers.nvidia.enable" ~/rudra/hosts/summerpockets/configuration.nix

# 再ビルド
sudo nixos-rebuild switch --flake ~/rudra/.#summerpockets

# 再起動
sudo reboot
```

### 問題2: ブラックスクリーン

**原因:** ディスプレイドライバーの問題

**解決策:**
1. TTY切り替え: `Ctrl + Alt + F2`
2. ログイン
3. エラー確認: `journalctl -b -0 -xe | tail -100`
4. 必要に応じて設定をロールバック:
   ```bash
   sudo nixos-rebuild switch --flake ~/rudra/.#summerpockets --rollback
   sudo reboot
   ```

### 問題3: DMSが起動しない

**解決策:**
```bash
# ログ確認
journalctl --user -u dms.service -n 100 --no-pager

# 手動起動テスト
systemctl --user restart dms.service

# 設定ディレクトリの権限確認
ls -la ~/.config/DankMaterialShell
```

### 問題4: スリープ後に復帰できない

**診断:**
```bash
# サスペンドログ確認
journalctl -b -1 -g "suspend|resume" --no-pager
```

**考えられる原因:**
- NVIDIAドライバーが正しくロードされていない
- カーネルパラメータが反映されていない

**解決策:**
```bash
# カーネルパラメータ確認
cat /proc/cmdline | grep nvidia

# 期待される出力に以下が含まれているはず:
# nvidia.NVreg_PreserveVideoMemoryAllocations=1
# nvidia-drm.modeset=1

# なければ再ビルド
sudo nixos-rebuild switch --flake ~/rudra/.#summerpockets
sudo reboot
```

---

## 📊 成功の確認

以下がすべて動作すれば成功です：

- [x] `nvidia-smi`でGPU情報が表示される
- [x] `lsmod | awk '/nvidia/'`でNVIDIAモジュールが表示される
- [x] `lsmod | awk '/nouveau/'`で何も表示されない
- [x] DMSが自動起動する
- [x] Hyprlandが安定して起動する
- [x] スリープから正常に復帰できる

---

## 📚 詳細情報

より詳しい診断情報は以下を参照：
- `SYSTEM_STABILITY_FIX.md` - 完全な診断レポート

---

## 🎉 完了後

システムが安定したら：

1. **Git コミット:**
   ```bash
   cd ~/rudra
   git add hosts/summerpockets/configuration.nix
   git commit -m "Fix: Enable NVIDIA drivers and fix suspend/DMS issues

   - Enable NVIDIA proprietary drivers (RTX 3070)
   - Add NVIDIA suspend/resume support
   - Fix DMS startup by changing to default.target
   - Add NVIDIA environment variables for Wayland
   - Blacklist nouveau driver

   This fixes:
   - Sleep/suspend resume failures
   - DMS not starting automatically
   - Hyprland startup instability"

   git push
   ```

2. **Fine-grained power management（オプション）:**

   安定して動作したら、省電力のためにfine-grainedを有効化：
   ```nix
   hardware.nvidia.powerManagement.finegrained = true;
   ```

お疲れさまでした！ 🚀
