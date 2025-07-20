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
  nix.settings = {
    allow-unsafe-native-code-during-evaluation = true;
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };
  networking.hostName = "entrypoint";
  time.timeZone = "UTC";

  environment.systemPackages = with pkgs; [
    git
    nano
    htop
    neofetch
    wget
    curl
    openvscode-server
    direnv
    nixpkgs-fmt
    nil
    nixfmt-rfc-style
    vscode-extensions.jnoortheen.nix-ide
    alejandra
    nix-direnv
    statix
  ];

  services.openssh.enable = true;

  system.stateVersion = "25.05";

  boot.kernelParams = [
    "console=ttyS0,115200"
    "quiet"
  ];
  programs.zsh.enable = true;

  networking.firewall.allowedTCPPorts = [8080];

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    glibc
    zlib
    stdenv.cc.cc
  ];
  programgs.git = {
    enable = true;
    userName = "ellenord";
    userEmail = "ellenord.zelleratumm@gmail.com";
    extraConfig = {
      credential.helper = "store";
      init.defaultBranch = "main";
      pull.rebase = false;
      push.default = "simple";
    };
  };
}
