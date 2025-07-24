{ lib, ... }:

str:
let
  formatted = lib.strings.trim (lib.strings.toLower str);
in
if formatted == "true" then
  true
else if formatted == "false" then
  false
else
  null
