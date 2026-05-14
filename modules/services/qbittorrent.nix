{ ... }:
let
  webUiPort = 53246;
  listenPort = 51212;
in
{
  # NOTE: in order for qbit to work with proxymanager, you need to
  #       first login to webui using localhost, and disable CSRF protection
  services.qbittorrent = {
    enable = true;
    webuiPort = webUiPort;
    torrentingPort = listenPort;
    openFirewall = true;
    extraArgs = [ "--confirm-legal-notice" ];
  };

  users.users.qbittorrent.extraGroups = [ "warehouse" ];
}
