{ ... }:

{
  services.jellyfin = {
    enable = true;
  };

  users.users.jellyfin.extraGroups = [ "warehouse" ];

  networking.firewall.allowedUDPPorts = [ 1900 7359 ];
}
