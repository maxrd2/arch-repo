#!/bin/bash

set -e

[[ -z "$1" || -z "$2" ]] && echo "Usage: aur-import.sh <group> <package> ..." 1>&2 && exit 1

_rt="$(cd "$(dirname "$0")/.." && pwd)"
grp="${1%/}" grp="${grp##*/}"

for pkg in "${@:2}"; do
	local="$_rt/packages/$grp/$pkg"
	echo "Updating '$local'..."
	rm -rf "$local"
	mkdir -p "$local"
	curl -L "https://aur.archlinux.org/cgit/aur.git/snapshot/$pkg.tar.gz" | tar -xz --strip-components=1 -C "$local"
done
