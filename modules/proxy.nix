{ pkgs, ... }:

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

      auth_param basic program ${pkgs.squid}/libexec/basic_ncsa_auth /etc/squid/passwd
      auth_param basic realm NixProxy
      acl authenticated proxy_auth REQUIRED
      http_access allow authenticated
      http_access deny all

      acl localnet src all
    '';
  };

  networking.firewall.allowedTCPPorts = [ 3128 ];

  environment.etc."squid/passwd".source = "/etc/nixos/squid.passwd";
}
