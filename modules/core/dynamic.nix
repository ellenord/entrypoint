{
  setup,
  config,
  lib,
  ...
}:
with setup; let
  module = trace "loading system dynamic configuration..." ({
      security.rtkit.enable = lib.mkForce rtkitEnabled;
      services.fstrim.enable = lib.mkForce fstrimEnabled;
    }
    // trace "system dynamic configuration loaded successfully!" {});
in
  module
