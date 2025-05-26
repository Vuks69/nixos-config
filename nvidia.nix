# Driver configuration. Nvidia/nouveau etc.

{ ... }:

{
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true; # required
    open = false; # open drivers are kind of a beta
    nvidiaSettings = true;
    powerManagement.enable = true;
  };
}
