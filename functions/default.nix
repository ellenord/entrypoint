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
  bool = import "${rootDir}/bool" {
    inherit lib flakeRoot;
  };
in
with int // bool;
{
  isNullOrWhitespace = loadFunction "is-null-or-whitespace" {
    inherit lib pkgs execSh;
  };
  getRandomSalt = loadFunction "get-random-salt" {
    inherit lib parseHex;
  };
  getHashedPassword = loadFunction "get-hashed-password" {
    inherit pkgs execSh;
  };
  runUnitTests = loadFunction "run-unit-tests" {
    inherit lib;
  };
  getRandomInt = loadFunction "get-random-int" {
    inherit
      pkgs
      execSh
      parseInt
      ;
  };
  trace = lib.debug.traceSeq;
  inherit
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
    isValidBool
    tryParseBool
    parseBool
    ;
}
