{
  lib,
  pkgs,
  execSh,
  flakeRoot,
  ...
}:
let
  loadFunction =
    name:
    import "${flakeRoot}/functions/${name}.nix" {
      inherit lib;
      inherit execSh;
      inherit pkgs;
    };
in
{
  inherit loadFunction;
  isNullOrWhitespace = loadFunction "is-null-or-whitespace";
  debugOutput = loadFunction "debug-output";
  getEnv = loadFunction "get-env";
  randomSalt = loadFunction "random-salt";
  hashedPassword = loadFunction "hashed-password";
}
