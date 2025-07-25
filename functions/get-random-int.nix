{
  pkgs,
  execSh,
  parseInt,
  ...
}:
_: parseInt "0x${toString (execSh "echo '\"'$(${pkgs.openssl}/bin/openssl rand -hex 8)'\"'")}"
