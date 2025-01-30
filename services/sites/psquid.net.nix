{ pkgs, lib, sources, ... }:

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

    "psquid.net" = let
      blog = pkgs.stdenv.mkDerivation {
        name = "blog";
        src = sources.blog.outPath;

        buildPhase = ''
          mkdir -p ./built ./src
          cp -r $src/* ./src/

          ${lib.getExe pkgs.jekyll} build -s ./src -d ./built

          mkdir -p $out
          cp -r ./built/* $out/
        '';
      };
    in {
      vhostType = "static";
      webroot = "${blog}";
      aliases = [ "www.psquid.net" ];
    };
  };
}
