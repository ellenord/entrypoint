{ config, pkgs, ... }:

{
  services.hydra = {
    enable = true;

    port = 3000;

    hydraURL = "http://localhost:3000";

    extraConfig = ''
      <user>
        <username>admin</username>
        <password>admin</password>
        <email>ellenord.zelleratumm@gmail.org</email>
        <isadmin>1</isadmin>
      </user>
    '';
  };

  networking.firewall.allowedTCPPorts = [ 3000 ];
}
