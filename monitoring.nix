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

  services.smartd = {
    # Self note: the USB drive is not supported by smartd - shuck it asap
    enable = true;
    extraOptions = [
      "-A /var/log/smartd/"
      "--interval=3600"
    ];
    # Short tests every 7 days, long tests every month
    defaults.monitored = "-a -n standby,10,q -o on -s (S/../../7/02|L/../01/./04) -m vuks";
  };
}
