{
  services.nginx.simpleVhosts = {
    "dl.psquid.net" = {
      vhostType = "static";
      webroot = "/var/www/dl.psquid.net/html";
    };

    "dl-public.psquid.net" = {
      vhostType = "index";
      webroot = "/var/www/dl-public.psquid.net/html";
    };

    "psquid.net" = {
      vhostType = "static";
      webroot = "/var/www/www.psquid.net/html";
      aliases = [ "www.psquid.net" ];
    };
  };
}
