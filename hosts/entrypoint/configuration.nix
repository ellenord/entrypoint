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
    "${flakeRoot}/modules/shell.nix"
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
    htop
    neofetch
    wget
    curl
    code-server
  ];

  services.openssh.enable = true;

  system.stateVersion = "25.05";

  boot.kernelParams = [
    "console=ttyS0,115200"
    "quiet"
  ];
  services.code-server = {
    enable = true;
    hashedPassword = "$argon2i$v=19$m=4096,t=3,p=1$azZQYytvMTkvUTFCQ2FZTWE4WktqeERsV1NvPQ$METj7U0AUSlr2dUafUIk1yXYP8ehCoOp5+ri8NHvS0Y";
    user = "ellenord";
    host = "localhost";
    port = 4444;
    disableWorkspaceTrust = true;
    disableUpdateCheck = true;
    auth = "password";
  };
  networking.firewall.allowedTCPPorts = [4444];
}
