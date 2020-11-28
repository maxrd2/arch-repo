#!/bin/bash

set -e

[[ -z "$1" || -z "$2" ]] && echo "Usage: aur-export.sh <group> <package> ..." 1>&2 && exit 1

_rt="$(cd "$(dirname "$0")/.." && pwd)"
grp="${1%/}" grp="${grp##*/}"

git -C "$_rt" status

echo ''
read -p "This action will overwrite non-commited changes. Press Enter to continue... " -n 1 -r

for pkg in "${@:2}"; do
	local="$_rt/packages/$grp/$pkg"
	echo "Cloning to '$local'..."
	rm -rf "$local"
	git clone "ssh://aur@aur.archlinux.org/$pkg.git" "$local"
	git checkout "$local"
	(cd "$local" && echo -e "\n**** ${local##*/} ****\nExit shell to process next package..." && bash) || true
	rm -rf "$local/.git"
	git status
done
