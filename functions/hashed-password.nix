{
  pkgs,
  execSh,
  ...
}:
salt: password:
toString (
  execSh "echo '\"'$(${pkgs.openssl}/bin/openssl passwd -6 -salt ${salt} '${password}')'\"'"
)
