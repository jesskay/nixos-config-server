{
  services.nginx.simpleVhosts."gaydog.mom" = {
    vhostType = "static";
    webroot = "/var/www/www.gaydog.mom/html";
    aliases = [ "www.gaydog.mom" ];
  };
}
