{ lib, ... }:
str:
let
  formatted = lib.strings.trim (lib.strings.toLower str);
  match = builtins.match "^[+-]?0x[0-9a-f]+$" formatted;
in
match != null
