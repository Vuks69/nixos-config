{ ... }:
let
  quasselPort = 64242;
in
{
  services.quassel = {
    enable = true;
    interfaces = [ "0.0.0.0" ];
    portNumber = quasselPort;
  };

  networking.firewall.allowedTCPPorts = [ quasselPort ];
}
