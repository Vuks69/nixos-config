{ ... }:
let
  # ONETIME
  # sudo nix-channel --add https://nixos.org/channels/nixos-unstable nixos-unstable
  # sudo nix-channel --update
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in
{
  # ONETIME
  # create the following files and store the API keys in them
  #   echo -n "API_KEY" >/etc/ddns/service.secretType
  #   chmod 600 /etc/ddns/*
  services.ddclient = {
    enable = true;
    # Need to use the unstable version of ddclient, because porkbun changed their API endpoint
    # and the stable version of ddclient is not updated yet
    package = unstable.ddclient;
    usev6 = "no";
    extraConfig = ''
      # porkbun
      # protocol=porkbun
      # apikey=${builtins.readFile /etc/ddns/porkbun.apiKey}
      # secretapikey=${builtins.readFile /etc/ddns/porkbun.secretApiKey}
      # vuks.dev

      # duckdns
      protocol=duckdns
      password=${builtins.readFile /etc/ddns/duckdns.token}
      vuks69
    '';
  };
}
