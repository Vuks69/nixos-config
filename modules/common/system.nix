# Mostly low-level system configuration that won't have to be touched often if at all.

{ ... }:

{
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable zram swap
  zramSwap.enable = true;

  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.
  networking.nameservers = [ "9.9.9.9" "1.1.1.1" "4.4.4.4" "8.8.8.8" ]; # Use Quad9, Cloudflare, and Google DNS servers.
  networking.dhcpcd.extraConfig = ''
    nohook resolv.conf
  '';

  # Set your time zone.
  time.timeZone = "Europe/Warsaw";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    # keyMap = "pl";
    useXkbConfig = true; # use xkb.options in tty.
  };

  # Allow installing proprietary crap
  nixpkgs.config.allowUnfree = true;
}
