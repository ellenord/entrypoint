{
  setup,
  lib,
  config,
  ...
}:
with setup; {
  system.stateVersion = "25.05";
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
  services = {
    openssh.enable = true;
    # remove speech syntesis
    speechd.enable = lib.mkForce false;
  };
  nixpkgs.config = {
    allowUnfree = true;
    enableParallelenableParallelBuildingByDefault = true;
  };
}
