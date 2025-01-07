{ config, pkgs, lib, ... }:

let
  sources = builtins.mapAttrs
    (src-name: src: builtins.fetchTree { type = "git"; url = src.url; rev = src.rev; narHash = src.narHash; })
    (builtins.fromJSON (builtins.readFile ./sources.json));

  nixpkgs-unstable-path = sources.nixpkgs-unstable.outPath;

  pkgs-unstable = import nixpkgs-unstable-path { inherit (pkgs) system; };

in

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
      url = "https://github.com/cn-tools/cntools_FreshRssExtensions/archive/bfe3d84af4bddd699b8c29edf21760303e7aae7b.tar.gz";
      sha256 = "1sxisrn0rfdmp0v606nc9j9545zl3bjkazj0841z5rsk5rpp6x52";
    };
  in {
    enable = true;
    package = pkgs-unstable.freshrss.overrideAttrs (super: {
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
