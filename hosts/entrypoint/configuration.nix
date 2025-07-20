{
  setup,
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
with setup; let
  configuration = lib.debug.traceSeq "loading system host configuration...\n${lib.generators.toPretty {} setup}" ({
      imports =
        [
          (lib.debug.traceSeq
            "loading system hardware configuration..."
            "${hostRoot}/hardware-configuration.nix")
          "${hostRoot}/boot.nix"
          "${flakeRoot}/modules/shell.nix"
          "${flakeRoot}/modules/fonts.nix"
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

      programs.zsh.enable = true;

      networking.firewall.allowedTCPPorts = [8080];

      programs.nix-ld.enable = true;
      programs.nix-ld.libraries = with pkgs; [
        glibc
        zlib
        stdenv.cc.cc
      ];
    }
    // lib.debug.traceSeq "system host configuration loaded successfully!" {});
in
  configuration
