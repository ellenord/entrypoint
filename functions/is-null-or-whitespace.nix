{
  lib,
  ...
}:
str: str == null || lib.strings.trim (builtins.toString str) == ""
