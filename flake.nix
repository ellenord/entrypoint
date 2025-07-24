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

          trace = lib.debug.traceSeq;

          mkForce = lib.mkForce;
          mkAfter = lib.mkAfter;
          mkBefore = lib.mkBefore;
          mkDefault = lib.mkDefault;
          mapAttrs = lib.mapAttrs;

          # _ = builtins.abort (tryParseHex "-0x1f");
          debugOutput = debug (
            trace {
              # ✅ valid hex with 0x prefix
              "0x1f" = tryParseHex "0x1f";
              "0x0" = tryParseHex "0x0";
              "0xdeadbeef" = tryParseHex "0xdeadbeef";
              "0xABCDEF" = tryParseHex "0xABCDEF";

              # ✅ valid hex without prefix
              "FF" = tryParseHex "FF";
              "deadbeef" = tryParseHex "deadbeef";
              "abcdef" = tryParseHex "abcdef";

              # ✅ valid with unary plus
              "+0x1A" = tryParseHex "+0x1A";
              "+FF" = tryParseHex "+FF";
              "+deadbeef" = tryParseHex "+deadbeef";

              # ✅ valid negative hex
              "-0x2A" = tryParseHex "-0x2A";
              "-deadbeef" = tryParseHex "-deadbeef";

              # ❌ invalid hex with non-hex chars
              "0x1g" = tryParseHex "0x1g";
              "xyz" = tryParseHex "xyz";
              "0x12Z" = tryParseHex "0x12Z";

              # ❌ empty or malformed
              "" = tryParseHex "";
              "0x" = tryParseHex "0x";
              "-" = tryParseHex "-";
              "0x-" = tryParseHex "0x-";
              "+" = tryParseHex "+";
              "++deadbeef" = tryParseHex "++deadbeef";
              "+-deadbeef" = tryParseHex "+-deadbeef";

              # ❌ spaces in wrong places
              " -0x123" = tryParseHex " -0x123";
              "0x 123" = tryParseHex "0x 123";
              "   -  0x123  " = tryParseHex "   -  0x123  ";

              # ✅ extra whitespace, but otherwise valid
              " 0x1f " = tryParseHex " 0x1f ";
              " \tdeadbeef\n" = tryParseHex " \tdeadbeef\n";
              " +0x1f " = tryParseHex " +0x1f ";
            } "hex parser test suite"
          );

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
            ;
        };
    in
    with configuration;
    assert !isNullOrWhitespace system || throw "CFG_SYSTEM environment variable must be set";
    assert !isNullOrWhitespace hostName || throw "CFG_HOSTNAME environment variable must be set";
    assert !isNullOrWhitespace randomSeed || throw "CFG_RANDOM_SEED environment variable must be set";
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
