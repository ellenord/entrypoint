{
  lib,
  flakeRoot,
  ...
}:
let
  rootDir = "${flakeRoot}/functions/bool";
  loadFunction = name: argSet: import "${rootDir}/${name}.nix" argSet;
  isValidBool = loadFunction "is-valid-bool" {
    inherit lib;
  };
  tryParseBool = loadFunction "try-parse-bool" {
    inherit lib;
  };
  parseBool = loadFunction "parse-bool" {
    inherit tryParseBool;
  };
in
{
  inherit isValidBool tryParseBool parseBool;
}
