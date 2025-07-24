{
  description = "A highly impure and deliberately unorthodox flake template, wired for external, imperative configuration and full experimental chaos.";

  inputs = {
    # We're using the unstable channel because we plan to use bleeding-edge
    # and experimental features that require the latest Nixpkgs.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    {
      self,
      ...
    }@inputs:
    let

      nixpkgs = inputs.nixpkgs;

      # Shell out at eval time — impure, dangerous, and sometimes absolutely necessary.
      execSh =
        expression:
        builtins.exec ([
          "sh"
          "-c"
          expression
        ]);

      # The root of this flake, determined the dirty way.
      # Flakes won’t give us relative paths, so we use `execSh "pwd"`
      # to grab the real path at eval time. Impure? Yes. Effective? Absolutely.
      flakeRoot = toString (execSh "pwd");

      system = builtins.getEnv "NIXOS_SYSTEM";

      pkgs = import nixpkgs {
        inherit system;
      };

      lib = nixpkgs.lib;

      functions = import "${flakeRoot}/functions/default.nix" {
        inherit
          lib
          pkgs
          execSh
          flakeRoot
          ;
      };
      configuration =
        with functions;
        let

          # functionsDir = "${flakeRoot}/functions";
          # functionsFiles = builtins.readDir functionsDir;

          inherit system;

          configPath = "${flakeRoot}/configurations/default.json";
          rawConfig = builtins.fromJSON (builtins.readFile configPath);

          hostName = builtins.getEnv "CFG_HOSTNAME";
          timezone =
            let
              val = builtins.getEnv "CFG_TIMEZONE";
            in
            if isNullOrWhitespace val then "UTC" else val;
          username = builtins.getEnv "CFG_USERNAME";
          rootOnly =
            let
              val = isNullOrWhitespace username;
            in
            lib.warnIf val "CFG_USERNAME is not set, using root only mode" val;
          locale = builtins.getEnv "CFG_LOCALE";
          undefinedLocale =
            let
              val = isNullOrWhitespace locale;
            in
            lib.warnIf val "CFG_LOCALE is not set, using default: \"en_US.UTF-8\"" val;
          rtkitEnabled =
            builtins.getEnv "CFG_RTKIT_ENABLED" == "1" || builtins.getEnv "CFG_RTKIT_ENABLED" == "true";
          fstrimEnabled =
            builtins.getEnv "CFG_FSTRIM_ENABLED" == "1" || builtins.getEnv "CFG_FSTRIM_ENABLED" == "true";

          mkForce = lib.mkForce;
          mkAfter = lib.mkAfter;
          mkBefore = lib.mkBefore;
          mkDefault = lib.mkDefault;
          mapAttrs = lib.mapAttrs;

          # tests = {
          #   hexTest = trace {

          #     "TEST" = "hex parser test suite";

          #     # ✅ valid hex with 0x prefix
          #     "0x1f" = tryParseHex "0x1f";
          #     "0x0" = tryParseHex "0x0";
          #     "0xdeadbeef" = tryParseHex "0xdeadbeef";
          #     "0xABCDEF" = tryParseHex "0xABCDEF";

          #     # ✅ valid hex without prefix
          #     "FF" = tryParseHex "FF";
          #     "deadbeef" = tryParseHex "deadbeef";
          #     "abcdef" = tryParseHex "abcdef";

          #     # ✅ valid with unary plus
          #     "+0x1A" = tryParseHex "+0x1A";
          #     "+FF" = tryParseHex "+FF";
          #     "+deadbeef" = tryParseHex "+deadbeef";

          #     # ✅ valid negative hex
          #     "-0x2A" = tryParseHex "-0x2A";
          #     "-deadbeef" = tryParseHex "-deadbeef";

          #     # ❌ invalid hex with non-hex chars
          #     "0x1g" = tryParseHex "0x1g";
          #     "xyz" = tryParseHex "xyz";
          #     "0x12Z" = tryParseHex "0x12Z";

          #     # ❌ empty or malformed
          #     "" = tryParseHex "";
          #     "0x" = tryParseHex "0x";
          #     "-" = tryParseHex "-";
          #     "0x-" = tryParseHex "0x-";
          #     "+" = tryParseHex "+";
          #     "++deadbeef" = tryParseHex "++deadbeef";
          #     "+-deadbeef" = tryParseHex "+-deadbeef";

          #     # ❌ spaces in wrong places
          #     " -0x123" = tryParseHex " -0x123";
          #     "0x 123" = tryParseHex "0x 123";
          #     "   -  0x123  " = tryParseHex "   -  0x123  ";

          #     # ✅ extra whitespace, but otherwise valid
          #     " 0x1f " = tryParseHex " 0x1f ";
          #     " \tdeadbeef\n" = tryParseHex " \tdeadbeef\n";
          #     " +0x1f " = tryParseHex " +0x1f ";
          #   } "hex parser test suite";
          #   binaryTest = trace {

          #     "TEST" = "binary parser test suite";

          #     # ✅ valid binary with 0b prefix
          #     "0b0" = tryParseBinary "0b0";
          #     "0b1" = tryParseBinary "0b1";
          #     "0b10" = tryParseBinary "0b10";
          #     "0b101010" = tryParseBinary "0b101010";

          #     # ✅ valid binary without prefix
          #     "1" = tryParseBinary "1";
          #     "0" = tryParseBinary "0";
          #     "101010" = tryParseBinary "101010";
          #     "00000001" = tryParseBinary "00000001";

          #     # ✅ valid with unary plus
          #     "+0b1" = tryParseBinary "+0b1";
          #     "+1010" = tryParseBinary "+1010";
          #     "+0" = tryParseBinary "+0";

          #     # ✅ valid with unary minus
          #     "-0b1" = tryParseBinary "-0b1";
          #     "-1010" = tryParseBinary "-1010";
          #     "-0001" = tryParseBinary "-0001";

          #     # ✅ whitespace handling
          #     "  0b1010 " = tryParseBinary "  0b1010 ";
          #     "\t1010\n" = tryParseBinary "\t1010\n";

          #     # ❌ invalid: contains non-binary digits
          #     "0b2" = tryParseBinary "0b2";
          #     "102010" = tryParseBinary "102010";
          #     "0b123" = tryParseBinary "0b123";
          #     "abc" = tryParseBinary "abc";

          #     # ❌ invalid: malformed signs
          #     "++1010" = tryParseBinary "++1010";
          #     "+-1010" = tryParseBinary "+-1010";
          #     "--1010" = tryParseBinary "--1010";

          #     # ❌ invalid: just prefix or sign
          #     "" = tryParseBinary "";
          #     "-" = tryParseBinary "-";
          #     "+" = tryParseBinary "+";
          #     "0b" = tryParseBinary "0b";

          #     # ❌ invalid: spacing inside number
          #     "0b10 10" = tryParseBinary "0b10 10";
          #     "10 10" = tryParseBinary "10 10";
          #     "  - 0b1010 " = tryParseBinary "  - 0b1010 ";
          #   } "binary parser test suite";
          #   decimalTest = trace {

          #     "TEST" = "decimal parser test suite";

          #     # ✅ valid integers
          #     "0" = tryParseDecimal "0";
          #     "1" = tryParseDecimal "1";
          #     "42" = tryParseDecimal "42";
          #     "1234567890" = tryParseDecimal "1234567890";
          #     "0000123" = tryParseDecimal "0000123"; # leading zeros

          #     # ✅ valid with unary plus
          #     "+0" = tryParseDecimal "+0";
          #     "+1" = tryParseDecimal "+1";
          #     "+123" = tryParseDecimal "+123";

          #     # ✅ valid with unary minus
          #     "-0" = tryParseDecimal "-0";
          #     "-1" = tryParseDecimal "-1";
          #     "-123456" = tryParseDecimal "-123456";

          #     # ✅ valid with surrounding whitespace
          #     "  42  " = tryParseDecimal "  42  ";
          #     "\t-99\n" = tryParseDecimal "\t-99\n";

          #     # ❌ malformed signs
          #     "++123" = tryParseDecimal "++123";
          #     "--42" = tryParseDecimal "--42";
          #     "+-7" = tryParseDecimal "+-7";

          #     # ❌ non-numeric characters
          #     "12a3" = tryParseDecimal "12a3";
          #     "abc" = tryParseDecimal "abc";
          #     "123.45" = tryParseDecimal "123.45"; # decimal point not allowed
          #     "0x123" = tryParseDecimal "0x123"; # not hex
          #     "0b1010" = tryParseDecimal "0b1010"; # not binary
          #     "1 2 3" = tryParseDecimal "1 2 3"; # spaces in number
          #     "1_000" = tryParseDecimal "1_000"; # underscore not allowed

          #     # ❌ empty or incomplete input
          #     "" = tryParseDecimal "";
          #     "+" = tryParseDecimal "+";
          #     "-" = tryParseDecimal "-";
          #   } "decimal parser test suite";
          # };
          debugOutput = "";
          # x =
          # let
          #   tests = {
          #     "" = null;
          #     " \tdeadbeef\n" = 3735928559;
          #     "   -  0x123  " = null;
          #     " +0x1f " = 31;
          #     " -0x123" = -291;
          #     " 0x1f " = 31;
          #     "+" = null;
          #     "++deadbeef" = null;
          #     "+-deadbeef" = null;
          #     "+0x1A" = 26;
          #     "+FF" = 255;
          #     "+deadbeef" = 3735928559;
          #     "-" = null;
          #     "-0x2A" = -42;
          #     "-deadbeef" = -3735928559;
          #     "0x" = null;
          #     "0x 123" = null;
          #     "0x-" = null;
          #     "0x0" = 0;
          #     "0x12Z" = null;
          #     "0x1f" = 31;
          #     "0x1g" = null;
          #     "0xABCDEF" = 11259375;
          #     "0xdeadbeef" = 3735928559;
          #     FF = 255;
          #     abcdef = 11259375;
          #     deadbeef = 3735928559;
          #     xyz = null;
          #   };
          #   testResults = builtins.mapAttrs (
          #     input: expected:
          #     let
          #       result = tryParseHex input;
          #     in
          #     {
          #       output = result;
          #       expected = expected;
          #     }
          #   ) tests;
          #   formattedResults = lib.mapAttrsToList (
          #     name: passed:
          #     let
          #       result = passed.output == passed.expected;
          #     in
          #     {
          #       function = "tryParseHex";
          #       input = name;
          #       output = passed.output;
          #       expected = passed.expected;
          #       result = if result then "✅ passed" else "❌ failed";
          #     }
          #   ) testResults;
          # in
          # debug formattedResults;

          allUnitTestsResults =
            let
              allUnitTests = import "${flakeRoot}/unit-tests.nix" {
                inherit
                  tryParseHex
                  tryParseBinary
                  tryParseDecimal
                  tryParseInt
                  tryParseBool
                  ;
              };
            in
            builtins.map runUnitTests allUnitTests;
          # tryParseHexUnitTests = runUnitTests tryParseHex {
          #   "" = null;
          #   " \tdeadbeef\n" = 3735928559;
          #   "   -  0x123  " = null;
          #   " +0x1f " = 31;
          #   " -0x123" = -291;
          #   " 0x1f " = 31;
          #   "+" = null;
          #   "++deadbeef" = null;
          #   "+-deadbeef" = null;
          #   "+0x1A" = 26;
          #   "+FF" = 255;
          #   "+deadbeef" = 3735928559;
          #   "-" = null;
          #   "-0x2A" = -42;
          #   "-deadbeef" = -3735928559;
          #   "0x" = null;
          #   "0x 123" = null;
          #   "0x-" = null;
          #   "0x0" = 0;
          #   "0x12Z" = null;
          #   "0x1f" = 31;
          #   "0x1g" = null;
          #   "0xABCDEF" = 11259375;
          #   "0xdeadbeef" = 3735928559;
          #   FF = 255;
          #   abcdef = 11259375;
          #   deadbeef = 3735928559;
          #   xyz = null;
          # };

          randomSeed = builtins.getEnv "CFG_RANDOM_SEED";

          randomSalt = getRandomSalt randomSeed;

          userPassword = builtins.getEnv "CFG_USER_PASSWORD";
          rootPassword = builtins.getEnv "CFG_ROOT_PASSWORD";

          hashedPassword = getHashedPassword randomSalt;
          hashedUserPassword = hashedPassword userPassword;
          hashedRootPassword = hashedPassword rootPassword;

          hostRoot = "${flakeRoot}/hosts/${hostName}";

          # configDir = "${flakeRoot}/configurations";
          # configFiles = builtins.readDir configDir;
          # configs = builtins.listToAttrs (
          #   lib.filter (x: x != null) (
          #     lib.mapAttrsToList (
          #       filename: type:
          #       if type == "regular" && lib.hasSuffix ".json" filename then
          #         let
          #           configPath = "${configDir}/${filename}";
          #           rawConfig = builtins.fromJSON (builtins.readFile configPath);

          #           system = rawConfig.system or "x86_64-linux";
          #           hostName = rawConfig.hostname;

          #           # остальные поля можно извлекать так же
          #           # можно также добавить fallback’ы

          #           pkgs = import nixpkgs {
          #             inherit system;
          #           };

          #           setup = {
          #             inherit
          #               system
          #               hostName
          #               rawConfig
          #               flakeRoot
          #               ;
          #             # и другие поля
          #           };

          #           utils = {
          #             inherit execSh isNullOrWhitespace;
          #           };

          #         in
          #         {
          #           name = hostName;
          #           value = nixpkgs.lib.nixosSystem {
          #             specialArgs = {
          #               inherit inputs setup system;
          #               lib = nixpkgs.lib // utils;
          #             };
          #             modules = [ "${flakeRoot}/hosts/${hostName}/configuration.nix" ];
          #           };
          #         }
          #       else
          #         null
          #     ) configFiles
          #   )
          # );
        in
        {
          inherit
            system
            hostName
            flakeRoot
            hostRoot
            timezone
            username
            rootOnly
            locale
            undefinedLocale
            rtkitEnabled
            fstrimEnabled
            randomSeed
            mkForce
            mkAfter
            mkDefault
            trace
            mapAttrs
            mkBefore
            hashedUserPassword
            hashedRootPassword
            randomSalt
            debugOutput
            isNullOrWhitespace
            tryParseHexUnitTests
            allUnitTestsResults
            ;
        };
    in
    with configuration;
    assert !isNullOrWhitespace system || throw "CFG_SYSTEM environment variable must be set";
    assert !isNullOrWhitespace hostName || throw "CFG_HOSTNAME environment variable must be set";
    assert !isNullOrWhitespace randomSeed || throw "CFG_RANDOM_SEED environment variable must be set";
    assert
      builtins.all (x: x) (
        builtins.map (
          unitTestsResults:
          (
            let
              ok = (
                builtins.all (
                  x:
                  let
                    result = x.output == x.expected;
                  in
                  if result then
                    result
                  else
                    (trace "unit test failed: ${x.function}(${x.input}) = ${x.output}, expected ${x.expected}" result)
                ) unitTestsResults.results
              );
            in
            trace "unit tests results for ${unitTestsResults.name}: ${lib.generators.toPretty { } unitTestsResults.results}}" ok
          )
        ) allUnitTestsResults
      )
      || throw "all unit tests must be passed";
    {
      nixosConfigurations.${hostName} =
        let
          setup = {
            inherit
              system
              hostName
              flakeRoot
              hostRoot
              timezone
              username
              rootOnly
              locale
              undefinedLocale
              rtkitEnabled
              fstrimEnabled
              randomSeed
              mkForce
              mkAfter
              mkDefault
              trace
              mapAttrs
              mkBefore
              hashedUserPassword
              hashedRootPassword
              randomSalt
              debugOutput
              ;
          };
          utils = {
            inherit execSh isNullOrWhitespace;
          };
        in
        nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs setup system;
            lib = nixpkgs.lib // utils;
          };
          modules = [
            "${hostRoot}/configuration.nix"
          ];
        };
    };
}
# {
#   devShells.${system}.default = pkgs.mkShell {
#     packages = with pkgs; [
#       git
#       nixfmt
#     ];
#     shellHook = ''
#     '';
#   };
# }
# //
