{
  flakeRoot,
  execSh,
  pkgs,
  inputs,
  ...
}: {
  imports = let
    hostDir = "${flakeRoot}/hosts/entrypoint";
  in [
    "${flakeRoot}/users/ellenord.nix"
    (execSh "echo ${hostDir}/hardware-configuration.nix")
    inputs.home-manager.nixosModules.home-manager
  ];
  config = {
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
  };
}
