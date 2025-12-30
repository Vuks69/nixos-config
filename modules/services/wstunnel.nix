{ ... }:
let
  wstunnelPort = 63514;
  wireguardPort = 63013;
in
{
  services.wstunnel = {
    enable = true;
    servers.van-wireguard = {
      enable = true;
      listen = {
        host = "0.0.0.0";
        port = wstunnelPort;
        enableHTTPS = false;
      };
      settings.restrict-to = [
        {
          host = "0.0.0.0";
          port = wireguardPort;
        }
      ];
    };
  };
  networking.firewall.allowedTCPPorts = [ wstunnelPort ];
  networking.firewall.allowedUDPPorts = [ wstunnelPort ];
}
