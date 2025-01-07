{
  services.nginx.simpleVhosts."msjessi.ca" = {
    vhostType = "static";
    webroot = "/var/www/www.msjessi.ca/html";
    aliases = [ "www.msjessi.ca" ];
  };
}

