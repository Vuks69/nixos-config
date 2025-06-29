{ config, pkgs, ... }:
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
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.shadowsocks-rust}/bin/ssserver -c /run/shadowsocks/config.json";
      Restart = "on-failure";
      RestartSec = "30";
    };
    preStart = ''
      install -m 0700 -d /run/shadowsocks
      umask 077
      cat >/run/shadowsocks/config.json <<EOF
      {
        "servers": [
          {
            "server": "0.0.0.0",
            "server_port": ${toString shadowsocksPort},
            "password": "$(head -n1 ${config.age.secrets.shadowsocks.path} | tr -d '\n')",
            "method": "aes-256-gcm",
            "fast_open": true
          }
        ]
      }
      EOF
    '';
    restartTriggers = [
      config.age.secrets.shadowsocks.path
    ];
  };

  networking.firewall.allowedTCPPorts = [ shadowsocksPort ];
  networking.firewall.allowedUDPPorts = [ shadowsocksPort ];
}
