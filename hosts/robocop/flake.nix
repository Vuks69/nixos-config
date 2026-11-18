{
  config,
  pkgs,
  nixos-unstable,
  nixpkgs-unstable,
  ...
}:
{
  networking.hostName = "robocop";

  imports = [
    # System configurations
    ./hardware-configuration.nix
    ../../modules/common/system.nix
    ../../modules/common/sway.nix
    ./wireguard-client.nix
  ];

  #   age.identityPaths = [
  #     "/etc/ssh/agenix_ed25519"
  #   ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.loader.limine = {
    enable = true;
    secureBoot.enable = false;
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  users.users.vuks = {
    isNormalUser = true;
    shell = pkgs.bash;
    extraGroups = [
      "wheel"
    ];
  };

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    # Development tools
    nixpkgs-unstable.vscode
    tig
    gh
    diff-so-fancy
    nixpkgs-fmt
    nixpkgs-review
    nil
    gnumake
    nixpkgs-unstable.devenv
    uv
    nixd
    fd

    # AI stuff
    nixos-unstable.opencode

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
    ripgrep

    # System tools
    sbctl
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
  programs = {
    git.enable = true;
    starship.enable = true;
    firefox.enable = true;
    thunderbird.enable = true;
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
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    libinput.enable = true;
  };

  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };

  networking.extraHosts = ''
    192.168.0.2 themonster
    192.168.0.3 phoenix
  '';

  # ====================================
  # No touching below this line.
  system.copySystemConfiguration = false; # cannot be used with flakes
  system.stateVersion = "26.05";
}
