{ config, lib, pkgs, ... }:
let
  fileHostingPort = 58383;
  localWebsitePort = 58384;
  publicWebsitePort = 58384;
in
{
  services.nginx = {
    enable = true;
    virtualHosts."media.vuks69.duckdns.org" = {
      # basicAuthFile = "/var/www/.htpasswd";
      root = "/var/www/media/";
      listen = [
        {
          addr = "127.0.0.1";
          port = fileHostingPort;
        }
      ];
      locations."/" = {};
    };
    virtualHosts."site.vuks-den.duckdns.org" = {
      root = "/var/www/staging/";
      listen = [
        {
          addr = "127.0.0.1";
          port = localWebsitePort;
        }
      ];
      locations."/" = {
      };
    };

    virtualHosts."vuks.dev" = {
      root = "/var/www/website/";
      listen = [
        {
          addr = "127.0.0.1";
          port = publicWebsitePort;
        }
      ];
      locations."/" = {};
    };
    virtualHosts."media.vuks.dev" = {
      root = "/var/www/media/";
      listen = [
        {
          addr = "127.0.0.1";
          port = fileHostingPort;
        }
      ];
      locations."/" = {};
    };
  };
}
