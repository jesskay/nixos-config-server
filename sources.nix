let

  fetchSource = (src-name: src: builtins.fetchTree {
    type = "git";
    ref = "refs/heads/${src.branch}";
    inherit (src) url rev narHash;
  });

  sourcesJson = builtins.fromJSON (builtins.readFile ./sources.json);

in builtins.mapAttrs fetchSource sourcesJson
