{ lib, ... }:
str:
let
  formatted = lib.strings.trim (lib.strings.toLower str);
  match = builtins.match "^[+-]?[0-9]+$" formatted;
in
match != null
