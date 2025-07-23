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
        isNormalUser = mkForce true;
        hashedPassword = mkForce (
          trace "hashed user password: '${hashedUserPassword}' with salt: '${randomSalt}'" hashedUserPassword
        );
        extraGroups = mkAfter [
          "networkmanager"
          "wheel"
          "docker"
        ];
        shell = mkForce pkgs.zsh;
      };
    }
    // trace "system '${username}' user configuration loaded successfully!" { }
  );
in
module
