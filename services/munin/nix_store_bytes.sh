#!/usr/bin/env bash

case ${1:-} in
  config)
    echo 'graph_args --base 1024'
    echo 'graph_title Nix store size (bytes)'
    echo 'graph_vlabel bytes'
    echo 'nix_store_bytes.label bytes'
    echo 'graph_category nix'
    echo 'graph_info The total size in bytes of the nix store.'
    exit 0
    ;;
esac

echo -n 'nix_store_bytes.value '
du -bs /nix/store | cut -f1
