{ config, lib, pkgs, ... }:
{
  services.shadowsocks = {
    # https://search.nixos.org/options?channel=24.11&query=shadowsocks
    # This uses outdated/unmaintained shadowsocks-libev
    enable = true;
    port = 63814; # TODO portforward this
    ## GPT:
    # Best overall (secure & fast): 2022-blake3-chacha20-poly1305
    # If you have AES hardware acceleration: 2022-blake3-aes-256-gcm
    # If you need compatibility: aes-256-gcm
    # If running on a low-power device (mobile, ARM): xchacha20-ietf-poly1305
    encryptionMethod = "aes-256-gcm";
    # mkdir /etc/shadowsocks && ssservice genkey -m aes-256-gcm >/etc/shadowsocks/server.pass
    passwordFile = "/etc/shadowsocks/server.pass";
  };
}
