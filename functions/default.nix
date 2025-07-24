{
  lib,
  pkgs,
  execSh,
  flakeRoot,
  ...
}:
let
  rootDir = "${flakeRoot}/functions";
  loadFunction = name: argSet: import "${rootDir}/${name}.nix" argSet;
  int = import "${rootDir}/int" {
    inherit lib flakeRoot;
  };
  trace = lib.debug.traceSeq;
in
with int;
{
  inherit loadFunction;
  isNullOrWhitespace = loadFunction "is-null-or-whitespace" {
    inherit lib pkgs execSh;
  };
  debug = loadFunction "debug" {
    inherit trace;
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
  runUnitTests = loadFunction "run-unit-tests" {
    inherit lib;
  };
  inherit
    trace
    isValidHex
    tryParseHex
    parseHex
    isValidBinary
    tryParseBinary
    parseBinary
    isValidDecimal
    tryParseDecimal
    parseDecimal
    isValidInt
    tryParseInt
    parseInt
    ;
}
