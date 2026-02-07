# システム安定性問題 - 診断と修正

## 🔍 診断結果

### 1. **NVIDIAドライバー問題（最重要）**
**症状:** スリープ後に復帰できない

**原因:**
- NVIDIAの専用ドライバーが有効になっていない
- 代わりにNouveauオープンソースドライバーが使用されている
- Nouveauはスリープ/サスペンドのサポートが不完全

**証拠:**
```bash
$ lsmod | awk '/nouveau/'
nouveau              3837952  63
```

NVIDIAドライバーモジュールがインポートされているが、**有効化されていない**。

---

### 2. **DMS起動失敗**
**症状:** ログイン時にDMSが自動起動しない

**原因:**
```
Feb 07 15:37:08 rudra dms[3629]: Error:
Feb 07 15:37:08 rudra dms[3629]:    0: Read-only file system (os error 30)
```

- Matugen（テーマジェネレーター）が読み取り専用ファイルシステムに書き込もうとしている
- `graphical-session.target`が起動していない（inactive/dead）
- DMSがgraphical-session.targetに依存しているが、targetが起動しない

---

### 3. **Hyprlandの不安定性**
**症状:** 確率的に起動失敗

**原因:**
- NouveauドライバーとEGL/Mesa の相性問題
- スタックトレースにEGLエラーが表示

---

## 🛠️ 修正方法

### ステップ1: NVIDIAドライバーを有効化

**ファイル:** `hosts/summerpockets/configuration.nix`

現在、NVIDIAドライバーモジュールがインポートされていますが、**有効化されていません**。

#### 修正A: 完全なNVIDIA設定（シンプル）
`configuration.nix`に以下を追加：

```nix
# NVIDIAドライバーを有効化
drivers.nvidia.enable = true;
```

**または**

#### 修正B: NVIDIA PRIME設定（ハイブリッドGPU）
ラップトップでIntel + NVIDIA構成の場合：

```nix
# Intel + NVIDIA Hybrid
drivers.nvidia.enable = true;
drivers.nvidia-prime.enable = true;
drivers.nvidia-prime.intelBusID = "PCI:0:2:0";   # lspciで確認
drivers.nvidia-prime.nvidiaBusID = "PCI:1:0:0";  # lspciで確認
```

**Bus IDの確認方法:**
```bash
lspci | grep -E "VGA|3D"
# 出力例:
# 00:02.0 VGA compatible controller: Intel ...  → PCI:0:2:0
# 01:00.0 3D controller: NVIDIA ...             → PCI:1:0:0
```

---

### ステップ2: NVIDIAサスペンド/レジューム修正

**ファイル:** `hosts/summerpockets/configuration.nix`

NVIDIAドライバーのサスペンド対応を有効化：

```nix
hardware.nvidia = {
  # スリープ/サスペンド対応（重要！）
  powerManagement.enable = true;

  # オプション: Fine-grained power management
  # Turing以降のGPU（RTX 2000以降）で有効
  powerManagement.finegrained = false;  # テスト後にtrueに変更可能
};

# NVIDIAサスペンドサービスを有効化
systemd.services = {
  nvidia-suspend.enable = true;
  nvidia-resume.enable = true;
  nvidia-hibernate.enable = true;
};
```

---

### ステップ3: DMS起動修正

#### 3-1: ホームディレクトリの権限確認

```bash
# DMSの設定ディレクトリ作成
mkdir -p ~/.config/DankMaterialShell
chmod 755 ~/.config/DankMaterialShell

# キャッシュディレクトリ
mkdir -p ~/.cache/DankMaterialShell
chmod 755 ~/.cache/DankMaterialShell
```

#### 3-2: DMS systemdサービス修正

**ファイル:** `hosts/summerpockets/configuration.nix`

```nix
programs.dank-material-shell = {
  enable = true;
  systemd = {
    enable = true;
    # graphical-session.targetではなくdefault.targetに変更
    target = "default.target";  # または "hyprland-session.target"
    restartIfChanged = true;
  };
  enableSystemMonitoring = true;
  greeter = {
    enable = true;
    compositor.name = "hyprland";
  };
};
```

#### 3-3: DMSの環境変数追加（オプション）

