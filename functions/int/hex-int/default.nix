{
  lib,
  flakeRoot,
  ...
}:
let
  rootDir = "${flakeRoot}/functions/int/hex-int";
  loadFunction = name: argSet: import "${rootDir}/${name}.nix" argSet;
  isValidHex = loadFunction "is-valid-hex" {
    inherit lib;
  };
  tryParseHex = loadFunction "try-parse-hex" {
    inherit lib isValidHex;
  };
  parseHex = loadFunction "parse-hex" {
    inherit tryParseHex;
  };
in
{
  inherit isValidHex tryParseHex parseHex;
}
