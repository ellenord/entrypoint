{
  flakeRoot,
  execSh,
  pkgs,
  config,
  inputs,
  ...
}: {
  imports = let
    hostDir = "${flakeRoot}/hosts/entrypoint";
  in [
    "${flakeRoot}/users/ellenord.nix"
    "${hostDir}/hardware-configuration.nix"
    # (execSh "echo ${hostDir}/hardware-configuration.nix")
    inputs.home-manager.nixosModules.home-manager
  ];
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
    device = "nodev";
    useOSProber = false;
    configurationLimit = 8;
    extraConfig = ''
      serial --unit=0 --speed=115200
      terminal_input serial
      terminal_output serial
    '';
  };
  nix.settings.allow-unsafe-native-code-during-evaluation = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  programs.zsh.enable = true;
  networking.hostName = "entrypoint";
  time.timeZone = "UTC";

  environment.systemPackages = with pkgs; [
    git
    nano
    zsh
    htop
    neofetch
    wget
    curl
  ];

  services.openssh.enable = true;

  system.stateVersion = "25.05";

  boot.kernelParams = [
    "console=ttyS0,115200"
    "quiet"
  ];
}
