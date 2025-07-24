{ lib, ... }:

str:
let
  formatted = lib.strings.trim (lib.strings.toLower str);
  isValidBinary = (builtins.match "^[+-]?0b[01]+$" formatted != null);
  isValidHex = (builtins.match "^[+-]?(0x)?[0-9a-f]+$" formatted != null);
  isValidDecimal = (builtins.match "^[+-]?[0-9]+$" formatted != null);
in
isValidBinary || isValidHex || isValidDecimal
