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

  outputs = {
    self,
    nixpkgs,
    home-manager,
    flake-utils,
    ...
  } @ inputs: let
    # pkgs = import nixpkgs {
    #   inherit system;
    # };
    execSh = expression: builtins.exec (["sh" "-c"] ++ expression);
    isNullOrWhitespace = str: builtins.match "^[ \t\r\n]*$" (toString str) != null;

    system = builtins.getEnv "CFG_SYSTEM";
    hostName = builtins.getEnv "CFG_HOSTNAME";
    flakeRoot = toString (execSh ["pwd"]);
    hostRoot = "${flakeRoot}/hosts/${hostName}";
    timezone = let
      val = builtins.getEnv "CFG_TIMEZONE";
    in
      if isNullOrWhitespace val
      then "UTC"
      else val;
  in
    assert !isNullOrWhitespace system || throw "CFG_SYSTEM environment variable must be set";
    assert !isNullOrWhitespace hostName || throw "CFG_HOSTNAME environment variable must be set"; {
      nixosConfigurations.${hostName} = let
        setup = {
          inherit system hostName flakeRoot hostRoot timezone;
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

