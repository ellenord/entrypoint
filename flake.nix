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
    flakeRoot = builtins.toString (execSh "pwd");
    my-script = pkgs.writeShellApplication {
      name = "my-script";
      text = ''
        echo "Привет, Никита!"
        echo "Дата: $(date)"
      '';
    };
  in
    {
      devShells.default = pkgs.mkShell {
        packages = [pkgs.git pkgs.nixfmt my-script];
      };

      packages.my-script = my-script;
    }
    // {
      nixosConfigurations.entrypoint = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit flakeRoot execSh inputs system;
        };
        modules = builtins.trace "${flakeRoot}" [
          ./hosts/entrypoint/configuration.nix
        ];
      };
    };
}
