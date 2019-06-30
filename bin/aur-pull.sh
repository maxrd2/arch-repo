#!/bin/bash

set -e

[[ -z "$1" ]] && echo "Usage: aur-pull.sh <package>" 1>&2 && exit 1

_rt="$(cd "$(dirname "$0")/.." && pwd)"
pkg="$1"
local="$(ls -d "$_rt/packages/"*"/$pkg" 2>/dev/null || true)"
remote="$_rt/$pkg"

git clone "ssh://aur@aur.archlinux.org/$pkg.git" "$remote"
[[ ! -z "$local" ]] && cp -rf "$local/." "$remote/."
(cd "$remote" && git status --short)
