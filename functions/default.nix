{
  lib,
  pkgs,
  execSh,
  flakeRoot,
  ...
}:
let
  loadFunction = name: argSet: import "${flakeRoot}/functions/${name}.nix" argSet;
  isValidHex = loadFunction "is-valid-hex-int" {
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
  inherit loadFunction;
  isNullOrWhitespace = loadFunction "is-null-or-whitespace" {
    inherit lib pkgs execSh;
  };
  debug = loadFunction "debug" {
    inherit lib pkgs execSh;
  };
  getEnv = loadFunction "get-env" {
    inherit lib pkgs execSh;
  };
  getRandomSalt = loadFunction "get-random-salt" {
    inherit lib pkgs execSh;
  };
  getHashedPassword = loadFunction "get-hashed-password" {
    inherit lib pkgs execSh;
  };
  isValidDecimal = loadFunction "is-valid-decimal-int" {
    inherit lib;
  };
  isValidBinary = loadFunction "is-valid-binary-int" {
    inherit lib;
  };
  isValidInt = loadFunction "is-valid-int" {
    inherit lib;
  };
  inherit isValidHex tryParseHex parseHex;
}
