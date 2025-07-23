{
  lib,
  pkgs,
  execSh,
  ...
}:
password: salt:
toString (execSh "echo '\"'$(openssl passwd -6 -salt ${salt} '${password}')'\"'")
