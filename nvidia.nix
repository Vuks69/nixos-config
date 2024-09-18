# Driver configuration. Nvidia/nouveau etc.

{ config, lib, pkgs, ... }:

{
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true; # required
    open = false; # open drivers are kind of a beta
    nvidiaSettings = true;

    powerManagement = {
      enable = false; # playing it safe for now
      finegrained = false;
    };
  };
}
