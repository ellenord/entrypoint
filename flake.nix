{
  description = "extra cool nixos configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      flake-utils,
      ...
    }@inputs:
    let
      lib = nixpkgs.lib;
      system = builtins.getEnv "CFG_SYSTEM";
      pkgs = import nixpkgs {
        inherit system;
      };
      execSh =
        expression:
        builtins.exec ([
          "sh"
          "-c"
          expression
        ]);
      flakeRoot = toString (execSh "pwd");

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

      hashedPasssword = loadFunction "hashed-password";
      hashedUserPassword = hashedPasssword userPassword randomSalt;
      hashedRootPassword = hashedPasssword rootPassword randomSalt;
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
