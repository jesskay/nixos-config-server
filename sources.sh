#!/usr/bin/env bash
set -euo pipefail


ensure_nix() {
	if ! command -v nix >/dev/null 2>&1; then
		echo "nix must be on PATH. Follow instructions from https://nixos.org/download/"
		exit 1
	fi
}


ensure_git() {
	if ! command -v git >/dev/null 2>&1; then
		echo "git not on PATH, bootstrapping it from nixpkgs rev 8f3e1f8. This may take some time, and WILL take nix store space."
		git_tmp="$(mktemp -d)"
		cd "$git_tmp"
		nix --extra-experimental-features 'nix-command fetch-tree' build --expr '(import (builtins.fetchTree { type = "git"; url = "git@github.com:NixOS/nixpkgs.git"; rev = "8f3e1f807051e32d8c95cd12b9b421623850a34d"; narHash = "sha256-/qlNWm/IEVVH7GfgAIyP6EsVZI6zjAx1cV5zNyrs+rI="; }) { system = "aarch64-linux"; }).git'
		git_store_path="$(realpath result)"
		rm result
		PATH="$git_store_path/bin:$PATH"
		cd - >/dev/null
	fi
}


ensure_jq() {
	if ! command -v jq >/dev/null 2>&1; then
		echo "jq not on PATH, bootstrapping it from nixpkgs rev 8f3e1f8. This may take some time, and WILL take nix store space."
		jq_tmp="$(mktemp -d)"
		cd "$jq_tmp"
		nix --extra-experimental-features 'nix-command fetch-tree' build --expr '(import (builtins.fetchTree { type = "git"; url = "git@github.com:NixOS/nixpkgs.git"; rev = "8f3e1f807051e32d8c95cd12b9b421623850a34d"; narHash = "sha256-/qlNWm/IEVVH7GfgAIyP6EsVZI6zjAx1cV5zNyrs+rI="; }) { system = "aarch64-linux"; }).jq.bin'
		jq_store_path="$(realpath result-bin)"
		rm result-bin
		PATH="$jq_store_path/bin:$PATH"
		cd - >/dev/null
	fi
}


SOURCES_ROOT="$(dirname "$0")"
SOURCES_JSON="$SOURCES_ROOT/sources.json"

if ! [ -e "$SOURCES_JSON" ]; then
	echo "No sources.json, creating as empty."
	echo "{}" > "$SOURCES_JSON"
fi

COMMAND=""

if [[ "$#" -gt "0" ]]; then
	COMMAND="$1"
	shift 1
fi

