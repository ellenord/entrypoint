{
  setup,
  lib,
  ...
}:
with setup; let
  module = lib.debug.traceSeq "loading system core configuration..." ({
      imports = [
        "${flakeRoot}/modules/core/static.nix"
        "${flakeRoot}/modules/core/dynamic.nix"
      ];
    }
    // lib.debug.traceSeq "system core configuration loaded successfully!" {});
in
  module
