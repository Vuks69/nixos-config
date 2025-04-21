# Driver configuration. Nvidia/nouveau etc.

{ config, lib, pkgs, ... }:

{
  systemd.tmpfiles.rules = [
    "d /var/local/nginx/data 0755 nginx nginx"
    "d /var/local/nginx/letsencrypt 0755 nginx nginx"
  ];

  networking.firewall.allowedTCPPorts = [ 80 81 443 ];
  networking.firewall.allowedUDPPorts = [ 80 81 443 ];

  virtualisation.oci-containers.containers.nginxproxymanager = {
    image = "jc21/nginx-proxy-manager:latest";
    ports = [
      "80:80"
      "81:81"
      "443:443"
    ];
    extraOptions = [
      "--network=host"
    ];
    volumes = [
      "/var/local/nginx/data:/data"
      "/var/local/nginx/letsencrypt:/etc/letsencrypt"
    ];
  };
}
