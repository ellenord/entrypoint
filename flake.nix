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
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        my-script = pkgs.writeShellApplication {
          name = "my-script";
          text = ''
            echo "Привет, Никита!"
            echo "Дата: $(date)"
          '';
        };
      in {
        devShells.default = pkgs.mkShell {
          packages = [pkgs.git pkgs.nixfmt my-script];
        };

        packages.my-script = my-script;
      }
    )
    // {
      nixosConfigurations.entrypoint = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/entrypoint/configuration.nix
          ./hosts/entrypoint/hardware-configuration.nix
          ./modules/ellenord.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.users.ellenord = import ./users/ellenord.nix;
          }
        ];
      };
    };
}
