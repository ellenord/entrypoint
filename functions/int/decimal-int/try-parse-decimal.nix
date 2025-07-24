{ lib, isValidDecimal, ... }:
decStr:
let
  format = str: lib.strings.trim (lib.strings.toLower str);
in
if !(isValidDecimal (format decStr)) then
  null
else
  let
    isNegative = lib.strings.hasPrefix "-" (format decStr);
    minusRemoved = lib.strings.removePrefix "-" (format decStr);
    plusRemoved = lib.strings.removePrefix "+" (format minusRemoved);
    digits = lib.stringToCharacters plusRemoved;
    decMap = {
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
    };
    fold = lib.lists.foldl' (
      acc: char:
      let
        val = decMap.${char};
      in
      acc * 10 + val
    ) 0;
  in
  if isNegative then -(fold digits) else fold digits
