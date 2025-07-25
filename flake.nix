{
  description = "A highly impure and deliberately unorthodox flake template, wired for external, imperative configuration and full experimental chaos.";

  inputs = {
    # We're using the unstable channel because we plan to use bleeding-edge
    # and experimental features that require the latest Nixpkgs.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    imperativeNix.url = "github:ellenord/imperative-nix";
  };

  outputs =
    {
      self,
      imperativeNix,
      ...
    }@inputs:
    let

      nixpkgs = inputs.nixpkgs;

      system = builtins.getEnv "NIXOS_SYSTEM";

      lib = nixpkgs.lib;

      configuration =
        with imperativeNix.lib.${system};
        let

          # functionsDir = "${flakeRoot}/functions";
          # functionsFiles = builtins.readDir functionsDir;
          flakeRoot = toString (execSh "pwd");

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

          debugOutput = "";

          # debugOutput = "\n\n\n${
          #   let
          #     gen = i: "${toString (getRandomInt { })}";
          #     results = builtins.genList gen 100;
          #   in
          #   lib.concatStringsSep " " results
          # }\n\n\n";

          # debugOutput = "%%%###\n\n${lib.concatStringsSep "\n" (builtins.attrNames "x86_64-linux")}\n\n";
          # debugOutput = "%%%###\n\n${toString (imperativeNix.parseInt "-12345")}\n\n";

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
            breakpoint
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
              breakpoint
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
