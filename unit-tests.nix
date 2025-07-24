{
  tryParseHex,
  tryParseBinary,
  tryParseDecimal,
  tryParseInt,
  tryParseBool,
  ...
}:
[
  {
    name = "tryParseHex";
    function = tryParseHex;
    tests = {
      "" = null;
      " \tdeadbeef\n" = null;
      "   -  0x123  " = null;
      " +0x1f " = 31;
      " -0x123" = -291;
      " 0x1f " = 31;
      "+" = null;
      "++deadbeef" = null;
      "+-deadbeef" = null;
      "+0x1A" = 26;
      "+FF" = null;
      "+deadbeef" = null;
      "-" = null;
      "-0x2A" = -42;
      "-deadbeef" = null;
      "0x" = null;
      "0x 123" = null;
      "0x-" = null;
      "0x0" = 0;
      "0x12Z" = null;
      "0x1f" = 31;
      "0x1g" = null;
      "0xABCDEF" = 11259375;
      "0xdeadbeef" = 3735928559;
      "FF" = null;
      "abcdef" = null;
      "deadbeef" = null;
      "xyz" = null;
    };
  }
  {
    name = "tryParseBinary";
    function = tryParseBinary;
    tests = {
      "" = null;
      "\t1010\n" = null;
      "  - 0b1010 " = null;
      "  0b1010 " = 10;
      "+" = null;
      "++1010" = null;
      "+-1010" = null;
      "+0" = null;
      "+0b1" = 1;
      "+1010" = null;
      "-" = null;
      "--1010" = null;
      "-0001" = null;
      "-0b1" = -1;
      "-1010" = null;
      "0" = null;
      "00000001" = null;
      "0b" = null;
      "0b0" = 0;
      "0b1" = 1;
      "0b10" = 2;
      "0b10 10" = null;
      "0b101010" = 42;
      "0b123" = null;
      "0b2" = null;
      "1" = null;
      "10 10" = null;
      "101010" = null;
      "102010" = null;
      "abc" = null;
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
      "abc" = null;
    };
  }
  {
    name = "tryParseInt";
    function = tryParseInt;
    tests = {
      "" = null;
      "   \n\t  " = null;
      "42" = 42;
      "+123" = 123;
      "-456" = -456;
      "000123" = 123;
      "1234567890" = 1234567890;
      "0x10" = 16;
      "123abc" = null;
      "+0" = 0;
      "-0" = 0;
      "+0x1f" = 31;
      "-0x2A" = -42;
      "0x0" = 0;
      "0xdeadbeef" = 3735928559;
      "deadbeef" = null;
      "0x1g" = null;
      "xyz" = null;
      "0b1010" = 10;
      "+0b1" = 1;
      "-0b1" = -1;
      "0b123" = null;
      "1010" = 1010;
      "0b" = null;
      "+" = null;
      "-" = null;
      "++10" = null;
      "--10" = null;
      "+-10" = null;
      "  +  0x10 " = null;
      "  - 0b10" = null;
      "0x 123" = null;
      "0b 1010" = null;
      "abc" = null;
      "0xZZZ" = null;
      "0b2" = null;
    };
  }
  {
    name = "tryParseBool";
    function = tryParseBool;
    tests = {
      "" = null;
      "   " = null;
      "true" = true;
      "false" = false;
      "TRUE" = true;
      "False" = false;
      " TrUe  " = true;
      " FaLSe " = false;

      # invalid variations
      "yes" = null;
      "no" = null;
      "0" = null;
      "1" = null;
      "truee" = null;
      "falsee" = null;
      "null" = null;
      "undefined" = null;
      "maybe" = null;
      "on" = null;
      "off" = null;
      "tru" = null;
      "fals" = null;
    };
  }
]
