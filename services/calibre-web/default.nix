{ config, ... }:

{

  services.calibre-web = {

    enable = true;

    listen.ip = "0.0.0.0";
    listen.port = 8083;
    openFirewall = true;

    options = {

      calibreLibrary = "${config.services.calibre-web.dataDir}/library";

      enableBookUploading = true;
      enableBookConversion = true;
      enableKepubify = true;

    };

  };

  services.nginx.simpleVhosts."calibre.psquid.net" = {
    vhostType = "proxy";
    port = config.services.calibre-web.listen.port;
  };

  services.nginx.virtualHosts."calibre.psquid.net".extraConfig = ''
    proxy_max_temp_file_size 256M;
    client_max_body_size 256M;
  '';

}
