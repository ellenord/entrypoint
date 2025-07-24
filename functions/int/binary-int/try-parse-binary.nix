{ lib, isValidBinary, ... }:
binStr:
let
  format = str: lib.strings.trim (lib.strings.toLower str);
in
if !(isValidBinary (format binStr)) then
  null
else
  let
    isNegative = lib.strings.hasPrefix "-" (format binStr);
    minusRemoved = lib.strings.removePrefix "-" (format binStr);
    plusRemoved = lib.strings.removePrefix "+" (format minusRemoved);
    cleaned = lib.strings.removePrefix "0b" (format plusRemoved);
    digits = lib.stringToCharacters cleaned;
    binMap = {
      "0" = 0;
      "1" = 1;
    };
    fold = lib.lists.foldl' (
      acc: char:
      let
        val = binMap.${char};
      in
      acc * 2 + val
    ) 0;
  in
  if isNegative then -(fold digits) else fold digits
