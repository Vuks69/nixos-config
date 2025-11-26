{ lib, config, ... }:
with lib;
{
  options.zfs = {
    hostId = mkOption {
      type = types.str;
      description = "Host ID used for ZFS (wired into networking.hostId). Generate a unique id using `head -c 8 /etc/machine-id`";
    };
    extraPools = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Additional ZFS pools to import and scrub automatically.";
    };
  };

  # https://openzfs.github.io/openzfs-docs/Getting%20Started/NixOS/index.html#installation
  config = {
    boot.supportedFilesystems = [ "zfs" ];
    boot.zfs.forceImportRoot = false;
    networking.hostId = config.zfs.hostId;

    # Import pools on reboot
    boot.zfs.extraPools = config.zfs.extraPools;
    # Automatic scrubbing of the configured pools
    services.zfs.autoScrub.enable = true;
  };
}
