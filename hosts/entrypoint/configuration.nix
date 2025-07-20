{
  flakeRoot,
  execSh,
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    "${flakeRoot}/users/ellenord.nix"
    execSh
    "nixos-generate-config --dir ${flakeRoot}/hosts/entrypoint > /dev/null 2>&1 && echo ${flakeRoot}/hosts/entrypoint/hardware-configuration.nix"
    inputs.home-manager.nixosModules.home-manager
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  networking.hostName = "entrypoint";
  time.timeZone = "UTC";

  environment.systemPackages = with pkgs; [
    git
    nano
  ];

  services.openssh.enable = true;

  system.stateVersion = "25.05";
}
