{
  setup,
  lib,
  utils,
  pkgs,
  config,
  inputs,
  ...
}: {
  # may be needed for some packages to work
  security.rtkit.enable = true;
  # extend life of SSD, disable if on HDD
  services.fstrim.enable = true;
}
