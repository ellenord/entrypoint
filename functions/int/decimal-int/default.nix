{
  lib,
  flakeRoot,
  ...
}:
let
  rootDir = "${flakeRoot}/functions/int/decimal-int";
  loadFunction = name: argSet: import "${rootDir}/${name}.nix" argSet;
  isValidDecimal = loadFunction "is-valid-decimal" {
    inherit lib;
  };
  tryParseDecimal = loadFunction "try-parse-decimal" {
    inherit lib isValidDecimal;
  };
  parseDecimal = loadFunction "parse-decimal" {
    inherit tryParseDecimal;
  };
in
{
  inherit isValidDecimal tryParseDecimal parseDecimal;
}
