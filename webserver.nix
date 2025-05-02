{ config, lib, pkgs, ... }:
let
  fileHostingPort = 58383;
in
{
  services.nginx = {
    enable = true;
    virtualHosts."media.vuks69.duckdns.org" = {
      # basicAuthFile = "/var/www/.htpasswd";
      root = "/var/www/media/";
      extraConfig = ''
        autoindex on;
      '';
      listen = [
        {
          addr = "127.0.0.1";
          port = fileHostingPort;
        }
      ];
      locations."/" = {
        extraConfig = ''
          autoindex on;
        '';
      };
    };
  };
}
