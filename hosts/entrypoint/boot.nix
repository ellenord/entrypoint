{
  config,
  setup,
  ...
}:
with setup; let
  module = trace "loading system boot configuration..." ({
      boot = {
        kernelParams = [
          "console=ttyS0,115200"
          "quiet"
        ];
        loader.grub = {
          enable = true;
          efiSupport = true;
          efiInstallAsRemovable = true;
          device = "nodev";
          useOSProber = false;
          configurationLimit = 8;
          extraConfig = ''
            serial --unit=0 --speed=115200
            terminal_input serial
            terminal_output serial
          '';
        };
      };
    }
    // trace "system boot configuration loaded successfully!" {});
in
  module
