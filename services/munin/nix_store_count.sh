#!/usr/bin/env bash

case ${1:-} in
  config)
    echo 'graph_title Nix store size (count)'
    echo 'graph_vlabel count'
    echo 'nix_store_count.label count'
    echo 'graph_category nix'
    echo 'graph_info The number of realized (non-.drv) items currently in the nix store.'
    exit 0
    ;;
esac

echo -n 'nix_store_count.value '
find /nix/store -maxdepth 1 -not -name '*.drv' -printf '.' | wc -c

