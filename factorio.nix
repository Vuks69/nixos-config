{ ... }:
let
  factorioAccountName = "vuks69";
  factorioPort = 34197;
in
{
  services.factorio = {
    enable = true;
    lan = true;
    port = factorioPort;
    openFirewall = true;
    game-name = "Vuks' Den";
    # Note: /var/lib/factorio is actually a symlink to /var/lib/private/factorio
    #       so you'll have to use that if you want to mount a zfs dataset for it.
    stateDirName = "factorio";
    extraSettings = { };
    allowedPlayers = [ 
      factorioAccountName
    ];
    admins = [
      factorioAccountName
    ];
  };
}
