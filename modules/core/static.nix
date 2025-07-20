{
  setup,
  lib,
  config,
  ...
}:
with setup; let
  module = lib.debug.traceSeq "loading system static configuration..." ({
      system.stateVersion = "25.05";
      services = {
        openssh.enable = true;
        # remove speech syntesis
        speechd.enable = lib.mkForce false;
      };
      nixpkgs.config = {
        allowUnfree = true;
        enableParallelenableParallelBuildingByDefault = true;
      };
      nix.settings = {
        # allow unsafe native code during evaluation, needed for impure configuration
        allow-unsafe-native-code-during-evaluation = true;
        trusted-users =
          [
            "root"
          ]
          ++ (
            if rootOnly
            then []
            else [
              "${username}"
            ]
          );
        system-features = [
          "nix-command"
          "flakes"
          "ca-derivations"
        ];
        experimental-features = [
          "nix-command"
          "flakes"
          "ca-derivations"
          "auto-allocate-uids"
          "configurable-impure-env"
          "git-hashing"
          "local-overlay-store"
          "pipe-operators"
          "read-only-local-store"
          "verified-fetches"
        ];
      };
    }
    // lib.debug.traceSeq "system static configuration loaded successfully!" {});
in
  module
