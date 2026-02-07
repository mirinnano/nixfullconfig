# CS2 パフォーマンス最適化（FPSは高いがもっさりする場合）

## 🎯 問題: FPSは300出ているがもっさりする

これは**入力遅延（input lag）**の問題です。

## ✅ 解決策

### 1. Steam起動オプション（最適化版）

```
gamescope -w 1920 -h 1080 -W 1280 -H 960 -f --force-grab-cursor --rt --expose-wayland --disable-upscaling --hide-cursor-delay 2000 -- %command% -w 1280 -h 960 -fullscreen -nojoy -novid -fps_max 0 -refresh 240 -rate 240000 -tickrate 128 +cl_interp 0 +cl_interp_ratio 1 +cl_updaterate 128 +cl_cmdrate 128
```

### 2. 重要なパフォーマンスオプション

- `--disable-upscaling`: アップスケーリング無効化（遅延低減）
- `--rt`: NVIDIA Real-time scheduler（低遅延）
- `--hide-cursor-delay 2000`: カーソル非表示
- `-fps_max 0`: FPS制限なし
- `+cl_interp 0 +cl_interp_ratio 1`: インターポレーション最小
- `+cl_updaterate 128 +cl_cmdrate 128`: レート最大化

### 3. CS2コンソールコマンド

CS2起動後、コンソール（`~`）で実行：

```
// Input lag reduction
fps_max 0
r_vsync 0
r_vsync_mode 0

// Interpolation
cl_interp 0
cl_interp_ratio 1
cl_updaterate 128
cl_cmdrate 128

// NVIDIA Reflex
mat_queue_report 0
mat_queue_mode -2

// CPU optimization
mat_process_priority "high"
r_threaded_particles 1

// Low latency
m_rawinput 1
mat_monitorgamma 1.6
mat_queue_mode -2
```

### 4. NVIDIA設定

```bash
nvidia-settings
```

**設定項目:**
- **OpenGL/Vulkan設定**:
  - "Allow Flipping" → **Off**（重要！）
  - "VBlank Sync" → **Off**

- **PowerMizer**:
  - "Prefered Mode" → **Prefer Maximum Performance**

- **OpenGL画像設定**:
  - "画像設定" → **高パフォーマンス優先**

### 5. Hyprland設定追加

`/home/mirin/rudra/dotfiles/.config/hypr/hyprland.conf` に追加：

```ini
# ゲーミング最適化
decoration {
    drop_shadow = false
}

# ティアリング有効化（NVIDIA + VRR）
animations {
    enabled = no
}

# Immediate mode for Steam games
windowrule {
    match:title = ^(.*Counter-Strike.*)$
    immediate = true
}
```

### 6. Kernelパラメータ

`/home/mirin/rudra/hosts/summerpockets/configuration.nix` の `boot.kernelParams` に追加：

```nix
boot.kernelParams = [
  "nvidia.NvReg_RegistryDwords=PerfLevelSrc=0x2222"  # 最大パフォーマンス
  "nvidia_drm.fbdev=1"
  "nvidia.NvReg_EnableGpuFirmware=0"
  "processor.max_cstate=1"  # C-State制限で遅延低減
  "idle=poll"  # CPU idleをpollに
];
```

### 7. CPU Governor確認

```bash
# パフォーマンスモード確認
cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor

# performanceでない場合
sudo cpupower frequency-set -g performance
```

### 8. マウス入力最適化

CS2内設定:
- **マウス入力**: `Raw Input` → **有効**
- **マウス加速**: **無効**
- **ポインター速度**: 6/11（Windows標準）

Linux側:
```bash
# マウス加速無効化
xinput set-prop '<マウス名>' 'libinput Accel Speed' 0
```

## 🔧 完全なSteam起動オプション（推奨）

```
gamescope -w 1920 -h 1080 -W 1280 -H 960 -f --force-grab-cursor --rt --expose-wayland --disable-upscaling --hide-cursor-delay 2000 --immediate-flip --fade-shell-depth 3 -- %command% -w 1280 -h 960 -fullscreen -nojoy -novid -novsync -noaafonts -nosound -freq 0 -refresh 240 -tickrate 128 +mat_queue_mode -2 +fps_max 0 +cl_interp 0 +cl_interp_ratio 1 +cl_updaterate 128 +cl_cmdrate 128 +rate 786432 +sys_antialiasing 0
```

## 📊 パフォーマンス測定

```bash
# CS2内でデバッグ情報表示
cl_showfps 1
net_graph 1
net_graphproportionalfont 1

# 入力遅延測定
+memo_show_fps_avg
```

## 🎯 チェックリスト

- [ ] V-Syncがオフ（CS2内とNVIDIA設定）
- [ ] NVIDIA Reflexが有効
- [ ] "Allow Flipping" がオフ
- [ ] Raw Inputが有効
- [ ] CPU Governorがperformance
- [ ] C-State制限あり（processor.max_cstate=1）
- [ ] Hyprlandのimmediateモードが有効
- [ ] Gamescopeの最適オプション使用

これで入力遅延が大幅に改善されます！
