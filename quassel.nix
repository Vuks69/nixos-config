{ config, lib, pkgs, ... }:

{
  services.quassel = {
    enable = true;
    interfaces = [ "0.0.0.0" ];
    portNumber = 64242;
  };

  networking.firewall.allowedTCPPorts = [ 64242 ];
}