{
  setup,
  pkgs,
  config,
  lib,
  ...
}:
with setup;
let
  module = trace "loading system fonts configuration..." (
    {
      fonts = {
        enableGhostscriptFonts = mkDefault true;
        enableDefaultPackages = mkDefault true;
        fontconfig = {
          subpixel.rgba = mkDefault "rgb";
          defaultFonts = {
            serif = mkAfter [
              "Noto Serif"
              "Source Han Serif SC"
              "Source Han Serif TC"
              "Source Han Serif JP"
            ];
            sansSerif = mkAfter [
              "Noto Sans"
              "Source Han Sans SC"
              "Source Han Sans TC"
              "Source Han Sans JP"
            ];
            monospace = mkAfter [ "MesloLGS NF" ];
          };
        };
        packages =
          with pkgs;
          [
            # General Fonts
            corefonts

            # Monospace fonts
            fira-code
            jetbrains-mono
            meslo-lgs-nf # Font for p10k theme

            # CJK Fonts
            source-han-serif
            source-han-sans
            noto-fonts-cjk-sans
            noto-fonts-cjk-serif
            wqy_zenhei
            wqy_microhei
          ]
          ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
      };
    }
    // trace "system fonts configuration loaded successfully!" { }
  );
in
module
