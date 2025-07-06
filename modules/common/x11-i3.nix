{ pkgs, ... }:
{
  services.displayManager.ly = {
    enable = true;
  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        rofi
        i3status
        i3lock
      ];
    };
    excludePackages = with pkgs; [
      xterm
    ];
    xkb.layout = "pl";
  };

  services.displayManager.defaultSession = "none+i3";

  fonts = {
    packages = with pkgs; [
      nerd-fonts.fira-code
      nerd-fonts.noto
    ];
    fontconfig.defaultFonts = {
      monospace = [ "FiraCode Nerd Font Mono Ret" ];
      emoji = [ "Noto Color Emoji" ];
    };
  };
}