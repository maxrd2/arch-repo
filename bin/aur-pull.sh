#!/bin/bash

set -e

[[ -z "$1" ]] && echo "Usage: aur-pull.sh <package> ..." 1>&2 && exit 1

for pkg in "$@"; do
	_rt="$(cd "$(dirname "$0")/.." && pwd)"
	local="$(ls -d "$_rt/packages/"*"/$pkg" 2>/dev/null || true)"
	remote="$_rt/$pkg"

	if [[ -d "$remote" ]]; then
		(cd "$remote" && git fetch origin && git reset --hard origin/master)
	else
		git clone "ssh://aur@aur.archlinux.org/$pkg.git" "$remote"
	fi
	[[ ! -z "$local" ]] && cp -rf "$local/." "$remote/."
	(cd "$remote" && git status --short)
done
