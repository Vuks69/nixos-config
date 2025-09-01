# ZFS configuration
{ hostId, extraPools, ... }:

{
  # https://openzfs.github.io/openzfs-docs/Getting%20Started/NixOS/index.html#installation
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false;
  networking.hostId = hostId;

  # Import pools on reboot
  boot.zfs.extraPools = extraPools;

  # Automatic scrubbing
  services.zfs.autoScrub.enable = true;
}
