{ config, lib, pkgs, ... }:

{
  services.netdata = {
    enable = true;
    config = {
      db = {
        "mode" = "dbengine";
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 19999 ];
}
