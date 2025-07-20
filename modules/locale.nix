{
  lib,
  config,
  setup,
  ...
}:
with setup; let
  module = trace "loading system locale configuration..." ({
      time.timeZone = mkForce "${timezone}";
      i18n.defaultLocale = mkForce "${locale}";
      i18n.extraLocaleSettings = mkAfter (mapAttrs (_: val: mkDefault val) {
        LC_TIME = locale;
        LC_MONETARY = locale;
        LC_PAPER = locale;
        LC_MEASUREMENT = locale;
        LC_NUMERIC = locale;
        LC_ALL = locale;
      });
    }
    // trace "system locale configuration loaded successfully!" {});
in
  module