```nix
# DMS用の環境変数
environment.sessionVariables = {
  # テーマ生成のための書き込み権限
  XDG_CONFIG_HOME = "$HOME/.config";
  XDG_CACHE_HOME = "$HOME/.cache";
};
```

---

### ステップ4: カーネルパラメータ最適化

**ファイル:** `hosts/summerpockets/configuration.nix`

```nix
boot.kernelParams = [
  # 既存の設定...

  # NVIDIAサスペンド修正
  "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
  "nvidia.NVreg_TemporaryFilePath=/var/tmp"

  # オプション: Nouveauを完全に無効化
  "modprobe.blacklist=nouveau"
];

# Nouveauを明示的にブラックリスト
boot.blacklistedKernelModules = [ "nouveau" ];
```

---

### ステップ5: 早期ブート時のKMS（Kernel Mode Setting）

**ファイル:** `hosts/summerpockets/configuration.nix`

```nix
boot.initrd.kernelModules = [
  # 既存の設定...
  "nvidia"
  "nvidia_modeset"
  "nvidia_uvm"
  "nvidia_drm"
];

# KMSを早期起動
boot.kernelParams = [
  # 既存の設定...
  "nvidia-drm.modeset=1"
];
```

---

## 📝 完全な修正パッチ

**ファイル:** `hosts/summerpockets/configuration.nix`

以下のセクションを追加/修正：

```nix
{
  config,
  lib,
  pkgs,
  inputs,
  options,
  ...
}:
let
  username = "mirin";
  userDescription = "mirinnano";
  homeDirectory = "/home/${username}";
  hostName = "rudra";
  timeZone = "Asia/Tokyo";
in
{
  imports = [
    ./hardware-configuration.nix
    ./user.nix
    ../../modules/nvidia-drivers.nix
    ../../modules/nvidia-prime-drivers.nix
    ../../modules/intel-drivers.nix
    inputs.home-manager.nixosModules.default
    inputs.dms.nixosModules.dank-material-shell
    inputs.dms.nixosModules.greeter
  ];

  # ========================================
  # NVIDIAドライバー設定（重要！）
  # ========================================

  # オプションA: シンプルなNVIDIA設定
  drivers.nvidia.enable = true;

  # オプションB: NVIDIA PRIME（ハイブリッドGPU）
  # drivers.nvidia.enable = true;
  # drivers.nvidia-prime.enable = true;
  # drivers.nvidia-prime.intelBusID = "PCI:0:2:0";   # lspciで確認
  # drivers.nvidia-prime.nvidiaBusID = "PCI:1:0:0";  # lspciで確認

  # NVIDIAサスペンド/レジューム修正
  hardware.nvidia = {
    powerManagement.enable = true;
    powerManagement.finegrained = false;
  };

  # ========================================
  # カーネル設定
  # ========================================

  boot = {
    kernelPackages = pkgs.linuxPackages_zen;
    kernelModules = [ "v4l2loopback" ];
    extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];

    # NVIDIAモジュールを早期ロード
    initrd.kernelModules = [
      "nvidia"
      "nvidia_modeset"
      "nvidia_uvm"
      "nvidia_drm"
    ];

    # Nouveauをブラックリスト
    blacklistedKernelModules = [ "nouveau" ];

    kernelParams = [
      # Intel Graphics
      "intel_pstate=active"
      "i915.enable_psr=1"
      "i915.enable_fbc=1"
      "i915.enable_dc=2"

      # Storage
      "nvme.noacpi=1"

      # Performance
      "mitigations=off"
      "quiet"
      "loglevel=3"

      # Gaming optimization
      "split_lock_detect=off"

      # NVIDIAサスペンド修正（重要！）
      "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
      "nvidia.NVreg_TemporaryFilePath=/var/tmp"
      "nvidia-drm.modeset=1"

      # Nouveauを無効化
      "modprobe.blacklist=nouveau"
    ];

    # ... 残りのboot設定 ...
  };

  # ========================================
  # DMS修正
  # ========================================

  programs.dank-material-shell = {
    enable = true;
    systemd = {
      enable = true;
      target = "default.target";  # graphical-session.targetから変更
      restartIfChanged = true;
    };
    enableSystemMonitoring = true;
    greeter = {
      enable = true;
      compositor.name = "hyprland";
    };
  };

  # ========================================
  # システムサービス
  # ========================================

  systemd.services = {
    # 既存のサービス...

    # NVIDIAサスペンドサービス
    nvidia-suspend.enable = true;
    nvidia-resume.enable = true;
    nvidia-hibernate.enable = true;
  };

  # ========================================
  # 環境変数
  # ========================================

  environment.sessionVariables = {
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_CACHE_HOME = "$HOME/.cache";

    # NVIDIA関連
    LIBVA_DRIVER_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };

  # ... 残りの設定 ...
}
```

