#!/usr/bin/env bash
set -euo pipefail

cd $(dirname $0)

nix run -f ./default.nix nixos-rebuild-wrapped -- "$@"

