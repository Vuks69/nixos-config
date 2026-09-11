{ phrack-rss, ... }:
let
  port = 58315;
  dataDir = "/var/lib/phrack-rss";
in
{
  # Feeds for miniflux:
  #   http://127.0.0.1:${toString port}/feed.xml   (RSS)
  #   http://127.0.0.1:${toString port}/feed.atom  (Atom)
  systemd.services.phrack-rss = {
    description = "phrack.org RSS/Atom feed generator";
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      ExecStart = "${phrack-rss}/bin/phrack-rss serve";
      Environment = [
        "PHRACK_RSS_DATA_DIR=${dataDir}"
        "PHRACK_RSS_LISTEN=127.0.0.1"
        "PHRACK_RSS_PORT=${toString port}"
        "PHRACK_RSS_INTERVAL=24h"
        "PHRACK_RSS_FEED_LENGTH=40"
      ];
      StateDirectory = "phrack-rss";
      Restart = "on-failure";
      DynamicUser = true;
    };
  };
}