{ lib, isValidHex, ... }:
hexStr:
let
  format = str: lib.strings.trim (lib.strings.toLower str);
in
if !(isValidHex (format hexStr)) then
  null
else
  let
    safeSqr =
      v:
      (
        if 9223372036854775807 - v <= v then
          (builtins.trace "\n\n\n <<<<<<<<<<< safeSqr: ${toString v} >>>>>>>>>>\n\n\n" (
            -9223372036854775807 - 1 + v + v - 9223372036854775807 - 1
          ))
        else
          v * 2
      );
    isNegative = lib.strings.hasPrefix "-" (format hexStr);
    minusRemoved = lib.strings.removePrefix "-" (format hexStr);
    plusRemoved = lib.strings.removePrefix "+" (format minusRemoved);
    cleaned = lib.strings.removePrefix "0x" (format plusRemoved);
    digits = lib.stringToCharacters cleaned;
    hexMap = {
      "0" = 0;
      "1" = 1;
      "2" = 2;
      "3" = 3;
      "4" = 4;
      "5" = 5;
      "6" = 6;
      "7" = 7;
      "8" = 8;
      "9" = 9;
      "a" = 10;
      "b" = 11;
      "c" = 12;
      "d" = 13;
      "e" = 14;
      "f" = 15;
    };
    fold = lib.lists.foldl' (
      acc: char:
      let
        val = hexMap.${char};
      in
      (safeSqr (acc * 8)) + val
    ) 0;
  in
  if isNegative then -(fold digits) else fold digits
