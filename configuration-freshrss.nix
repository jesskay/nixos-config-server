{ config, pkgs, lib, ... }:
{
  # enable acme here for the vhost which the freshrss service will create
  services.nginx.virtualHosts."reader.psquid.net" = {
    addSSL = true;
    enableACME = true;
  };

  services.freshrss = {
    enable = true;
    database.type = "sqlite";
    virtualHost = "reader.psquid.net";
    baseUrl = "https://reader.psquid.net";
    dataDir = "/var/lib/freshrss";
    defaultUser = "jess";
    passwordFile = config.age.secrets.freshrss.path;
  };
}
