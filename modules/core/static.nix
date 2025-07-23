{
  setup,
  lib,
  config,
  ...
}:
with setup;
let
  module = trace "loading system static configuration..." (
    {
      system.stateVersion = "25.05";
      services = {
        openssh.enable = true;
        # remove speech synthesis
        speechd.enable = lib.mkForce false;
      };
      # ------------------------------------------------------------------------------
      # nixpkgs.config — applies only during system builds via `nixos-rebuild`.
      # These settings affect how packages are evaluated and built *within the system*.
      # They do NOT apply to user-invoked commands like `nix run`, `nix shell`, or `nix build`.
      nixpkgs.config = {
        # Allow installing unfree packages system-wide (e.g., vscode, steam)
        allowUnfree = true;

        # NOTE: This option is not recognized in nixpkgs.config and has no effect here.
        # It can be removed — unsafe native code during evaluation is controlled elsewhere.
        allowUnsafeNativeCodeDuringEvaluation = true;
      };
      # ------------------------------------------------------------------------------
      # environment.variables — sets global environment variables for all user shells.
      # These affect interactive shell sessions and Nix commands like `nix run`, `nix develop`,
      # *if* they are run with `--impure` (required for environment variables to take effect in flakes).
      environment.variables = {
        # Allow unfree packages when running nix commands outside of system builds
        NIXPKGS_ALLOW_UNFREE = "1";

        # Enable experimental features and unsafe native code for user-invoked nix commands
        NIX_CONFIG = ''
          experimental-features = nix-command flakes
          allow-unsafe-native-code-during-evaluation = true
        '';
      };
      nix.settings = {
        # allow unsafe native code during evaluation, needed for impure configuration
        allow-unsafe-native-code-during-evaluation = true;
        trusted-users =
          [
            "root"
          ]
          ++ (
            if rootOnly then
              [ ]
            else
              [
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
    // trace "system static configuration loaded successfully!" { }
  );
in
module
