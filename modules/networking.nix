{
  setup,
  lib,
  config,
  ...
}:
with setup; let
  module = trace "loading system networking configuration..." ({
      networking = {
        hostName = mkForce hostName;
        hostId = mkDefault (
          let
            val = builtins.substring 0 8 (builtins.hashString "md5" randomSeed);
          in
            trace "(!!!)\tgenerated hostId >>> ${val}" val
        );
        networkmanager.enable = mkDefault true;
        firewall.enable = mkDefault true;
        nameservers = mkDefault [
          "1.1.1.1"
          "8.8.8.8"
          "9.9.9.9"
        ];
        proxy.noProxy = mkDefault "127.0.0.1,localhost,internal.domain";
      };
    }
    // trace "system networking configuration loaded successfully!" {});
in
  module
