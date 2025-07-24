{
  lib,
  isValidHex,
  isValidBinary,
  isValidDecimal,
  tryParseHex,
  tryParseBinary,
  tryParseDecimal,
  ...
}:
str:
let
  intStr = lib.strings.trim (lib.strings.toLower str);
in
if isValidDecimal intStr then
  tryParseDecimal intStr
else if isValidBinary intStr then
  tryParseBinary intStr
else if isValidHex intStr then
  tryParseHex intStr
else
  null
