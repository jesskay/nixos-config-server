let

  sources = import ./sources.nix;

  nixpkgs-path = sources.nixpkgs-unstable.outPath;

  system = builtins.currentSystem;

  pkgs = import nixpkgs-path { inherit system; };

in {

  nixos-rebuild-wrapped = pkgs.writeShellScriptBin "nixos-rebuild-wrapped" ''
    hostname="$(${pkgs.nettools}/bin/hostname)"

    config_path="$PWD/hosts/$hostname/default.nix"

    if ! [[ -e "$config_path" ]]; then
      echo "ERROR: No configuration exists for host '$hostname'."
      exit 1
    fi

    nix_path="nixpkgs=${nixpkgs-path}:nixos-config=$config_path"

    # If no arguments, run the switch command
    cmd=''${1:-switch}
    shift

    sudo env NIX_PATH="$nix_path" ${pkgs.nixos-rebuild}/bin/nixos-rebuild "$cmd" --fast "$@"
  '';

}
