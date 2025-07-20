{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hosts/entrypoint/hardware-configuration.nix
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
