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
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
    execSh = expression: builtins.exec ["sh" "-c" expression];
    flakeRoot = toString (execSh "pwd");
  in
    {
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          git
          nixfmt
        ];
      };
    }
    // {
      nixosConfigurations.entrypoint = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit flakeRoot execSh inputs system;
        };
        modules = [
          ./hosts/entrypoint/configuration.nix
        ];
      };
    };
}
