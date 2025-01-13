{ config, pkgs, sources, ... }:

{

  # enable acme here for the vhost which the freshrss service will create
  services.nginx.virtualHosts."reader.psquid.net" = {
    addSSL = true;
    enableACME = true;
  };

  services.freshrss = {

    enable = true;

    package = pkgs.freshrss.overrideAttrs (super: {
      installPhase = super.installPhase + ''
        mkdir -p $out/extensions
        ln -s ${sources.freshrss-langfeld}/xExtension-FixedNavMenu $out/extensions/xExtension-FixedNavMenu
        ln -s ${sources.freshrss-langfeld}/xExtension-TouchControl $out/extensions/xExtension-TouchControl
        ln -s ${sources.freshrss-cntools}/xExtension-YouTubeChannel2RssFeed $out/extensions/xExtension-YouTubeChannel2RssFeed
      '';
    });

    database.type = "sqlite";
    dataDir = "/var/lib/freshrss";

    virtualHost = "reader.psquid.net";
    baseUrl = "https://reader.psquid.net";

    defaultUser = "jess";

    passwordFile = config.age.secrets.freshrss.path;

  };

  age.secrets.freshrss.file = ../../secrets/freshrss.age;

}

