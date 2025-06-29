{ config, pkgs, ... }:
let
  factorioAccountName = "vuks69";
  factorioPort = 34197;

  # Somewhat hacky way to disable the space age mods
  # https://github.com/NixOS/nixpkgs/issues/392183#issuecomment-2781682263
  mod-list-json = pkgs.writeText "mod-list.json" (
    builtins.toJSON {
      mods = [
        {
          name = "base";
          enabled = true;
        }
        {
          name = "elevated-rails";
          enabled = false;
        }
        {
          name = "quality";
          enabled = false;
        }
        {
          name = "space-age";
          enabled = false;
        }
      ];
    }
  );
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

  systemd.services.factorio.postStart = ''
    cat ${mod-list-json} >/var/lib/${config.services.factorio.stateDirName}/mods/mod-list.json
  '';
}
