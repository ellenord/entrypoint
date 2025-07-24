{ lib, ... }:

unitTests:
let
  name = unitTests.name;
  func = unitTests.function;
  tests = unitTests.tests;
  results = lib.attrValues (
    builtins.mapAttrs (
      input: expected:
      let
        output = func input;
        result = if output == expected then "✅ PASSED" else "❌ FAILED";
      in
      {
        inherit
          input
          expected
          output
          result
          ;
      }
    ) tests
  );
in
{
  inherit
    name
    func
    tests
    results
    ;
}
