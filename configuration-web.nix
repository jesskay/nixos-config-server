{ config, pkgs, lib, ... }:
{
  imports = [ ./mod-simple-nginx.nix ];

  networking.firewall.allowedTCPPorts = [ 80 443 ];

  security.acme = {
    email = "letsencrypt@psquid.net";
    acceptTerms = true;
  };

  services.nginx = {
    enable = true;
    recommendedOptimisation = true;
    recommendedTlsSettings = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;

    # default catch-all sites
    virtualHosts."_" = {
      addSSL = true;
      sslCertificateKey = "/var/www/snakeoil-2021.key";
      sslCertificate = "/var/www/snakeoil-2021.crt";
      default = true;
      locations."/" = {
        root = "/var/www/html";
        index = "nonexistent.html";
      };
    };

    # terse SSL+ACME-by-default sites, as defined in mod-simple-nginx
    simpleVhosts = {
      "dl.psquid.net" = {
        vhostType = "static";
        webroot = "/var/www/dl.psquid.net/html";
      };
      "dl-public.psquid.net" = {
        vhostType = "index";
        webroot = "/var/www/dl-public.psquid.net/html";
      };
      "gaydog.mom" = {
        vhostType = "static";
        webroot = "/var/www/www.gaydog.mom/html";
        aliases = [ "www.gaydog.mom" ];
      };
      "msjessi.ca" = {
        vhostType = "static";
        webroot = "/var/www/www.msjessi.ca/html";
        aliases = [ "www.msjessi.ca" ];
      };
      "psquid.net" = {
        vhostType = "static";
        webroot = "/var/www/www.psquid.net/html";
        aliases = [ "www.psquid.net" ];
      };
      "reader.psquid.net" = {
        vhostType = "oci-container";
        aliases = [ "sapphic.space" ];
        port = 2080;
        container = let
          frssYoutube = builtins.fetchTarball {
            url = "https://github.com/kevinpapst/freshrss-youtube/archive/refs/tags/0.10.2.tar.gz";
            sha256 = "1b18d0mvzcqxmvgrj9x0y3nr3dgx9zypzpm4xx1kql7cmvgkjz1k";
          };
          frssLangfeld = builtins.fetchTarball {
            url = "https://github.com/langfeld/FreshRSS-extensions/archive/refs/heads/master.tar.gz";
            sha256 = "1mbxmbb8bszgm8hxxn3vm5k01rg61nldi1i81pq09pv2zpvnz5pi";
          };
          freshrssExtensions = pkgs.runCommandLocal "freshrss-extensions" { inherit frssYoutube frssLangfeld; } ''
            mkdir -p $out
            cp -a $frssYoutube/xExtension-YouTube $out/xExtension-YouTube
            cp -a $frssLangfeld/xExtension-FixedNavMenu $out/xExtension-FixedNavMenu
            cp -a $frssLangfeld/xExtension-TouchControl $out/xExtension-TouchControl
          '';
        in {
          # pull a specific versioned tag to make this config more reproducible
          # (could still fail if the tag is ever deleted)
          # this prevents getting updates automatically, but so would caching otherwise,
          # and following the release feed to manually bump the version here is no big deal
          image = "freshrss/freshrss:1.18.1-arm";
          volumes = [
            "freshrss-data:/var/www/FreshRSS/data"
            "${freshrssExtensions}:/var/www/FreshRSS/extensions"
          ];
          environment = {
            "CRON_MIN" = "4,34";
            "TZ" = "Europe/London";
          };
        };
      };
    };
  };
}
