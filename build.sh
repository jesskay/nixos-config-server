#!/usr/bin/env bash
set -euo pipefail

# Parse our flags out of the args if present, and then store resulting args without them.

declare -a apply_args
build_args=( "--no-link" "--print-out-paths" "--pure-eval" )
print_out_path=
apply_build=yes

while [[ "$#" -gt 0 ]]; do
	case ${1:-} in
		--)
			shift 1
			apply_args+=( "$@" )
			shift $#
			;;
		--help)
			message=(
				"USAGE: $(basename $0) [OPTIONS...]"
				""
				"Available options:"
				"	--hostname <HOSTNAME>"
				"		Build for <HOSTNAME> instead of the current hostname."
				""
				"	--dry-run"
				"		Perform a dry build and then exit."
				""
				"	--print-out-path"
				"		Dump out the path to the new toplevel instead of proceeding to apply it."
			)
			printf '%s\n' "${message[@]}"
			exit 0
			;;
		--hostname)
			if [[ "$#" -lt 2 ]]; then
				echo "--hostname requires a parameter"
				exit 1
			else
				hostname="$2"
				shift 2
			fi
			;;
		--dry-run)
			build_args+=( "--dry-run" )
			apply_build=
			shift 1
			;;
		--print-out-path)
			print_out_path=yes
			apply_build=
			shift 1
			;;
		--show-trace)
			build_args+=( "$1" )
			shift 1
			;;
		--*)
			echo "Unrecognized option: $1"
			echo
			echo "To pass options to switch-to-configuration, use -- to indicate no more $(basename $0) options."
			exit 1
			;;
		*)
			apply_args+=( "$1" )
			shift 1
			;;
	esac
done

hostname="${hostname:-$(hostname)}"


# Ensure jq present
if ! command -v jq >/dev/null 2>&1; then
	echo "jq not on PATH, bootstrapping it from nixpkgs rev 8f3e1f8. This may take some time, and WILL take nix store space."
	jq_tmp="$(mktemp -d)"
	cd "$jq_tmp"
	system="$(uname -m)-$(uname -s | tr '[:upper:]' '[:lower:]')"
	nix --extra-experimental-features 'nix-command fetch-tree' build --expr '(import (builtins.fetchTree { type = "git"; url = "git@github.com:NixOS/nixpkgs.git"; rev = "8f3e1f807051e32d8c95cd12b9b421623850a34d"; narHash = "sha256-/qlNWm/IEVVH7GfgAIyP6EsVZI6zjAx1cV5zNyrs+rI="; }) { system = "'"$system"'"; }).jq.bin'
	jq_store_path="$(realpath result-bin)"
	rm result-bin
	PATH="$jq_store_path/bin:$PATH"
	cd - >/dev/null
fi


# Fetch this repo into the nix store (we move outPath to path here to prevent nix eval trying to be helpful with turning an attr with outPath into a path string, and then move it back in jq afterwards)
metadata="$(nix --extra-experimental-features 'nix-command fetch-tree' eval --impure --json --expr 'let s = builtins.fetchTree { type = "git"; url = "file://'"$(dirname "$(realpath "$0")")"'"; }; in builtins.removeAttrs (s // { path = s.outPath; }) ["outPath"]' | jq '.outPath = .path | del(.path)')"
store_path="$(echo "$metadata" | jq -r .outPath)"


# Build the toplevel.

cd $(dirname $0)

toplevel="$(nix build "${build_args[@]}" -f "$store_path/build.nix" --argstr hostname "$hostname" --argstr inject-self-source "$metadata")"


# If we're printing the out path, do so.
if [[ -n "$print_out_path" ]]; then
	echo "$toplevel"
fi


# If we're not applying the build, we're done.
if [[ -z "$apply_build" ]]; then
	exit 0
fi


# Figure out which action is being called (default switch), and if boot/switch, set the profile to the new toplevel.

action="${apply_args[0]:-switch}"
apply_args=( "${apply_args[@]:1}" )

case "$action" in
	boot|switch)
		sudo nix-env -p /nix/var/nix/profiles/system --set "$toplevel"
		;;
esac


# Call $toplevel/bin/switch-to-configuration with the arguments we retained.

sudo "$toplevel/bin/switch-to-configuration" "$action" "${apply_args[@]}"
