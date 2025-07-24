{ tryParseBinary, ... }:
binStr:
let
  parsedBin = tryParseBinary binStr;
in
if parsedBin != null then parsedBin else throw "parseBinary: invalid binary string: '${binStr}'"
