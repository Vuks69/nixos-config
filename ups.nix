{ config, lib, pkgs, ... }:
{
  power.ups = {
    enable = true;

    ups."apc-cs500" = {
      # note: this model does not report current load in W, but that can be calculated, eg.:
      #       bc <<<"$(upsc apc-cs500 ups.load)*$(upsc apc-cs500 ups.realpower.nominal)/100"
      driver = "usbhid-ups";
      port = "auto";
      description = "APC Back-UPS CS 500";
    };

    users."upsmon" = {
      passwordFile = "/home/upsmon/upsmon.password";
      upsmon = "master";
    };

    upsmon.monitor."apc-cs500".user = "upsmon";
  };
}
