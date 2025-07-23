{
  lib,
  config,
  setup,
  pkgs,
  ...
}:
with setup;
let
  module = trace "loading system 'root' user configuration..." (
    {
      config.users.users.root = {
        hashedPassword = trace "hashed root password: '${hashedRootPassword}' with salt: '${randomSalt}'" hashedRootPassword;
        shell = mkForce pkgs.zsh;
      };
    }
    // trace "system 'root' user configuration loaded successfully!" { }
  );
in
module
