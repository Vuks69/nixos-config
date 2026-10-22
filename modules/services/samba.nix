{ ... }:

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
    settings = {
      global = {
        "client smb encrypt" = "desired";
        "guest account" = "smb-guest";
        # Anonymous/unknown users fall back to the (read-only) guest account.
        # A mistyped password on a real account also drops to guest instead of
        # erroring, which is safe only because guest has no write access.
        "map to guest" = "Bad User";
        # Lock the service to local network only
        # Allowlist takes precedence
        "allow hosts" = "192.168.0.";
        "deny hosts" = "ALL";

        # Group-writable defaults; each share picks its group via force group.
        # Owner of created files stays the connecting user (no force user).
        "create mask" = "0664";
        "directory mask" = "0775";
        "force create mode" = "0664";
        "force directory mode" = "0775";

        ### TODO set up a cronjob to remove old files
        # # Enable recycling bin
        # "vfs object" = "recycle";
        # "recycle:repository" = "/warehouse/.recycle";
        # "recycle:keeptree" = "yes";
        # "recycle:versions" = "yes";
        # "recycle:touch" = "yes";
        # "recycle:exclude_dir" = "/tmp /TMP /temp /TEMP /public /cache /CACHE";
        # "recycle:exclude" = "*.TMP *.tmp *.temp ~$* *.log *.bak";
      };
      public = {
        path = "/warehouse/public";
        browseable = "yes";
        # Guests (incl. anonymous) may read; only real users may write
        "guest ok" = "yes";
        "read only" = "yes";
        "write list" = "@smb-users";
        "force group" = "warehouse";
      };
      private = {
        path = "/warehouse/private";
        browseable = "no";
        "valid users" = "vuks";
        writeable = "yes";
        "force group" = "warehouse";
      };
      media = {
        path = "/var/www";
        browseable = "no";
        "valid users" = "vuks";
        writeable = "yes";
        "force group" = "www";
      };
    };
  };
}
