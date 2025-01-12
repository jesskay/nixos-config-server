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


# Fetch this repo into the nix store
store_path="$(nix --extra-experimental-features 'nix-command fetch-tree' eval --impure --raw --expr '(builtins.fetchTree { type = "git"; url = "file://'"$(dirname "$(realpath "$0")")"'"; }).outPath')"


# Build the toplevel.

cd $(dirname $0)

toplevel="$(nix build "${build_args[@]}" -f "$store_path/build.nix" --argstr hostname "$hostname")"


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