---

## 🚀 適用手順

### 1. Bus IDの確認（NVIDIA PRIMEの場合）

```bash
lspci | grep -E "VGA|3D"
```

出力例を見て、Bus IDを確認：
```
00:02.0 VGA compatible controller: Intel ...  → intelBusID = "PCI:0:2:0"
01:00.0 3D controller: NVIDIA ...             → nvidiaBusID = "PCI:1:0:0"
```

### 2. 設定ファイルを編集

```bash
cd ~/rudra
nvim hosts/summerpockets/configuration.nix
```

上記のパッチを適用。

### 3. システム再構築

```bash
# ビルドテスト
sudo nixos-rebuild test --flake ~/rudra/.#summerpockets

# 問題なければ適用
sudo nixos-rebuild switch --flake ~/rudra/.#summerpockets
```

### 4. 再起動

```bash
sudo reboot
```

### 5. 起動後の確認

```bash
# NVIDIAドライバー確認
nvidia-smi

# カーネルモジュール確認
lsmod | grep nvidia    # nvidia* が表示されるはず
lsmod | grep nouveau   # 何も表示されないはず

# DMS状態確認
systemctl --user status dms.service

# Hyprland状態確認
ps aux | grep -i hyprland
```

---

## 🧪 テスト

### スリープテスト

```bash
# スリープ実行
systemctl suspend

# 待機（5秒）→ 電源ボタンを押して復帰

# ログ確認
journalctl -b -0 -g "suspend|resume" --no-pager | tail -50
```

**期待される動作:**
- 正常にスリープモードに入る
- 電源ボタンで復帰できる
- Hyprlandが正常に動作している

---

## ⚠️ トラブルシューティング

### 問題: 起動時にブラックスクリーン

**解決策:**
1. TTY切り替え（Ctrl+Alt+F2）
2. ログイン
3. ログ確認：
   ```bash
   journalctl -b -0 -xe
   ```

### 問題: nvidia-smiが動作しない

**解決策:**
```bash
# カーネルモジュール確認
lsmod | grep nvidia

# 何も表示されない場合、手動ロード
sudo modprobe nvidia
sudo modprobe nvidia_drm
```

### 問題: DMSがまだ起動しない

**解決策:**
```bash
# 設定ディレクトリの権限確認
ls -la ~/.config/DankMaterialShell

# 手動起動テスト
systemctl --user start dms.service
journalctl --user -u dms.service -f
```

---

## 📊 期待される改善

### ✅ スリープ/サスペンド
- 正常にスリープモードに入る
- 電源ボタンで確実に復帰
- Hyprlandセッションが維持される

### ✅ DMS起動
- ログイン時に自動起動
- テーマジェネレーションが正常動作
- エラーメッセージが消える

### ✅ Hyprland安定性
- 起動時のクラッシュが無くなる
- EGLエラーが消える
- パフォーマンス向上（NVIDIAドライバー使用）

---

## 📝 注記

1. **NVIDIA PRIMEについて:**
   - ラップトップの場合、Intel + NVIDIA構成が一般的
   - PRIMEを使うことで、省電力とパフォーマンスを両立

2. **powerManagement.finegrained:**
   - RTX 2000シリーズ以降で使用可能
   - 使用していない時にGPUを完全オフにする
   - 初期はfalseで、安定後にtrueに変更推奨

3. **Nouveau vs NVIDIA:**
   - Nouveau: オープンソース、機能制限あり、サスペンド不安定
   - NVIDIA: 専用ドライバー、フル機能、サスペンド対応

---

適用後、必ず**再起動**してテストしてください！
