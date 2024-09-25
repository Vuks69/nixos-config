# There are some things that need to be done outside of configfiles, such as setting passwords.
# ONETIME: actions that have to be done once, when defining the
#          given service or functionality for the first time
# ALWAYS:  actions that have to be done on every rebuild

{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix # Include the results of the hardware scan.
      ./system.nix
      ./nvidia.nix
      ./zfs.nix
      ./samba.nix
      ./ups.nix
    ];

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;

    displayManager.lightdm = {
      enable = true;
      greeter.enable = true;
    };

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
      (nerdfonts.override { fonts = [ "FiraCode" "Noto" ]; })
    ];
    fontconfig.defaultFonts = {
      monospace = [ "FiraCode Nerd Font Mono Ret" ];
      emoji = [ "Noto Color Emoji" ];
    };
  };

  # ONETIME(PER_USER): Set a password with ‘passwd’ if login needed
  users = {
    groups.smb-users = { };
    groups.upsmon = { };
    users = {
      vuks = {
        isNormalUser = true;
        shell = pkgs.bash;
        extraGroups = [
          "wheel"
          "smb-users"
        ];
      };
      anna = {
        isSystemUser = true;
        group = "smb-users";
      };
      smb-guest = {
        isSystemUser = true;
        group = "smb-users";
        description = "SMB share guest user account";
      };
      upsmon = {
        isSystemUser = true;
        # ONETIME: store this user's password in home (plaintext)
        #          this is needed for providing the password to UPS monitoring - see ups.nix
        home = "/home/upsmon";
        createHome = true;
        group = "upsmon";
        description = "UPS monitoring technical user";
      };
    };
  };

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    vscode
    tig
    gh

    kitty
    nixpkgs-fmt
    nil
    gnumake

    bc
    btop
    screen
    file
    wget
    curl
    lm_sensors
    lxqt.lxqt-policykit
  ];
  environment.variables = {
    TERMINAL = "kitty";
    EDITOR = "nano";
  };

  # Some programs need SUID wrappers, can be configured further or are started in user sessions.
  # programs.mtr.enable = true;
  programs = {
    git.enable = true;
    starship.enable = true;
    firefox.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryPackage = pkgs.pinentry-gtk2;
    };
  };

  # List services that you want to enable:
  services = {
    cron.enable = true;
    openssh = {
      enable = true;
      settings.PasswordAuthentication = true;
      openFirewall = true;
    };
    xrdp = {
      enable = true;
      defaultWindowManager = "i3";
      openFirewall = true;
    };
  };

  security.polkit.enable = true;

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

