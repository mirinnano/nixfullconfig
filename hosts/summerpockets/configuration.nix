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
  # NVIDIA ドライバー設定（スリープ問題修正）
  # ========================================
  drivers.nvidia.enable = true;
  # powerManagement設定は modules/nvidia-drivers.nix で管理

  nixpkgs.config.permittedInsecurePackages = [
  "qtwebengine-5.15.19"
  "ventoy-1.1.10"
];
 # DMS設定（起動失敗修正）
 programs.dank-material-shell = {
  enable = true;
  systemd = {
    enable = true;
    target = "default.target";  # graphical-session.targetの問題を回避
    restartIfChanged = true;
  };
  enableSystemMonitoring = true;
  greeter = {
    enable = true;
    compositor.name = "hyprland";
  };
 };

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
  
  # Zram for better memory management
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;  # Use 50% of RAM for zram
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_zen;
    kernelModules = [ "v4l2loopback" "tap" "vhost_net" "vhost_vsock" ];
    extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];

    # NVIDIAモジュールを早期ロード（スリープ修正）
    initrd.kernelModules = [
      "nvidia"
      "nvidia_modeset"
      "nvidia_uvm"
      "nvidia_drm"
    ];

    # Nouveauドライバーをブラックリスト（NVIDIAドライバー使用のため）
    blacklistedKernelModules = [ "nouveau" ];
    kernel.sysctl = {
      # Memory Management
      "vm.max_map_count" = 2147483642;
      "vm.swappiness" = 180;  # Aggressive swap to zram
      "vm.watermark_boost_factor" = 0;
      "vm.watermark_scale_factor" = 125;
      "vm.page-cluster" = 0;  # Disable swap readahead
      "vm.vfs_cache_pressure" = 50;  # Keep cache longer
      "vm.dirty_ratio" = 10;  # Start writing at 10% dirty
      "vm.dirty_background_ratio" = 5;  # Background writing at 5%

      # Network Performance (TCP BBR)
      "net.core.default_qdisc" = "cake";  # Better than fq_codel
      "net.ipv4.tcp_congestion_control" = "bbr";
      "net.ipv4.tcp_fastopen" = 3;
      "net.core.rmem_max" = 16777216;  # 16MB receive buffer
      "net.core.wmem_max" = 16777216;  # 16MB send buffer
      "net.ipv4.tcp_rmem" = "4096 87380 16777216";
      "net.ipv4.tcp_wmem" = "4096 65536 16777216";
      "net.ipv4.tcp_mtu_probing" = 1;

      # File System
      "fs.inotify.max_user_watches" = 524288;  # For large projects
      "fs.file-max" = 2097152;

      # CPU Performance & Scheduling
      "kernel.sched_min_granularity_ns" = 1000000;  # 1ms - better task scheduling
      "kernel.sched_wakeup_granularity_ns" = 2000000;  # 2ms
      "kernel.sched_tunable_scaling" = 1;  # Enable auto-tuning
      "kernel.timer_migration" = 1;  # Timer migration for multi-CPU
      "kernel.numa_balancing" = 0;  # Disable NUMA balancing for gaming (single GPU)

      # Process Management
      "kernel.pid_max" = 4194304;  # Max PID for heavy workloads

      # Kernel
      "kernel.sysrq" = 1;  # Enable SysRq for emergency
      "kernel.panic" = 10;  # Reboot after 10s on panic
    };
    kernelParams = [
      # Intel Graphics
      "intel_pstate=active"
      "i915.enable_psr=1" # Panel self refresh
      "i915.enable_fbc=1" # Framebuffer compression
      "i915.enable_dc=2" # Display power saving

      # Storage
      "nvme.noacpi=1" # Helps with NVME power consumption

      # Security (balance between safety and performance)
      "mitigations=nosmt"  # Disable SMT for security while keeping performance
      "quiet"  # Less verbose boot
      "loglevel=3"

      # Gaming optimization
      "split_lock_detect=off"  # Better game compatibility

      # NVIDIA サスペンド/レジューム修正（重要！）
      "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
      "nvidia.NVreg_TemporaryFilePath=/var/tmp"
      "nvidia-drm.modeset=1"

      # NVIDIA パフォーマンス最大化
      "nvidia.NVreg_EnablePageRetirement=1"  # Bad page retirement
      "nvidia.NVreg_EnableGpuFirmware=0"  # Disable firmware check for faster boot
      "nvidia.NVreg_ResmanDebugLevel=2099207"  # Debug (0x1FFFFFFF) - disable for production
      "nvidia.NVreg_DynamicPowerManagement=0"  # Disable dynamic power management for max performance

      # Waydroid (Android container)
      "androidboot.hardware=generic"
      "androidboot.selinux=permissive"

      # Nouveauを無効化
      "modprobe.blacklist=nouveau"
    ];
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        useOSProber = true;
        configurationLimit = 30;
      };
    };
    tmp = {
      useTmpfs = true;
      tmpfsSize = "10G";
    };
    binfmt.registrations.appimage = {
      wrapInterpreterInShell = false;
      interpreter = "${pkgs.appimage-run}/bin/appimage-run";
      recognitionType = "magic";
      offset = 0;
      mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
      magicOrExtension = ''\x7fELF....AI\x02'';
    };
    plymouth.enable = true;
  };

  networking = {
    hostName = hostName;
    # Use Cloudflare DNS (1.1.1.1 and 1.0.0.1)
    nameservers = [ "1.1.1.1" "1.0.0.1" ];
    # Fallback DNS from Cloudflare
    dhcpcd = {
      extraConfig = "nohook resolv.conf";
    };
    networkmanager = {
      enable = true;
      # Don't manage Waydroid interfaces
      unmanaged = [
        "rndis0"
        "wlan0"
        "utun*"
      ];
      dns = "none";
    };
    timeServers = options.networking.timeServers.default ++ [ "pool.ntp.org" ];
    # Firewall configuration
    firewall = {
      allowedTCPPorts = [ 8003 ];
      checkReversePath = "loose";
      # Allow Mullvad VPN
      allowedUDPPorts = [ 51820 ];  # WireGuard
    };
  };
  };

  time.timeZone = timeZone;
  i18n.inputMethod = {
   enabled = "fcitx5";
   fcitx5 = {
     addons = with pkgs; [
       fcitx5-mozc
       fcitx5-gtk
       fcitx5-skk
       qt6Packages.fcitx5-configtool
     ];
     waylandFrontend = true;
   };
};
  environment.variables = {
    GTK_IM_MODULE = "fcitx5";
    QT_IM_MODULE = "fcitx5";
    XMODIFIERS = lib.mkForce "@im=fcitx5";

    # NVIDIA関連環境変数（Wayland対応）
    LIBVA_DRIVER_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";

    # XDG設定（DMS修正）
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_CACHE_HOME = "$HOME/.cache";
  };
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };
 console.keyMap = "jp106";
  stylix = {
    enable = true;
    base16Scheme = {
      base00 = "191724";
      base01 = "1f1d2e";
      base02 = "26233a";
      base03 = "6e6a86";
      base04 = "908caa";
      base05 = "e0def4";
      base06 = "e0def4";
      base07 = "524f67";
      base08 = "eb6f92";
      base09 = "f6c177";
      base0A = "ebbcba";
      base0B = "31748f";
      base0C = "9ccfd8";
      base0D = "c4a7e7";
      base0E = "f6c177";
      base0F = "524f67";
    };
    image = ../../config/assets/wall.png;
    polarity = "dark";
    opacity.terminal = 0.8;
    cursor.package = pkgs.bibata-cursors;
    cursor.name = "Bibata-Modern-Ice";
    cursor.size = 24;
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font Mono";
      };
      sansSerif = {
        package = pkgs.montserrat;
        name = "Montserrat";
      };
      serif = {
        package = pkgs.montserrat;
        name = "Montserrat";
      };
      sizes = {
        applications = 12;
        terminal = 15;
        desktop = 11;
        popups = 12;
      };
    };
  };

  # Gaming
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    gamescopeSession.enable = true;
  };
  programs.gamemode.enable = true;

  virtualisation = {
    docker = {
      enable = true;
    };
    libvirtd = {
      enable = true;
      # socket activation instead of boot start for faster boot
      # wantedBy = [ "multi-user.target" ];
    };
    waydroid.enable = true;
    spiceUSBRedirection.enable = true;
  };

  programs = {
    nix-ld = {
      enable = true;
      package = pkgs.nix-ld;
    };
    firefox.enable = false;
    dconf.enable = true;
    fuse.userAllowOther = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
      ];
    };
    fish = {
      enable = true;
      interactiveShellInit = ''
        # Disable Fish universal variables (causes /nix/store write errors)
        set -U fish_features no-implicit-universal-variables

        # Set XDG directories for writable Fish data
        set -gx XDG_DATA_HOME "$HOME/.local/share"
        set -gx XDG_CONFIG_HOME "$HOME/.config"

        # Ensure Fish data directory exists
        mkdir -p "$XDG_DATA_HOME/fish"

        # SetFish variables to writable location (not /nix/store)
        set -gx fish_user_paths $HOME/.local/bin $HOME/.cargo/bin $HOME/rudra/scripts

        # Disable universal variable storage
        set -gx fish_greeting
      '';
    };
  };

  nixpkgs = {
    config.allowUnfree = true;
    # Wine 32-bit support
    system = "x86_64-linux";
  };

  users = {
    mutableUsers = true;
    # User configuration is now in user.nix module to avoid duplication
  };

  environment.systemPackages = with pkgs; [
    # Text editors and IDEs (removed: nano, vscode - redundant with nvim/zed/idea)
    zed-editor
    jetbrains.idea

    # Zen Browser from custom input
    inputs.zen-browser.packages."${system}".default

    # Programming languages and tools
    go
    go-blueprint
    go-migrate
    sqlc
    goose
    air
    lua
    python3
    python3Packages.pip
    uv
    clang
    zig
    rustup
    nodePackages_latest.pnpm
    nodePackages_latest.yarn
    fnm
    bun
    maven
    # mongodb-compass  # Uncomment if MongoDB is used
    gcc
    openssl
    nodejs

    # Frappe Bench
    redis
    wkhtmltopdf
    nginx
    uv
    mariadb

    # Version control and development tools
    git
    gh
    lazygit
    lazydocker
    bruno
    # postman  # Removed - bruno is sufficient
    bruno-cli
    gnumake
    coreutils
    nixfmt-rfc-style

    # Wine for Windows applications
    wine
    wine64
    winetricks
    bottles  # Wine prefix manager
    waydroid  # Android container for Apple Music
    meson
    ninja

    # Shell and terminal utilities
    stow
    wget
    killall
    eza
    starship
    kitty
    zoxide
    fzf
    tmux
    tmuxPlugins.sensible
    tmuxPlugins.vim-tmux-navigator
    tmuxPlugins.resurrect
    tmuxPlugins.continuum
    tmuxPlugins.catppuccin
    progress
    tree
    alacritty
    exfatprogs

    inputs.nixCats.packages.${pkgs.system}.nvim
    pkgs.ghostty

    # File management and archives
    yazi
    p7zip
    unzip
    zip
    unrar
    file-roller
    ncdu
    duf

    # System monitoring and management
    htop
    btop
    lm_sensors
    inxi
    # nvtopPackages.nvidia
    # anydesk  # Removed - tailscale/ssh is sufficient

    # Network and internet tools
    aria2
    qbittorrent
    cloudflare-warp
    mullvad-vpn
    tailscale

    # Audio and video
    pulseaudio
    pavucontrol
    ffmpeg
    mpv
   

    # Image and graphics
    imagemagick
    gimp
    hyprpicker
    swww
    hyprlock
    waypaper
    imv

    # Productivity and office
    obsidian
    bitwarden-desktop  # Password manager
    libreoffice-qt6-fresh
    spacedrive
    hugo

    # Communication and social
    telegram-desktop
    zoom-us
    vesktop
    element-desktop

    # Browsers
    firefox
    google-chrome

    # Gaming and entertainment
    lutris
    mangohud
    gamescope
    gamemode
    protonup-qt
    # stremio

    # System utilities
    libgcc
    bc
    jq  # JSON processor (needed for screenshot script)
    kdePackages.dolphin
    lxqt.lxqt-policykit
    libnotify
    v4l-utils
    ydotool
    pciutils
    socat
    cowsay
    ripgrep
    lshw
    bat
    pkg-config
    brightnessctl
    virt-viewer
    swappy
    appimage-run
    yad
    playerctl
    nh
    ansible

    # Wayland specific
    hyprshot
    hypridle
    grim
    slurp
    wofi  # Application launcher
    waybar
    hyprpanel
    dunst
    wl-clipboard
    swaynotificationcenter

    # Virtualization
    libvirt
    qemu
    virt-manager
    spice
    spice-gtk
    spice-protocol
    OVMF

    # File systems
    ntfs3g
    os-prober

    # Downloaders
    yt-dlp
    localsend

    # Clipboard managers
    cliphist

    # Fun and customization
    cmatrix
    lolcat
    fastfetch
    onefetch
    microfetch

    # Networking
    networkmanagerapplet

    # Education
    wireshark
    ventoy

    # Music and streaming
    youtube-music
    spotify

    # Miscellaneous
    greetd.tuigreet
    customSddmTheme
    libsForQt5.qt5.qtgraphicaleffects
  ];

  environment.etc."sddm/wayland-sessions/hyprland.desktop".text = ''
 #   [Desktop Entry]
 #   Name=Hyprland
 #   Exec=Hyprland
 #   Type=Application
