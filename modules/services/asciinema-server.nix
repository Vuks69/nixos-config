{ ... }:
let
  webUiPort = 58923;
  localPort = 4000;
  adminPort = 4002;
in
{
  virtualisation.podman = {
    enable = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  virtualisation.oci-containers.containers = {
    asciinema = {
      image = "ghcr.io/asciinema/asciinema-server:latest";
      pull = "newer";
      volumes = [ "/var/lib/asciinema:/var/lib/asciinema" ];
      environment = {
        URL_HOST = "asciinema.vuks.dev";
        URL_PORT = "80";
        URL_SCHEME = "http";
        SIGN_UP_DISABLED = "true";
      };
      ports = [
        "127.0.0.1:${builtins.toString webUiPort}:4000"
        "${builtins.toString localPort}:4000"
        "${builtins.toString adminPort}:4002"
      ];
      dependsOn = [ "postgres" ];
      autoStart = true;
    };

    postgres = {
      image = "docker.io/library/postgres:14";
      volumes = [ "postgres_data:/var/lib/postgresql/data" ];
      environment = {
        POSTGRES_HOST_AUTH_METHOD = "trust";
      };
      podman.sdnotify = "healthy";
      extraOptions = [
        "--health-cmd"
        (builtins.toJSON [ "pg_isready" "-U" "postgres" ])
        "--health-interval=30s"
        "--health-timeout=10s"
        "--health-start-period=10s"
        "--health-retries=3"
      ];
    };
  };
}
