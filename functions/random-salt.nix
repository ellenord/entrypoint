{
  lib,
  ...
}:
randomSeed:
let
  seed = randomSeed;
  raw = builtins.hashString "md5" seed;
  saltAlphabet = [
    "A"
    "B"
    "C"
    "D"
    "E"
    "F"
    "G"
    "H"
    "I"
    "J"
    "K"
    "L"
    "M"
    "N"
    "O"
    "P"
    "Q"
    "R"
    "S"
    "T"
    "U"
    "V"
    "W"
    "X"
    "Y"
    "Z"
    "a"
    "b"
    "c"
    "d"
    "e"
    "f"
    "g"
    "h"
    "i"
    "j"
    "k"
    "l"
    "m"
    "n"
    "o"
    "p"
    "q"
    "r"
    "s"
    "t"
    "u"
    "v"
    "w"
    "x"
    "y"
    "z"
    "0"
    "1"
    "2"
    "3"
    "4"
    "5"
    "6"
    "7"
    "8"
    "9"
    "."
    "/"
  ];

  toSaltChar =
    a: b:
    let
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
      idx = hexMap.${lib.toLower a} + hexMap.${lib.toLower b} * 16;
    in
    builtins.elemAt saltAlphabet (lib.mod idx 64);
  saltChars = builtins.genList (
    i: toSaltChar (builtins.substring (i * 2) 1 raw) (builtins.substring ((i * 2) + 1) 1 raw)
  ) 16;
  randomSalt = builtins.concatStringsSep "" saltChars;
in
randomSalt
