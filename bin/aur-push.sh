#!/bin/bash

set -e

[[ -z "$1" ]] && echo "Usage: aur-push.sh <package>" 1>&2 && exit 1

_rt="$(cd "$(dirname "$0")/.." && pwd)"
pkg="$1"
local="$(ls -d "$_rt/packages/"*"/$pkg" 2>/dev/null || true)"
remote="$_rt/$pkg"

[[ ! -d "$remote" ]] && echo "ERROR: AUR $pkg wasn't cloned." 1>&2 && exit

[[ ! -z "$local" ]] \
	&& rsync -av --exclude .git --exclude-from="$remote/.gitignore" "$remote/." "$local/." \
	&& git status packages/*/$pkg
