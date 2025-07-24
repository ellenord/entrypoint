{ tryParseInt, ... }:

str:
let
  parsedInt = tryParseInt str;
in
if parsedInt != null then parsedInt else throw "parseInt: invalid integer string: '${str}'"
