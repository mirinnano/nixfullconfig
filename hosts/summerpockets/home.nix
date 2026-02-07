{
  config,
  pkgs,
  inputs,
  ...
}: let
  userName = "mirin";
  homeDirectory = "/home/${userName}";
  stateVersion = "24.05";
in {
  home = {
    username = userName;
    homeDirectory = homeDirectory;
    stateVersion = stateVersion; # Please read the comment before changing.

    file = {
      # Hyprland Config
      ".config/hypr".source = ../../dotfiles/.config/hypr;
      ".config/hypr/scripts/screenshot.sh".source = ../../dotfiles/.config/hypr/scripts/screenshot.sh;

      # wlogout icons
      ".config/wlogout/icons".source = ../../config/wlogout;

      # Top Level Files symlinks
      # ".zshrc".source = ../../dotfiles/.zshrc;  # Removed: Switched to fish
      ".gitconfig".source = ../../dotfiles/.gitconfig;
      ".tmux.conf".source = ../../dotfiles/.tmux.conf;
      ".ideavimrc".source = ../../dotfiles/.ideavimrc;
      ".nirc".source = ../../dotfiles/.nirc;
      ".local/bin/wallpaper".source = ../../dotfiles/.local/bin/wallpaper;
      ".local/share/fcitx5/themes".source = ../../dotfiles/.local/share/fcitx5/themes;

      # Config directories
      ".config/alacritty".source = ../../dotfiles/.config/alacritty;
      # ".config/dunst".source = ../../dotfiles/.config/dunst;  # Removed: DMS provides notification system
      ".config/fish".source = ../../dotfiles/.config/fish;
      ".config/fastfetch".source = ../../dotfiles/.config/fastfetch;
      ".config/fcitx5".source = ../../dotfiles/.config/fcitx5;
      ".config/MangoHud/MangoHud.conf".source = ../../dotfiles/.config/MangoHud/MangoHud.conf;
      ".config/gamemode.ini".source = ../../dotfiles/.config/gamemode.ini;
      ".config/kitty".source = ../../dotfiles/.config/kitty;
      ".config/mpv".source = ../../dotfiles/.config/mpv;
      ".config/tmux/tmux.conf".source = ../../dotfiles/.config/tmux/tmux.conf;
      ".config/hypr/hypridle.conf".source = ../../dotfiles/.config/hypr/hypridle.conf;
      # ".config/waybar".source = ../../dotfiles/.config/waybar;  # Removed: DMS panel working
      ".config/yazi".source = ../../dotfiles/.config/yazi;
      ".config/wezterm".source = ../../dotfiles/.config/wezterm;
      ".config/ghostty".source = ../../dotfiles/.config/ghostty;

      # Individual config files
      ".config/kwalletrc".source = ../../dotfiles/.config/kwalletrc;
      ".config/starship.toml".source = ../../dotfiles/.config/starship.toml;
      # ".config/mimeapps.list".source = ../../dotfiles/.config/mimeapps.list;
    };

    sessionVariables = {
      # Default applications
      EDITOR = "nvim";
      VISUAL = "nvim";
      TERMINAL = "ghostty";  # Main terminal - replaced alacritty
      BROWSER = "zen";

      # XDG Base Directories
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_STATE_HOME = "$HOME/.local/state";
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_SCREENSHOTS_DIR = "$HOME/Pictures/screenshots";

      # Path modifications - now as a string
      # PATH = "$HOME/.local/bin:$HOME/go/bin:$PATH";

      # Wayland and Hyprland specific
      JAVA_AWT_WM_NOREPARENTING = 1;
      XDG_SESSION_TYPE = "wayland";
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_DESKTOP = "Hyprland";

      # NVIDIA specific
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      GBM_BACKEND = "nvidia-drm";

      # Localization
      LC_ALL = "en_US.UTF-8";

      # Input Method (fcitx5)
      XDG_IM_MODULE = "fcitx5";
      GTK_IM_MODULE = "fcitx5";
      QT_IM_MODULE = "fcitx5";
      XMODIFIERS = "@im=fcitx5";
    };

    sessionPath = [
      "$HOME/.local/bin"
      "$HOME/go/bin"
    ];

    packages = [
      (import ../../scripts/rofi-launcher.nix {inherit pkgs;})
    ];
  };

  imports = [
    inputs.dms.homeModules.dank-material-shell
    inputs.danksearch.homeModules.default
  ];

  # DankSearch configuration
  programs.dsearch.enable = true;

  # Styling
  stylix.targets.waybar.enable = false;
  gtk = {
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };
  qt = {
    enable = true;
    style.name = "kvantum";
    platformTheme.name = "qtct";
  };
 
  services.hypridle = {
    settings = {
      general = {
        after_sleep_cmd = "hyprctl dispatch dpms on";
        ignore_dbus_inhibit = false;
        lock_cmd = "hyprlock";
      };
      listener = [
        {
          timeout = 900;
          on-timeout = "hyprlock";
        }
        {
          timeout = 1200;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };

  programs.home-manager.enable = true;
}
