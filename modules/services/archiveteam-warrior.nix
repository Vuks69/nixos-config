{ ... }:
let
  webUiPort = 58537;
in
{
  virtualisation.podman = {
    enable = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  virtualisation.oci-containers.containers = {
    archiveteam-warrior = {
      image = "atdr.meo.ws/archiveteam/warrior-dockerfile";
      pull = "newer";
      volumes = [ "archiveteam-warrior-projects:/home/warrior/projects" ];
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      ports = [
        "127.0.0.1:${toString webUiPort}:8001"
      ];
      autoStart = true;
    };
  };
}
