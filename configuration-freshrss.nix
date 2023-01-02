{ config, pkgs, lib, ... }:
{
  # enable acme here for the vhost which the freshrss service will create
  services.nginx.virtualHosts."reader.psquid.net" = {
    addSSL = true;
    enableACME = true;
  };

  services.freshrss = let 
   frssLangfeld = builtins.fetchTarball {
      url = "https://github.com/langfeld/FreshRSS-extensions/archive/49c33360638b4ed1baf8217d862e1f05e01812c4.tar.gz";
      sha256 = "1mbxmbb8bszgm8hxxn3vm5k01rg61nldi1i81pq09pv2zpvnz5pi";
    };
   frssCntools = builtins.fetchTarball {
      url = "https://github.com/cn-tools/cntools_FreshRssExtensions/archive/911585c8e0607308dc7d76041fa5a256fffcfc57.tar.gz";
      sha256 = "1n6y4plndmkz07m27hanhiir20g57xlxpm80y1raxdw2xiyksilh";
    };
  in {
    enable = true;
    package = pkgs.freshrss.overrideAttrs (super: {
      installPhase = super.installPhase + ''
        mkdir -p $out/extensions
        ln -s ${frssLangfeld}/xExtension-FixedNavMenu $out/extensions/xExtension-FixedNavMenu
        ln -s ${frssLangfeld}/xExtension-TouchControl $out/extensions/xExtension-TouchControl
        ln -s ${frssCntools}/xExtension-YouTubeChannel2RssFeed $out/extensions/xExtension-YouTubeChannel2RssFeed
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
