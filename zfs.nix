# ZFS configuration
{ config, ... }:

{
  # https://openzfs.github.io/openzfs-docs/Getting%20Started/NixOS/index.html#installation
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false;
  networking.hostId = "39ace0d9";

  # Import pools on reboot
  boot.zfs.extraPools = [ "storage-k" ];

  # Automatic scrubbing
  services.zfs.autoScrub.enable = true;
}
