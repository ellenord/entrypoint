{
  lib,
  pkgs,
  execSh,
  ...
}:
str:
assert
  builtins.typeOf str == "string"
  || throw "parseBool: expected a string, got ${builtins.typeOf str}";
let
  trimmedValue = lib.strings.trim str;
  value = lib.strings.toLower trimmedValue;
in
if value == "0" || value == "false" then
  false
else if value == "1" || value == "true" then
  true
else
  value
