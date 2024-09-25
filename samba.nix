{ config, lib, pkgs, ... }:

{
  # NOTES:
  # Remember to add users with `smbpasswd`.
  # This includes guest access user:
  #   sudo smbpasswd -an smb-guest # [a]dd user with [n]ull password
  # To check for users already in smbpasswd database:
  #   sudo tdbtool /var/lib/samba/private/passdb.tdb keys | sed -n 's/.*USER_\(.*\)/\1/p'
  services.samba = {
    enable = true;
    openFirewall = true;
    extraConfig = ''
      client smb encrypt = desired
      guest account = smb-guest
      # Lock the service to local network only
      # Allowlist takes precedence
      allow hosts = 192.168.0.
      deny hosts = ALL 
    '';
    shares = {
      public = {
        path = "/warehouse/public";
        public = "yes";
        browseable = "yes";
        writeable = "yes";
      };
      private = {
        path = "/warehouse/private";
        public = "no";
        browseable = "no";
        "valid users" = "vuks";
      };
    };
  };
}
