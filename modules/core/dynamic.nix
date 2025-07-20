{
  setup,
  lib,
  config,
  ...
}:
with setup; let
  module = lib.debug.traceSeq "loading system dynamic configuration..." ({
      # may be needed for some packages to work
      security.rtkit.enable = true;
      # extend life of SSD, disable if on HDD
      services.fstrim.enable = true;
    }
    // lib.debug.traceSeq "system dynamic configuration loaded successfully!" {});
in
  module
