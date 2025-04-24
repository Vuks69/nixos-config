{ config, lib, pkgs, ... }:
{
  services.jellyfin = {
    enable = true;
  };

  networking.firewall.allowedUDPPorts = [ 1900 7359 ];
}
