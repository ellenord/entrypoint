{
  lib,
  config,
  setup,
  ...
}:
with setup; let
  module = lib.debug.traceSeq "loading system locale configuration..." ({
      i18n = {
        defaultLocale = "${locale}";
        extraLocaleSettings = {
          LC_TIME = "${locale}";
          LC_MONETARY = "${locale}";
          LC_PAPER = "${locale}";
          LC_MEASUREMENT = "${locale}";
          LC_NUMERIC = "${locale}";
          LC_ALL = "${locale}";
        };
      };
    }
    // lib.debug.traceSeq "system locale configuration loaded successfully!" {});
in
  module
