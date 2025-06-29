{ pkgs, ... }:
let
  zabbixServerListenPort = 10051;
  zabbixWebPort = 13451;
in
{
  services.netdata = {
    enable = true;
    package = pkgs.netdata.override { withCloudUi = true; };
    config = {
      db = {
        "mode" = "dbengine";
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 19999 ];

  services.zabbixServer = {
    enable = true;
    settings = {
      CacheSize = "1G";
    };
    listen.port = zabbixServerListenPort;
    openFirewall = true;
  };

  # For Windows hosts, you need to manually open the firewall ports for Zabbix:
  # netsh advfirewall firewall add rule name="Open Zabbix agentd port 10050 inbound" dir=in action=allow protocol=TCP localport=10050
  # netsh advfirewall firewall add rule name="Open Zabbix agentd port 10050 outbound" dir=out action=allow protocol=TCP localport=10050
  # netsh advfirewall firewall add rule name="Open Zabbix trapper port 10051 inbound" dir=in action=allow protocol=TCP localport=10051
  # netsh advfirewall firewall add rule name="Open Zabbix trapper port 10051 outbound" dir=out action=allow protocol=TCP localport=10051
  services.zabbixAgent = {
    enable = true;
    server = "127.0.0.1";
  };

  services.zabbixWeb = {
    enable = true;
    hostname = "zabbix.vuks-den.duckdns.org";
    server = {
      address = "127.0.0.1";
      port = zabbixServerListenPort;
    };
    frontend = "nginx";
    nginx.virtualHost = {
      listen = [
        {
          addr = "127.0.0.1";
          port = zabbixWebPort;
        }
      ];
    };
  };

  # Zabbix does not support PHP 8.4 yet, so we force 8.3
  services.phpfpm.phpPackage = pkgs.php83;

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
