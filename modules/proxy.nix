{ pkgs, ... }:

let
  passwdFile = "/etc/nixos/squid.passwd";
  authHelper = "${pkgs.squid}/libexec/squid/basic_ncsa_auth"; 
in
{
  environment.systemPackages = with pkgs; [
    squid
    openssl   
  ];

  services.squid = {
    enable = true;
    extraConfig = ''
      http_port 3128
      visible_hostname proxy.local

      auth_param basic program ${authHelper} ${passwdFile}
      auth_param basic realm NixProxy
      acl authenticated proxy_auth REQUIRED
      http_access allow authenticated
      http_access deny all

      acl localnet src all
    '';
  };

  environment.etc."squid/passwd".source = passwdFile;

  networking.firewall.allowedTCPPorts = [ 3128 ];
}
