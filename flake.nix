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

      lib = nixpkgs.lib;
      system = builtins.getEnv "CFG_SYSTEM";
      pkgs = import nixpkgs {
        inherit system;
      };

      loadFunction =
        name:
        import "${flakeRoot}/functions/${name}.nix" {
          inherit lib;
          inherit execSh;
          inherit pkgs;
        };

      isNullOrWhitespace = str: builtins.match "^[ \t\r\n]*$" (toString str) != null;

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

      randomSeed = builtins.getEnv "CFG_RANDOM_SEED";

      trace = lib.debug.traceSeq;

      mkForce = lib.mkForce;
      mkAfter = lib.mkAfter;
      mkBefore = lib.mkBefore;
      mkDefault = lib.mkDefault;
      mapAttrs = lib.mapAttrs;

      randomSalt = loadFunction "random-salt" randomSeed;

      userPassword = builtins.getEnv "CFG_USER_PASSWORD";
      rootPassword = builtins.getEnv "CFG_ROOT_PASSWORD";

      hashedPassword = loadFunction "hashed-password" randomSalt;
      hashedUserPassword = hashedPassword userPassword;
      hashedRootPassword = hashedPassword rootPassword;

      hostRoot = "${flakeRoot}/hosts/${hostName}";
    in
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
