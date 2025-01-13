#!/usr/bin/env bash

case ${1:-} in
  config)
    echo 'graph_args -l 0'
    echo 'graph_title Source age'
    echo 'graph_vlabel days'
    echo 'nixpkgs_age.label nixpkgs'
    echo 'nixpkgs_unstable_age.label nixpkgs-unstable'
    echo 'configuration_age.label configuration'
    echo 'graph_scale no'
    echo 'graph_category nix'
    echo 'nixpkgs_age.warning 30'
    echo 'nixpkgs_age.critical 60'
    echo 'nixpkgs_unstable_age.warning 30'
    echo 'nixpkgs_unstable_age.critical 60'
    echo 'graph_info The source age describes how many days since the last commit to the sources used to build the current system. For nixpkgs inputs this will typically be at least a few days even after a fresh update, due to the time taken for commits to pass hydra.'
    echo 'nixpkgs_age.info Nixpkgs stable input age. (REMOVED)'
    echo 'nixpkgs_unstable_age.info Nixpkgs unstable input age.'
    echo 'configuration_age.info System configuration age.'
    exit 0
    ;;
esac

echo -n "nixpkgs_age.value "
echo "nan"  # this is just here to preserve the line on the graph
echo -n "nixpkgs_unstable_age.value "
echo "scale=2; ($(date +%s) - $NIXPKGS_UNSTABLE_LAST_MODIFIED) / (60 * 60 * 24)" | bc
echo -n "configuration_age.value "
echo "scale=2; ($(date +%s) - $SELF_LAST_MODIFIED) / (60 * 60 * 24)" | bc
