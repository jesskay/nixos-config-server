let

  fetchSource = (src-name: src: builtins.fetchTree { type = "git"; inherit (src) url rev narHash; });

  sourcesJson = builtins.fromJSON (builtins.readFile ./sources.json);

in builtins.mapAttrs fetchSource sourcesJson
