{ tryParseDecimal, ... }:
decStr:
let
  parsedDec = tryParseDecimal decStr;
in
if parsedDec != null then parsedDec else throw "parseDecimal: invalid decimal string: '${decStr}'"
