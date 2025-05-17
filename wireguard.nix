{ config, lib, pkgs, ... }:
let
  # reused variables
  serverIPs = [ "10.0.0.1/24" ];
  vpnNetwork = "10.0.0.0/24";
  listenPort = 63013;
  wgExtInterface = "enp3s0";
  wgInterface = "wg0";
in
{
  # https://wiki.nixos.org/wiki/WireGuard
  networking = {
    # enable NAT
    nat = {
      enable = true;
      externalInterface = wgExtInterface;
      internalInterfaces = [ wgInterface ];
    };
    firewall.allowedUDPPorts = [ listenPort ];

    wireguard = {
      enable = true;
      interfaces = {
        # same as in internalInterfaces
        wg0 = {
          # Determines the IP address and subnet of the server's end of the tunnel interface.
          ips = serverIPs;
          # The port that WireGuard listens to. Must be accessible by the client.
          listenPort = listenPort;

          # This allows the wireguard server to route your traffic to the internet and hence be like a VPN
          # For this to work you have to set the dnsserver IP of your router (or dnsserver of choice) in your clients
          postSetup = ''
            ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s ${vpnNetwork} -o ${wgExtInterface} -j MASQUERADE
          '';

          postShutdown = ''
            ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s ${vpnNetwork} -o ${wgExtInterface} -j MASQUERADE
          '';

          privateKeyFile = "/etc/wireguard/server.key";

          peers = [
            {
              # robocop
              # Public key of the peer (not a file path).
              publicKey = "5m2lHTmBS9TxUG7IkhRAoXLfKd9CkfVbgB32dYbPcm0=";
              # List of IPs assigned to this peer within the tunnel subnet. Used to configure routing.
              allowedIPs = [ "10.0.0.2/32" ];
            }
            {
              # phone
              publicKey = "MMZ2Ww8g5g7EoqDrk28wR9aLPhsMdSa6W0SAv5bL0nQ=";
              allowedIPs = [ "10.0.0.3/32" ];
            }
            {
              # v-guest
              publicKey = "oL3qzHsMQPWK9ezDAoKyBC6bUC+HtCPbcH3cYFcx+h8=";
              allowedIPs = [ "10.0.0.128/32" ];
            }
          ];
        };
      };
    };
  };
}
