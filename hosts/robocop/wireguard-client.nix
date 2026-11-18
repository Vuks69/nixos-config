{ config, pkgs, ... }:
let
  # phoenix is the server; robocop is a client. See ../../modules/services/wireguard-server.nix
  # for how phoenix registers this peer.
  serverEndpoint = "vuks.dev:63013"; # host:port of the listening server
  serverPublicKey = "7BSnhU3Z2/QzTxSP3BevBeitwA5rZRKlW8LwDVNvaCM="; # phoenix's key; must match its wg0
  clientTunnelIP = "10.0.0.2/32"; # /32 scopes robocop's route to itself, matching the /32 the server already allows for this peer.
  vpnNetwork = "10.0.0.0/24";
  privateKeyFile = "/etc/wireguard/robocop.key";
in
{
  networking = {
    wireguard = {
      enable = true;
      interfaces = {
        wg0 = {
          ips = [ clientTunnelIP ];
          privateKeyFile = privateKeyFile;
          peers = [
            {
              # The peer robocop connects to.
              publicKey = serverPublicKey;

              # Route the tunnel subnet through phoenix. Use 0.0.0.0/0 for all traffic.
              allowedIPs = [ vpnNetwork ];

              # Endpoint address. NixOS installs a direct route to it, so the
              # tunnel isn't used to reach itself.
              endpoint = serverEndpoint;

              # Keep the NAT mapping alive so phoenix can still push traffic
              # back into this tunnel.
              persistentKeepalive = 25;
            }
          ];
        };
      };
    };

    # The client only initiates the flow, so replies come back via conntrack and no
    # inbound UDP port is needed. If rpfilter ever drops return traffic once the
    # tunnel is up, set networking.firewall.checkReversePath = "loose".
  };

  # wg / wg-quick / wg genkey, for when the tunnel needs debugging.
  environment.systemPackages = [ pkgs.wireguard-tools ];
}
