{
  lib,
  pkgs,
  execSh,
  ...
}:
var:
let
  value = builtins.getEnv var;
in
if lib.isNullOrWhitespace value then
  null
else
  let
    trimmedValue = lib.strings.trim value;
    value = lib.strings.toLower trimmedValue;
  in
  if value == "0" || value == "false" then
    false
  else if value == "1" || value == "true" then
    true
  else
    value
