{
  lib,
  pkgs,
  config,
  ...
}: let
  module =
    lib.debug.traceSeq "loading system fonts configuration..."
    ({
        fonts = {
          enableGhostscriptFonts = true;
          enableDefaultPackages = true;
          packages = with pkgs;
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
          fontconfig = {
            subpixel.rgba = "rgb";
            defaultFonts = {
              serif = ["Noto Serif" "Source Han Serif SC" "Source Han Serif TC" "Source Han Serif JP"];
              sansSerif = ["Noto Sans" "Source Han Sans SC" "Source Han Sans TC" "Source Han Sans JP"];
              monospace = ["MesloLGS NF"];
            };
          };
        };
      }
      // lib.debug.traceSeq "system fonts configuration loaded successfully!" {});
in
  module
