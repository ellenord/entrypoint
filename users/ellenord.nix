{
  pkgs,
  options,
  lib,
  ...
}:
let
  username = "ellenord";
in
{
  config.users.users.${username} = {
    isNormalUser = true;
    hashedPassword = "$6$fEO6vnNjbEqXL2Q3$QYEQ2FBY6LSiNF/bOl8C04gC4KiasIc0xg1Ue/lxI9DVWPWqYgrCk6.SScTMpbspcSn93rIz37Z6gcfLPIHwQ0";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
    shell = pkgs.zsh;
  };

  config.home-manager.users.${username} = {
    home.username = username;
    home.homeDirectory = "/home/${username}";
    home.stateVersion = "25.05";

    programs.home-manager.enable = true;
    programs.git.enable = true;
    home.packages = with pkgs; [
      htop
      neofetch
    ];
  };
}
