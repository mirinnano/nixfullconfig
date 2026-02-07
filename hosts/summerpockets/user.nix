{
  lib,
  config,
  pkgs,
  ...
}: let
  userName = "mirin";
  userDescription = "mirinnano";
in {
  options = {
  };
  config = {
    users.users.${userName} = {
      isNormalUser = true;
      description = userDescription;
      shell = pkgs.fish;
      extraGroups = ["wheel" "docker" "wireshark" "libvirtd" "kvm" "networkmanager"];
      packages = with pkgs; [
        firefox
        thunderbird
      ];
    };
    programs.fish.enable = true;
  };
}
