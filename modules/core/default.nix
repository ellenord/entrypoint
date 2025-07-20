{setup, ...}:
with setup; {
  imports = [
    "${flakeRoot}/modules/core/static.nix"
    "${flakeRoot}/modules/core/dynamic.nix"
  ];
}
