{ ... }:
let
  fileHostingPort = 58383;
  localWebsitePort = 58384;
  publicWebsitePort = 58384;
in
{
  services.nginx = {
    enable = true;
    commonHttpConfig = ''
      real_ip_header CF-Connecting-IP;
      set_real_ip_from "127.0.0.1";
      real_ip_recursive on;

      log_format proxy '$remote_addr | $remote_user [$time_local] '
                    '"$request" $status $body_bytes_sent '
                    '"$http_referer" "$http_user_agent"';
      access_log /var/log/nginx/access.log proxy;
    '';
    virtualHosts = {
      # Production
      "vuks.dev" = {
        root = "/var/www/website/";
        listen = [
          {
            addr = "127.0.0.1";
            port = publicWebsitePort;
          }
        ];
        locations."/" = { };
      };
      "media.vuks.dev" = {
        root = "/var/www/media/";
        listen = [
          {
            addr = "127.0.0.1";
            port = fileHostingPort;
          }
        ];
        locations."/" = { };
      };

      # Staging
      "local.vuks.dev" = {
        root = "/var/www/staging/";
        listen = [
          {
            addr = "127.0.0.1";
            port = localWebsitePort;
          }
        ];
        locations."/" = { };
      };
      "media.local.vuks.dev" = {
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
        locations."/" = { };
      };
    };
  };

  users.users.nginx.extraGroups = [ "www" ];
}
