{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.drivers.nvidia;
in {
  options.drivers.nvidia = {
    enable = mkEnableOption "Enable Nvidia Drivers";
  };

  config = mkIf cfg.enable {
    services.xserver.videoDrivers = ["nvidia"];

    # Fix MESA-LOADER warnings - Add GBM backend support
    hardware.graphics = {
      extraPackages = with pkgs; [
        nvidia-vaapi-driver
      ];
      extraPackages32 = with pkgs.pkgsi686Linux; [
        nvidia-vaapi-driver
      ];
    };

    hardware.nvidia = {
      # Modesetting is required.
      modesetting.enable = true;
      # Nvidia power management. Required for proper sleep/suspend support!
      powerManagement.enable = true;
      # Fine-grained power management. Turns off GPU when not in use.
      # Recommended for Turing (RTX 20xx) or newer GPUs.
      # Set to true after 1 week of testing for 2-5W power savings at idle.
      powerManagement.finegrained = false;  # Set to true after testing
      # Use the NVidia open source kernel module (not to be confused with the
      # independent third-party "nouveau" open source driver).
      # Support is limited to the Turing and later architectures. Full list of
      # supported GPUs is at:
      # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
      # Only available from driver 515.43.04+
      # Currently alpha-quality/buggy, so false is currently the recommended setting.
      open = false;
      # Enable the Nvidia settings menu,
      # accessible via `nvidia-settings`.
      nvidiaSettings = true;
      # Force full composition pipeline - fixes tearing and improves performance
      forceFullCompositionPipeline = true;
      # Optionally, you may need to select the appropriate driver version for your specific GPU.
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };

    # NVIDIA configuration via nvidia-settings
    # Note: Monitor configuration (refresh rates) is handled by Hyprland, not here
    environment.etc."X11/xorg.conf.d/10-nvidia.conf".text = ''
      Section "Device"
        Identifier "NVIDIA GPU"
        Driver "nvidia"
        # Performance optimizations for gaming
        Option "AllowIndirectGLXProtocol" "off"
        Option "TripleBuffer" "on"
        Option "BaseProfile" "high_performance"
        # Reduce input lag
        Option "AllowFlipping" "Off"
        Option "SwapInterval" "0"
        # Power management
        Option "RegistryDwords" "PerfLevelSrc=0x2222"
        Option "Coolbits" "28"  # Enable overclocking and fan control if needed
      EndSection
    '';

    # Add nvidia-smi and other tools to system packages
    environment.systemPackages = with pkgs; [
      # nvtopPackages.nvidia  # Temporarily disabled - CUDA build issue
    ];
  };
}
