{ tryParseBool, ... }:

str:
let
  parsedBool = tryParseBool str;
in
if parsedBool != null then parsedBool else throw "parseBinary: invalid binary string: '${str}'"
