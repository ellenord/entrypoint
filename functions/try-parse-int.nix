{ lib, ... }:

str:
let
  valid = builtins.match "^[0-9]+$" str;
in
true
