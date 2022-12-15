{ config, pkgs, lib, ... }:
{
  # enable acme here for the vhost which the freshrss service will create
  services.nginx.virtualHosts."reader.psquid.net" = {
    addSSL = true;
    enableACME = true;
  };

  services.freshrss = let 
    frssYoutube = builtins.fetchTarball {
      url = "https://github.com/kevinpapst/freshrss-youtube/archive/refs/tags/0.10.2.tar.gz";
      sha256 = "1b18d0mvzcqxmvgrj9x0y3nr3dgx9zypzpm4xx1kql7cmvgkjz1k";
    };
    frssLangfeld = builtins.fetchTarball {
      url = "https://github.com/langfeld/FreshRSS-extensions/archive/refs/heads/master.tar.gz";
      sha256 = "1mbxmbb8bszgm8hxxn3vm5k01rg61nldi1i81pq09pv2zpvnz5pi";
    };
  in {
    enable = true;
    package = pkgs.freshrss.overrideAttrs (super: {
      fixupPhase = ''
        mkdir -p $out/extensions
        ln -s ${frssYoutube}/xExtension-YouTube $out/extensions/xExtension-YouTube
        ln -s ${frssLangfeld}/xExtension-FixedNavMenu $out/extensions/xExtension-FixedNavMenu
        ln -s ${frssLangfeld}/xExtension-TouchControl $out/extensions/xExtension-TouchControl
      '';
    });
    database.type = "sqlite";
    virtualHost = "reader.psquid.net";
    baseUrl = "https://reader.psquid.net";
    dataDir = "/var/lib/freshrss";
    defaultUser = "jess";
    passwordFile = config.age.secrets.freshrss.path;
  };
}
