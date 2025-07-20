{
  setup,
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
with setup;
  builtins.trace "LOADING CONFIGURATION: ${lib.generators.toPretty {} setup}" {
    imports =
      [
        (builtins.trace
          "loading hardware configuration..."
          "${hostRoot}/hardware-configuration.nix")
        "${flakeRoot}/modules/shell.nix"
        "${flakeRoot}/modules/core"
      ]
      ++ (
        if rootOnly
        then []
        else [
          "${flakeRoot}/users/${username}.nix"
          inputs.home-manager.nixosModules.home-manager
        ]
      );
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
    networking.hostName = "${hostName}";
    time.timeZone = "${timezone}";

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
  }
