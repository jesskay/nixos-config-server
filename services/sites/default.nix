{

  networking.firewall.allowedTCPPorts = [ 80 443 ];

  security.acme.acceptTerms = true;
  security.acme.defaults.email = "letsencrypt@psquid.net";

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
  };

  # Import site configurations, mostly using modules/simple-nginx for terse SSL-by-default sites.
  imports = [
    ./psquid.net.nix
    ./gaydog.mom.nix
    ./msjessi.ca.nix
  ];
    
}
