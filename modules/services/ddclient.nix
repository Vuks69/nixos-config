{ config, ... }:
{
  age.secrets.ddns-duckdns.file = ../../secrets/ddns/duckdns.token.age;

  services.ddclient = {
    enable = true;
    usev6 = "no";
    passwordFile = config.age.secrets.ddns-duckdns.path;
    extraConfig = ''
      # duckdns
      protocol=duckdns
      password=@password_placeholder@
      vuks69
    '';
  };
}
