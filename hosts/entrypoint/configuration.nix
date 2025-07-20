{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./../../users/ellenord.nix
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
