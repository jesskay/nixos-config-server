{ config, lib, ... }:

with lib;

{
  options.services.nginx.simpleVhosts = mkOption {
    type = types.attrsOf (types.submodule {
      options = {
        vhostType = mkOption { type = types.enum [ "static" "index" "proxy" "oci-container" "redirect" ]; };
        port = mkOption { type = types.ints.positive; default = 0; };
        innerPort = mkOption { type = types.ints.positive; default = 80; };
        webroot = mkOption { type = types.nullOr types.str; default = null; };
        redirectTo = mkOption { type = types.str; default = ""; };
        container = mkOption { type = types.attrsOf types.anything; default = {}; };
        useSSL = mkOption { type = types.bool; default = true; };
        aliases = mkOption { type = types.listOf types.str; default = []; };
      };
    });
  };

  config = let
    cfg = config.services.nginx.simpleVhosts;
    filterByVhostType = vhostType: vhosts: builtins.filter (vhost: vhost != null) (mapAttrsToList
      (vhost: vhostCfg: if vhostCfg.vhostType == vhostType then vhost else null)
      vhosts);
    containerVhosts = filterByVhostType "oci-container" cfg;
    aliases = builtins.listToAttrs (flatten (mapAttrsToList
      (vhost: vhostCfg: map (alias: { name = alias; value = vhost; }) vhostCfg.aliases)
      cfg));
  in {
    services.nginx.virtualHosts =
    # directly declared vhosts
    (builtins.mapAttrs (vhost: vhostCfg: {
      forceSSL = vhostCfg.useSSL;
      enableACME = vhostCfg.useSSL;
      locations."/" = {
        proxyPass = mkIf (vhostCfg.vhostType == "proxy" || vhostCfg.vhostType == "oci-container")
          "http://localhost:${toString vhostCfg.port}";
        root = mkIf (vhostCfg.vhostType == "static" || vhostCfg.vhostType == "index")
          (if vhostCfg.webroot == null then "/var/www/${vhost}" else vhostCfg.webroot);
        return = mkIf (vhostCfg.vhostType == "redirect") "302 ${vhostCfg.redirectTo}";
        extraConfig = mkIf (vhostCfg.vhostType == "index") "autoindex on;";
      };
    }) cfg)
    //
    # implicit vhosts created by aliases
    (builtins.mapAttrs (alias: vhost: {
      forceSSL = cfg.${vhost}.useSSL;
      useACMEHost = mkIf cfg.${vhost}.useSSL vhost;
      locations."/" = { return = "302 $scheme://${vhost}$request_uri"; };
    }) aliases);

    security.acme.certs =
    builtins.mapAttrs (vhost: vhostCfg: {
      extraDomainNames = vhostCfg.aliases;
    }) cfg;

    virtualisation.oci-containers.containers = builtins.listToAttrs (builtins.map (vhost: {
      name = vhost;
      value = { ports = [ (toString cfg.${vhost}.port + ":" + toString cfg.${vhost}.innerPort) ]; }
        // cfg.${vhost}.container;
    }) containerVhosts);
  };
}
