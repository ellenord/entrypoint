{
  lib,
  config,
  setup,
  pkgs,
  ...
}:
with setup;
let
  module = trace "loading system '${username}' user configuration..." (
    {
      config.users.users.${username} = {
        isNormalUser = true;
        hashedPassword = trace "hashed user password: '${hashedUserPassword}' with salt: '${randomSalt}'" hashedUserPassword;
        extraGroups = [
          "networkmanager"
          "wheel"
          "docker"
        ];
        shell = mkForce pkgs.zsh;
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
    // trace "system '${username}' user configuration loaded successfully!" { }
  );
in
module
