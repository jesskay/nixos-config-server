let
  sources = builtins.mapAttrs
    (src-name: src: builtins.fetchTree { type = "git"; url = src.url; rev = src.rev; narHash = src.narHash; })
    (builtins.fromJSON (builtins.readFile ./sources.json));

  nixpkgs-path = sources.nixpkgs.outPath;

  system = builtins.currentSystem;

  pkgs = import nixpkgs-path { inherit system; };

in {

  nixos-rebuild-wrapped = pkgs.writeShellScriptBin "nixos-rebuild-wrapped" ''
    config_path="$PWD/configuration.nix"

    if ! [[ -e "$config_path" ]]; then
      echo "ERROR: Configuration $config_path does not exist."
      exit 1
    fi

    nix_path="nixpkgs=${nixpkgs-path}:nixos-config=$config_path"

    # If no arguments, run the switch command
    cmd=''${1:-switch}
    shift

    sudo env NIX_PATH="$nix_path" ${pkgs.nixos-rebuild}/bin/nixos-rebuild "$cmd" --fast "$@"
  '';

}
