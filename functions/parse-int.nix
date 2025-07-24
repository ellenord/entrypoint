{ lib, ... }:

str:
let
  valid = builtins.match "^[0-9]+$" str;
in
if valid != null then builtins.fromJSON str else throw "parseInt: invalid integer string: '${str}'"
