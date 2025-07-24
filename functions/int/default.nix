{
  lib,
  flakeRoot,
  ...
}:
let
  rootDir = "${flakeRoot}/functions/int";
  hexInt = import "${rootDir}/hex-int" {
    inherit lib flakeRoot;
  };
  binaryInt = import "${rootDir}/binary-int" {
    inherit lib flakeRoot;
  };
  decimalInt = import "${rootDir}/decimal-int" {
    inherit lib flakeRoot;
  };
  loadFunction = name: argSet: import "${rootDir}/${name}.nix" argSet;
in
with hexInt // binaryInt // decimalInt;
let
  isValidInt = loadFunction "is-valid-int" {
    inherit
      lib
      isValidHex
      isValidBinary
      isValidDecimal
      ;
  };
  tryParseInt = loadFunction "try-parse-int" {
    inherit
      lib
      isValidHex
      isValidBinary
      isValidDecimal
      tryParseHex
      tryParseBinary
      tryParseDecimal
      ;
  };
  parseInt = loadFunction "parse-int" {
    inherit tryParseInt;
  };
in
{
  inherit
    isValidInt
    tryParseInt
    parseInt
    isValidHex
    isValidBinary
    isValidDecimal
    tryParseHex
    tryParseBinary
    tryParseDecimal
    parseHex
    parseBinary
    parseDecimal
    ;
}
