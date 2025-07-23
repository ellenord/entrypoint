{
  setup,
  lib,
  pkgs,
  config,
  ...
}:
with setup;
let
  configuration =
    trace "${debugOutput}loading system host configuration...\n${lib.generators.toPretty { } setup}"
      (
        {
          imports =
            [
              "${hostRoot}/hardware-configuration.nix"
              "${hostRoot}/boot.nix"
              "${flakeRoot}/modules/shell.nix"
              "${flakeRoot}/modules/fonts.nix"
              "${flakeRoot}/modules/networking.nix"
              "${flakeRoot}/modules/locale.nix"
              "${flakeRoot}/modules/core"
              "${flakeRoot}/users/root.nix"
            ]
            ++ (
              if rootOnly then
                [ ]
              else
                [
                  "${flakeRoot}/users"
                ]
            );

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

          programs.nix-ld = {
            enable = true;
            libraries = with pkgs; [
              glibc
              zlib
              stdenv.cc.cc
            ];
          };
        }
        // trace "system host configuration loaded successfully!" { }
      );
in
configuration
