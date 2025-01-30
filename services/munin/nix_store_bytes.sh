#!/usr/bin/env bash

case ${1:-} in
  config)
    echo 'graph_args --base 1024'
    echo 'graph_title Nix store size (bytes)'
    echo 'graph_vlabel bytes'
    echo 'nix_store_bytes.label total'
    echo 'nix_system_bytes.label system'
    echo 'graph_category nix'
    echo 'graph_info The total size in bytes of the nix store/system closure.'
    exit 0
    ;;
esac

echo -n 'nix_store_bytes.value '
du -bs /nix/store | cut -f1

echo -n 'nix_system_bytes.value '
nix path-info -S /run/current-system | cut -d' ' -f2
