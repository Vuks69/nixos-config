# There are some things that need to be done outside of configfiles, such as setting passwords.
# ONETIME: actions that have to be done once, when defining the
#          given service or functionality for the first time
# ALWAYS:  actions that have to be done on every rebuild

{ config, pkgs, nixos-unstable, nixpkgs-unstable, ... }:
{
  imports = [
    # System configurations
    ./hardware-configuration.nix
    ../../modules/common/system.nix
    ../../modules/common/x11-i3.nix
    ../../modules/hardware/nvidia.nix
    # ../modules/services/ups.nix # UPS broke
    (import ../../modules/services/zfs.nix {
      hostId = "39ace0d9";
      extraPools = [ "tank" ];
    })

    # Services
    ../../modules/services/ddclient.nix
    ../../modules/services/factorio.nix
    ../../modules/services/jellyfin.nix
    ../../modules/services/monitoring.nix
    ../../modules/services/proxy-manager.nix
    ../../modules/services/qbittorrent.nix
    ../../modules/services/quassel.nix
    ../../modules/services/samba.nix
    ../../modules/services/shadowsocks.nix
    ../../modules/services/webserver.nix
    ../../modules/services/wireguard.nix
    ../../modules/services/wstunnel.nix
  ];

  age.identityPaths = [
    "/etc/ssh/agenix_ed25519"
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # ONETIME(PER_USER): Set a password with 'passwd' if login needed
  users = {
    groups = {
      smb-users = { };
      nginx = { };
      qbittorrent = { };
      warehouse = { };
      www = { };
    };
    users = {
      vuks = {
        isNormalUser = true;
        shell = pkgs.bash;
        extraGroups = [
          "wheel"
          "smb-users"
          "warehouse"
          "www"
        ];
      };
      anna = {
        isSystemUser = true;
        group = "smb-users";
        extraGroups = [
          "warehouse"
        ];
      };
      smb-guest = {
        isSystemUser = true;
        group = "smb-users";
        extraGroups = [
          "warehouse"
        ];
        description = "SMB share guest user account";
      };
      nginx = {
        isSystemUser = true;
        group = "nginx";
        extraGroups = [
          "www"
        ];
        description = "Nginx Proxy Manager technical user";
      };
      qbittorrent = {
        isSystemUser = true;
        group = "qbittorrent";
        extraGroups = [
          "warehouse"
        ];
        description = "qBittorrent technical user";
      };
    };
  };

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    # Development tools
    vscode
    tig
    gh
    diff-so-fancy
    nixpkgs-fmt
    nixpkgs-review
    nil
    gnumake

    # AI stuff
    nixos-unstable.code-cursor
    nixpkgs-unstable.kiro
    shell-gpt

    # Utility tools
    kitty
    fzf
    bat
    bc
    btop
    screen
    file
    wget
    curl
    mailutils
    fastfetch

    # System tools
    dig
    pciutils
    usbutils
    lm_sensors
    smartmontools
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
    fzf = {
      fuzzyCompletion = true;
      keybindings = true;
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    nix-ld.enable = true;
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

  networking.extraHosts = ''
    192.168.0.2 themonster
    192.168.0.3 phoenix
    192.168.0.4 robocop
    10.0.0.2 vpn.robocop
  '';

  # ====================================
  # No touching below this line.
  # Copy the NixOS configuration file and link it from the resulting system (/run/current-system/configuration.nix).
  # This is useful in case you accidentally delete configuration.nix.
  system.copySystemConfiguration = false; # cannot be used with flakes
  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?
}

