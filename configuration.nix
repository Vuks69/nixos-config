# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix # Include the results of the hardware scan.
      ./system.nix
      ./nvidia.nix
    ];

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;

    displayManager.lightdm = {
      enable = true;
      greeter.enable = true;
    };

    windowManager.i3.enable = true;

    # Configure keymap in X11
    xkb.layout = "pl";
    # services.xserver.xkb.options = "eurosign:e,caps:escape";
  };

  services.displayManager.defaultSession = "none+i3";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # hardware.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.vuks = {
    isNormalUser = true;
    shell = pkgs.bash;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    # packages = with pkgs; [
    # ];
  };

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    firefox
    vscode
    git
    nnn
    fzf
    kitty
    nixpkgs-fmt
    nil
    gnumake

    tree
    file
    wget
    curl
    lm_sensors
    openssh
    lxqt.lxqt-policykit
  ];

  # Some programs need SUID wrappers, can be configured further or are started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
    openFirewall = true;
  };

  services.xrdp = {
    enable = true;
    defaultWindowManager = "i3";
    openFirewall = true;
  };

  security.polkit.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ 22 ];
  # networking.firewall.allowedUDPPorts = [ 22 ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # ====================================
  # No touching below this line.
  # Copy the NixOS configuration file and link it from the resulting system (/run/current-system/configuration.nix).
  # This is useful in case you accidentally delete configuration.nix.
  system.copySystemConfiguration = true;
  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?
}

