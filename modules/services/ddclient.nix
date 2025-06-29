{ config, ... }:
{
  age.secrets.ddns-duckdns.file = ../../secrets/ddns/duckdns.token.age;

  # ONETIME
  # create the following files and store the API keys in them
  #   echo -n "API_KEY" >/etc/ddns/service.secretType
  #   chmod 600 /etc/ddns/*
  services.ddclient = {
    enable = true;
    usev6 = "no";
    extraConfig = ''
      # duckdns
      protocol=duckdns
      password=${builtins.readFile config.age.secrets.ddns-duckdns.file}
      vuks69
    '';
  };
}
