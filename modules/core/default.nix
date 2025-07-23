{ setup, ... }:
with setup;
let
  module = trace "loading system core configuration..." (
    {
      imports = [
        "${flakeRoot}/modules/core/static.nix"
        "${flakeRoot}/modules/core/dynamic.nix"
      ];
    }
    // trace "system core configuration loaded successfully!" { }
  );
in
module
