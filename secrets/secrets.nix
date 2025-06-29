let
  vuks = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHSGWsbn2Un+nueskZtfmSWczontNnAlAmtWKw81o8Xl";
  users = [ vuks ];
  phoenix = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID/8NLLlGayNVWrqmLR4iFdcZbMDGmzGTWCbg16qifcq";
  systems = [ phoenix ];
in
{
  "ddns/duckdns.token.age".publicKeys = [ phoenix ];
  "shadowsocks/password.age".publicKeys = [ phoenix ];
  "wireguard/server.key.age".publicKeys = [ phoenix ];
  "wireguard/server.pub.age".publicKeys = [ phoenix ];
  "wstunnel/envFile.age".publicKeys = [ phoenix ];
}
