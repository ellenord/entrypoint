export NIX_CONFIG=$'experimental-features = nix-command flakes\nallow-unsafe-native-code-during-evaluation = true'
export NIXPKGS_ALLOW_UNFREE=1

set -a
source ./setup.env
set +a

export NIXOS_SYSTEM="x86_64-linux"