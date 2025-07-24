{
  tryParseHex,
  tryParseBinary,
  tryParseDecimal,
  tryParseInt,
  ...
}:
[
  {
    name = "tryParseHex";
    function = tryParseHex;
    tests = {
      "" = null;
      " \tdeadbeef\n" = 3735928559;
      "   -  0x123  " = null;
      " +0x1f " = 31;
      " -0x123" = -291;
      " 0x1f " = 31;
      "+" = null;
      "++deadbeef" = null;
      "+-deadbeef" = null;
      "+0x1A" = 26;
      "+FF" = 255;
      "+deadbeef" = 3735928559;
      "-" = null;
      "-0x2A" = -42;
      "-deadbeef" = -3735928559;
      "0x" = null;
      "0x 123" = null;
      "0x-" = null;
      "0x0" = 0;
      "0x12Z" = null;
      "0x1f" = 31;
      "0x1g" = null;
      "0xABCDEF" = 11259375;
      "0xdeadbeef" = 3735928559;
      FF = 255;
      abcdef = 11259375;
      deadbeef = 3735928559;
      xyz = null;
    };
  }
  {
    name = "tryParseBinary";
    function = tryParseBinary;
    tests = {
      "" = null;
      "\t1010\n" = 10;
      "  - 0b1010 " = null;
      "  0b1010 " = 10;
      "+" = null;
      "++1010" = null;
      "+-1010" = null;
      "+0" = 0;
      "+0b1" = 1;
      "+1010" = 10;
      "-" = null;
      "--1010" = null;
      "-0001" = -1;
      "-0b1" = -1;
      "-1010" = -10;
      "0" = 0;
      "00000001" = 1;
      "0b" = null;
      "0b0" = 0;
      "0b1" = 1;
      "0b10" = 2;
      "0b10 10" = null;
      "0b101010" = 42;
      "0b123" = null;
      "0b2" = null;
      "1" = 1;
      "10 10" = null;
      "101010" = 42;
      "102010" = null;
      abc = null;
    };
  }
  {
    name = "tryParseDecimal";
    function = tryParseDecimal;
    tests = {
      "" = null;
      "\t-99\n" = -99;
      "  42  " = 42;
      "+" = null;
      "++123" = null;
      "+-7" = null;
      "+0" = 0;
      "+1" = 1;
      "+123" = 123;
      "-" = null;
      "--42" = null;
      "-0" = 0;
      "-1" = -1;
      "-123456" = -123456;
      "0" = 0;
      "0000123" = 123;
      "0b1010" = null;
      "0x123" = null;
      "1" = 1;
      "1 2 3" = null;
      "123.45" = null;
      "1234567890" = 1234567890;
      "12a3" = null;
      "1_000" = null;
      "42" = 42;
      abc = null;
    };
  }
  {
    name = "tryParseInt";
    function = tryParseInt;
    tests = {
      "" = null;
      "   \n\t  " = null;

      # decimal priority
      "42" = 42;
      "+123" = 123;
      "-456" = -456;
      "000123" = 123;
      "1234567890" = 1234567890;

      # even if looks like hex — decimal wins
      "0x10" = 16; # parsed as valid hex
      "123abc" = 1194684; # parsed as valid hex (not decimal)
      "+0" = 0;
      "-0" = 0;

      # hex numbers (only parsed if not valid decimal)
      "+0x1f" = 31;
      "-0x2A" = -42;
      "0x0" = 0;
      "0xdeadbeef" = 3735928559;
      "deadbeef" = 3735928559;
      "0x1g" = null; # invalid char in hex
      "xyz" = null;

      # binary numbers (only if not valid dec or hex)
      "0b1010" = 10;
      "+0b1" = 1;
      "-0b1" = -1;
      "0b123" = 45347; # invalid binary but valid hex
      "1010" = 1010; # valid decimal, not binary
      "0b" = 11; # invalid binary but valid hex

      # # edge invalids
      "+" = null;
      "-" = null;
      "++10" = null;
      "--10" = null;
      "+-10" = null;

      # # malformed or ambiguous
      "  +  0x10 " = null;
      "  - 0b10" = null;
      "0x 123" = null;
      "0b 1010" = null;

      # non-numeric
      "abc" = 2748; # parsed as hex
      "0xZZZ" = null;
      "0b2" = 178; # parsed as hex
    };
  }
]
