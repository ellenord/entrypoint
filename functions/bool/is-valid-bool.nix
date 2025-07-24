{ lib, ... }:
str:
let
  formatted = lib.strings.trim (lib.strings.toLower str);
in
formatted == "true" || formatted == "false"
