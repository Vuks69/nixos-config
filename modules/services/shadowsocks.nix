{ config, lib, pkgs, ... }:
let
  shadowsocksPort = 63814;
in
{
  age.secrets.shadowsocks.file = ../../secrets/shadowsocks/password.age;

  environment.systemPackages = with pkgs; [
    shadowsocks-rust
  ];

  systemd.services.shadowsocks = {
    enable = true;
    description = "Shadowsocks server";
    after = [ "network-online.target" ];
    requires = [ "network-online.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.shadowsocks-rust}/bin/ssserver -c /etc/shadowsocks/config.json";
      Restart = "always";
      RestartSec = "30";
    };
    restartTriggers = [
      config.environment.etc."shadowsocks/config.json".source
    ];
  };

  networking.firewall.allowedTCPPorts = [ shadowsocksPort ];
  networking.firewall.allowedUDPPorts = [ shadowsocksPort ];

  # mkdir -p /etc/shadowsocks/auth
  # ssservice genkey -m "aes-128-gcm" >/etc/shadowsocks/auth/van-guest.pass
  # Warning: this adds a newline (0a byte) at the end
  #   of the file for whatever reason. Remove it or ss won't start.
  environment.etc."shadowsocks/config.json" = {
    mode = "0600";
    text = ''
      {
        "servers": [
          {
            "server": "0.0.0.0",
            "server_port": ${builtins.toString shadowsocksPort},
            "password": "${builtins.readFile config.age.secrets.shadowsocks.path}",
            "method": "aes-256-gcm",
            "fast_open": true
          }
        ]
      }
    '';
  };
}