#  '';

  fonts.packages = with pkgs; [
    noto-fonts-color-emoji
    fira-sans
    roboto
    noto-fonts-cjk-sans
    font-awesome
    material-icons
    noto-fonts-cjk-serif
  ];

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal
    ];
    configPackages = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal
    ];
  };

  # Disable unnecessary services
  services.printing.browsing = false;  # プリンター自動検出を無効化
  services.avahi.publish.enable = lib.mkForce false;  # Avahi広告を無効化（検出は維持）

  # Disable avahi completely if not using local network discovery
  # services.avahi.enable = false;

  services = {
    xserver = {
      enable = false;
      xkb = {
        layout = "jp";
        variant = "";
      };
      videoDrivers = [ "modesetting" ];
    };
    displayManager.sddm = {
      enable = false;  # Disabled: Using DankGreeter
      wayland.enable = true;
      theme = "rose-pine";
    };
    # greetd = {
    #   enable = true;
    #   vt = 3;
    #   settings = {
    #     default_session = {
    #       user = username;
    #       command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
    #     };
    #   };
    # };
    logind.settings.Login.HandlePowerKey = "suspend";
    cloudflare-warp.enable = true;
    mullvad-vpn.enable = true;
    # supergfxd.enable = true;
    # asusd = {
    #   enable = true;
    #   enableUserService = true;
    # };
    tailscale = {
      enable = true;
      useRoutingFeatures = "client";
    };
    # ollama = {
    #   enable=true;
    #   acceleration = "cuda";
    # };
    cron = {
      enable = true;
    };
    libinput.enable = true;
    upower.enable = true;
    fstrim.enable = true;
    gvfs.enable = false;  # Disabled - using KDE Dolphin, redundant
    openssh.enable = true;
    flatpak.enable = true;
    power-profiles-daemon.enable = false;
    thermald.enable = true;
    auto-cpufreq = {
      enable = true;
      settings = {
        battery = {
          governor = "schedutil";  # Better than powersave - modern CPU scaling
          turbo = "auto";  # Allow turbo on battery for max performance
          max_limit = 99;  # Leave one core free for thermal headroom
        };
        charger = {
          governor = "performance";
          turbo = "auto";  # Always use turbo when charging
        };
      };
    };

    # Ananicy - Automatic process nice/ioclass management
    ananicy = {
      enable = true;
      package = pkgs.ananicy-cpp;  # C++ version (faster)
      rulesProvider = pkgs.ananicy-rules-cachyos;  # CachyOS ruleset (gaming optimized)
    };

    gnome.gnome-keyring.enable = true;
    avahi = {
      enable = false;  # Disabled for faster boot - enable if using local network discovery
      # nssmdns4 = true;
      # openFirewall = true;
    };
    ipp-usb.enable = false;  # Disabled - uncomment if using printer over USB

    # Hypridle - Idle manager for automatic lock and suspend
    hypridle = {
      enable = true;
    };

    syncthing = {
      enable = true;
      user = username;
      dataDir = homeDirectory;
      configDir = "${homeDirectory}/.config/syncthing";
    };
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;

      # Audio quality settings: 2ch 32bit 48kHz
      extraConfig.pipewire."92-high-quality-audio" = {
        "context.properties" = {
          "default.clock.rate" = 48000;
          "default.clock.allowed-rates" = [ 48000 ];
        };
        "stream.properties" = {
          "resample.quality" = 10;
          "channelmix.normalize" = false;
          "channelmix.mix-lfe" = false;
        };
      };

      extraConfig.pipewire-pulse."92-high-quality-audio" = {
        "pulse.properties" = {
          "pulse.default.format" = "S32LE";
          "pulse.default.rate" = 48000;
          "pulse.default.channels" = 2;
        };
        "stream.properties" = {
          "resample.quality" = 10;
        };
      };
    };
    pulseaudio.enable = false;
  };

  # powerManagement.powertop.enable = true;

  # Boot optimization

  # OneDrive - Manual start only for better boot performance
  # To enable: systemctl --user start onedrive
  # To auto-enable: systemctl --user enable onedrive
  # systemd.user.services = {
  #   onedrive = {
  #     description = "Onedrive Sync Service";
  #     after = [ "network-online.target" ];
  #     serviceConfig = {
  #       Type = "simple";
  #       User = username;
  #       ExecStart = "${pkgs.onedrive}/bin/onedrive --monitor";
  #       Restart = "always";
  #       RestartSec = 10;
  #     };
  #   };
  # };

  systemd.services = {
    flatpak-repo = {
      path = [ pkgs.flatpak ];
      script = "flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo";
    };
    libvirtd = {
      enable = true;
      # Socket activation - starts on demand instead of boot
      # wantedBy = [ "multi-user.target" ];  # Removed for faster boot
      requires = [ "virtlogd.service" ];
    };
    # Docker遅延起動（ネットワーク待機不要）
    docker.wantedBy = lib.mkForce [];

    # NVIDIAサスペンド/レジュームサービス（スリープ修正）
    nvidia-suspend.enable = true;
    nvidia-resume.enable = true;
    nvidia-hibernate.enable = true;
  };

  hardware = {
    sane = {
      enable = false;  # Disabled - uncomment if using scanner
      # extraBackends = [ pkgs.sane-airscan ];
      # disabledDefaultBackends = [ "escl" ];
    };
    logitech.wireless = {
      enable = false;  # Disabled - uncomment if using Logitech wireless devices
      # enableGraphical = true;
    };
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    graphics.enable = true;
  };

  services.blueman.enable = true;

  security = {
    rtkit.enable = true;
    polkit = {
      enable = true;
      extraConfig = ''
        polkit.addRule(function(action, subject) {
          if (
            subject.isInGroup("users")
              && (
                action.id == "org.freedesktop.login1.reboot" ||
                action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
                action.id == "org.freedesktop.login1.power-off" ||
                action.id == "org.freedesktop.login1.power-off-multiple-sessions"
              )
            )
          {
            return polkit.Result.YES;
          }
        })
      '';
    };
    pam.services.swaylock.text = "auth include login";
  };

  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };

  programs.hyprland.enable = true;

  xdg.mime.defaultApplications = {
    # Web and HTML
    "x-scheme-handler/http" = "zen.desktop";
    "x-scheme-handler/https" = "zen.desktop";
    "x-scheme-handler/chrome" = "zen.desktop";
    "text/html" = "zen.desktop";
    "application/x-extension-htm" = "zen.desktop";
    "application/x-extension-html" = "zen.desktop";
    "application/x-extension-shtml" = "zen.desktop";
    "application/x-extension-xhtml" = "zen.desktop";
    "application/xhtml+xml" = "zen.desktop";

    # File management
    "inode/directory" = "org.kde.dolphin.desktop";

    # Text editor
    "text/plain" = "nvim.desktop";

    # Terminal
    "x-scheme-handler/terminal" = "alacritty.desktop";

    # Videos
    "video/quicktime" = "mpv-2.desktop";
    "video/x-matroska" = "mpv-2.desktop";

    # LibreOffice formats
    "application/vnd.oasis.opendocument.text" = "libreoffice-writer.desktop";
    "application/vnd.oasis.opendocument.spreadsheet" = "libreoffice-calc.desktop";
    "application/vnd.oasis.opendocument.presentation" = "libreoffice-impress.desktop";
    "application/vnd.ms-excel" = "libreoffice-calc.desktop";
    "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" = "libreoffice-calc.desktop";
    "application/msword" = "libreoffice-writer.desktop";
    "application/vnd.openxmlformats-officedocument.wordprocessingml.document" =
      "libreoffice-writer.desktop";
    "application/vnd.ms-powerpoint" = "libreoffice-impress.desktop";
    "application/vnd.openxmlformats-officedocument.presentationml.presentation" =
      "libreoffice-impress.desktop";

    # PDF
    "application/pdf" = "zen.desktop";

    # Torrents
    "application/x-bittorrent" = "org.qbittorrent.qBittorrent.desktop";
    "x-scheme-handler/magnet" = "org.qbittorrent.qBittorrent.desktop";

    # Other handlers
    "x-scheme-handler/about" = "zen.desktop";
    "x-scheme-handler/unknown" = "zen.desktop";
    "x-scheme-handler/postman" = "Postman.desktop";
    "x-scheme-handler/tonsite" = "org.telegram.desktop.desktop";
  };

  # Power profile management
  systemd.user.services.power-profile-manager = {
    description = "Automatic power profile management";
    wantedBy = [ "default.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.bash}/bin/bash ${homeDirectory}/rudra/scripts/power-profile-manager.sh --daemon";
      Restart = "on-failure";
      RestartSec = "10s";
    };
  };

  # Automatic backup to GitHub
  systemd.user.services.auto-backup = {
    description = "Automatic NixOS configuration backup to GitHub";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash ${homeDirectory}/rudra/scripts/auto-backup.sh";
    };
  };

  systemd.user.timers.auto-backup = {
    description = "Daily backup timer";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
      RandomizedDelaySec = "1h";
    };
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users.${username} = import ./home.nix;
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
  };

  system.stateVersion = "24.05";
}