case $COMMAND in
	list)
		if [[ "$#" -ne "0" ]]; then
			echo "USAGE: $SOURCES_ROOT/sources.sh list"
			echo "      Lists currently known sources."
			exit 1
		fi

		ensure_jq

		for src in $(jq -r "keys[]" < "$SOURCES_JSON"); do
			echo -e "\033[1mSource $src:\033[0m"
			echo -e "  \033[1mURL:\033[0m       $(jq -r ".[\"$src\"].url" < "$SOURCES_JSON")"
			echo -e "  \033[1mBranch:\033[0m    $(jq -r ".[\"$src\"].branch" < "$SOURCES_JSON")"
			echo -e "  \033[1mRevision:\033[0m  $(jq -r ".[\"$src\"].rev" < "$SOURCES_JSON")"
			echo
		done
		;;
	add)
		if [[ "$#" -ne "3" ]]; then
			echo "USAGE: $SOURCES_ROOT/sources.sh add <NAME> <URL> <BRANCH>"
			echo "      Adds source NAME, from the git repo at URL, tracking branch BRANCH."
			exit 1
		fi

		ensure_nix
		ensure_jq
		ensure_git

		if (jq -e ".[\"$1\"]" < "$SOURCES_JSON" 2>&1 >/dev/null); then
			echo "ERROR: '$1' already present."
			exit 1
		fi

		echo "Getting latest revision..."
		rev="$(git ls-remote "$2" "$3" | cut -f1)"
		narHash="$(nix --extra-experimental-features 'nix-command fetch-tree' eval --raw --expr '(builtins.fetchTree { type = "git"; url = "'"$2"'"; ref = "refs/heads/'"$3"'"; rev = "'"$rev"'"; }).narHash')"

		tmp="$(mktemp --suffix '.json')"
		cat "$SOURCES_JSON" > "$tmp"
		jq ".[\"$1\"] = { \"url\": \"$2\", \"branch\": \"$3\", \"rev\": \"$rev\", \"narHash\": \"$narHash\" }" < "$tmp" > "$SOURCES_JSON"
		rm "$tmp"

		echo -e "Added \033[1m$1\033[0m:"
		echo -e "  \033[1mURL:\033[0m       $(jq -r ".[\"$1\"].url" < "$SOURCES_JSON")"
		echo -e "  \033[1mBranch:\033[0m    $(jq -r ".[\"$1\"].branch" < "$SOURCES_JSON")"
		echo -e "  \033[1mRevision:\033[0m  $(jq -r ".[\"$1\"].rev" < "$SOURCES_JSON")"
		;;
	rm)     ;&
	remove)
		if [[ "$#" -ne "1" ]]; then
			echo "USAGE: $SOURCES_ROOT/sources.sh remove <NAME>"
			echo "       $SOURCES_ROOT/sources.sh rm <NAME>"
			echo "      Removes source NAME."
			exit 1
		fi

		ensure_nix
		ensure_jq

		if ! (jq -e ".[\"$1\"]" < "$SOURCES_JSON" 2>&1 >/dev/null); then
			echo "ERROR: '$1' not present."
			exit 1
		fi

		tmp="$(mktemp --suffix '.json')"
		cat "$SOURCES_JSON" > "$tmp"
		jq "del(.[\"$1\"])" < "$tmp" > "$SOURCES_JSON"
		rm "$tmp"

		echo -e "Removed \033[1m$1\033[0m."
		;;
	update)
		ensure_nix
		ensure_jq
		ensure_git

		sources="$(jq -r "keys[]" < "$SOURCES_JSON")"

		# If sources were passed in, check that they all exist in $SOURCES_JSON
		if [[ "$#" -ne "0" ]]; then
			for src in "$@"; do
				found=no
				for knownsrc in $sources; do
					if [[ "$src" = "$knownsrc" ]]; then
						found=yes
						break
					fi
				done

				if [[ "$found" = "no" ]]; then
					echo "'$src' is not a known source."
					exit 1
				fi
			done

			# If we haven't exited, all passed in sources are valid. Set $sources.
			sources=$*
		fi

		for src in $sources; do
			url="$(jq -r ".[\"$src\"].url" < "$SOURCES_JSON")"
			branch="$(jq -r ".[\"$src\"].branch" < "$SOURCES_JSON")"
			oldrev="$(jq -r ".[\"$src\"].rev" < "$SOURCES_JSON")"

			echo -e "Getting latest revision for \033[1m$src\033[0m..."
			rev="$(git ls-remote "$url" "$branch" | cut -f1)"

			if [[ "$oldrev" = "$rev" ]]; then
				echo -e "Already up to date."
			else
				echo -e "Updating to revision \033[1m$rev\033[0m..."
				narHash="$(nix --extra-experimental-features 'nix-command fetch-tree' eval --raw --expr '(builtins.fetchTree { type = "git"; url = "'"$url"'"; ref = "refs/heads/'"$branch"'"; rev = "'"$rev"'"; }).narHash')"

				tmp="$(mktemp --suffix '.json')"
				cat "$SOURCES_JSON" > "$tmp"
				jq ".[\"$src\"].rev = \"$rev\" | .[\"$src\"].narHash = \"$narHash\"" < "$tmp" > "$SOURCES_JSON"
				rm "$tmp"

				echo "Done."
			fi

			echo
		done
		;;
	*)
		echo "USAGE: $SOURCES_ROOT/sources.sh <COMMAND> [<ARGS...>]"
		echo
		echo "COMMANDS:"
		echo "  list"
		echo "      Lists currently known sources."
		echo
		echo "  add <NAME> <URL> <BRANCH>"
		echo "      Adds source NAME, from the git repo at URL, tracking branch BRANCH."
		echo
		echo "  remove <NAME>"
		echo "  rm <NAME>"
		echo "      Removes source NAME."
		echo
		echo "  update [<SOURCES...>]"
		echo "      Updates sources to the latest revision. If one or more SOURCEs is passed,"
		echo "      update only those sources."
		;;
esac

