{ lib, ... }:
str:
let
  formatted = lib.strings.trim (lib.strings.toLower str);
  match = builtins.match "^[-+]?0b[01]+$" formatted;
in
match != null
