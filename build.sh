#!/usr/bin/env bash
set -euo pipefail

cd $(dirname $0)

nix run -f ./build.nix nixos-rebuild-wrapped -- "$@"

