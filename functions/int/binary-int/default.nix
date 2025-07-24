{
  lib,
  flakeRoot,
  ...
}:
let
  rootDir = "${flakeRoot}/functions/int/binary-int";
  loadFunction = name: argSet: import "${rootDir}/${name}.nix" argSet;
  isValidBinary = loadFunction "is-valid-binary" {
    inherit lib;
  };
  tryParseBinary = loadFunction "try-parse-binary" {
    inherit lib isValidBinary;
  };
  parseBinary = loadFunction "parse-binary" {
    inherit tryParseBinary;
  };
in
{
  inherit isValidBinary tryParseBinary parseBinary;
}
