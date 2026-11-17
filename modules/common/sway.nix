{ pkgs, ... }:
{
  services.displayManager.ly = {
    enable = true;
  };

  programs = {
    sway.enable = true;
    waybar.enable = true;
  };

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
