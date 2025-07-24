{
  lib,
  isValidHex,
  isValidBinary,
  isValidDecimal,
  ...
}:
str:
let
  formatted = lib.strings.trim (lib.strings.toLower str);
in
isValidDecimal formatted || isValidHex formatted || isValidBinary formatted
