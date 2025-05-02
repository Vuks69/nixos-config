{ config, lib, pkgs, ... }:
let
  webUiPort = 53246;
  listenPort = 51212;
in
{
  # NOTE: in order for qbit to work with proxymanager, you need to
  #       first login to webui using localhost, and disable CSRF protection
  environment.systemPackages = with pkgs; [
    qbittorrent-nox
  ];

  systemd.services.qbittorrent = {
    enable = true;
    description = "qBittorrent client";
    after = [ "network-online.target" ];
    requires = [ "network-online.target" ];
    serviceConfig = {
      User = "qbittorrent";
      Group = "qbittorrent";
      WorkingDirectory = "/home/qbittorrent";
      ExecStart = "${pkgs.qbittorrent-nox}/bin/qbittorrent-nox --webui-port=${builtins.toString webUiPort} --confirm-legal-notice";
      Restart = "always";
      RestartSec = "30";
    };
  };

  networking.firewall.allowedTCPPorts = [ webUiPort listenPort ];
  networking.firewall.allowedUDPPorts = [ webUiPort listenPort ];
}
