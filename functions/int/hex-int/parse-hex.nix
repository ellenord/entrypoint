{ tryParseHex, ... }:
hexStr:
let
  parsedHex = tryParseHex hexStr;
in
if parsedHex != null then parsedHex else throw "parseHex: invalid hex string: '${hexStr}'"
