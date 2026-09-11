{ config, ... }:
let
  listenAddr = "58312";
in
{
  age.secrets.miniflux_admin_credentials.file = ../../secrets/miniflux/admin_credentials.age;

  services.miniflux = {
    enable = true;
    adminCredentialsFile = config.age.secrets.miniflux_admin_credentials.path;
    config = {
      LISTEN_ADDR = "127.0.0.1:${listenAddr}";
      POLLING_FREQUENCY = "30";
      POLLING_SCHEDULER = "entry_frequency";
    };
  };
}