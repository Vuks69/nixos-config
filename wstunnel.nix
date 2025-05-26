{ ... }:
let
  wstunnelPort = 63514;
  wireguardPort = 63013;
in
{
  services.wstunnel = {
    enable = true;
    servers.van-wireguard = {
      loggingLevel = "info";
      enable = true;
      listen.host = "0.0.0.0";
      listen.port = wstunnelPort;
      enableHTTPS = false;
      restrictTo = [
        {
          host = "0.0.0.0";
          port = wireguardPort;
        }
      ];
      # environmentFile = "/etc/wstunnel/password";
    };
  };
  networking.firewall.allowedTCPPorts = [ wstunnelPort ];
  networking.firewall.allowedUDPPorts = [ wstunnelPort ];
}
