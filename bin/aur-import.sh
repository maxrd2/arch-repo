#!/bin/bash

set -e

[[ -z "$1" || -z "$2" ]] && echo "Usage: aur-import.sh <group> <package> ..." 1>&2 && exit 1

_rt="$(cd "$(dirname "$0")/.." && pwd)"
grp="${1%/}" grp="${grp##*/}"

for pkg in "${@:2}"; do
	local="$_rt/packages/$grp/$pkg"
	git clone "https://aur.archlinux.org/$pkg.git" "$local" || true
	rm -rf "$local/.git"
done
