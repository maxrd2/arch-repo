#!/bin/bash

set -e

sect() { echo -e "\n\e[1;32m#####> \e[1;39m$@\e[1;32m <#####\e[m" 1>&2; }
info() { echo -e "\e[1;34mINFO:\e[1;39m $@\e[m" 1>&2; }
warn() { echo -e "\e[1;33mWARNING: \e[0;33m$@\e[m" 1>&2; }
fail() { echo -e "\e[1;31mERROR: \e[0;31m$@\e[m" 1>&2; }

find-parent() {
	local dir="$1"
	while [[ ! -d "$dir" ]]; do
		[[ "$PWD" = "/" ]] && fail "Unable to find parent dir '$dir'." && return 1
		cd ..
	done
	echo "$PWD/$dir"
}
gpg-add() {
	for key in "$@"; do
		gpg --list-keys "$key" &>/dev/null || gpg --recv-keys "$key"
	done
}
repo-pkg-file() {
	local pkg="$1"
	local ext="$2"
	[[ -z "$ext" ]] && ext=".pkg.tar.zst"
	[[ -d "$groupdir/$pkg" ]] && pushd "$groupdir/$pkg" >/dev/null || pushd $pkgsdir/*/$pkg >/dev/null
	local pkgname=() arch=()
	local $(makepkg --printsrcinfo | grep -E 'pkgver|pkgrel|epoch|pkgname|arch' | perl -pe 's|\s*=\s*|=|g;s|^\s+||;s|\s+| |g;s!(pkgname|arch)=(\S+)!$1+=($2)!g')
	[[ " ${arch[@]} " = *any* ]] && arch="${arch[0]}" || arch="$(uname -m)"
	[[ ! -z "$epoch" ]] && epoch="$epoch:"
	popd >/dev/null
	echo "$repodir/$pkg-$epoch$pkgver-$pkgrel-$arch$ext"
	return 0
}
repo-pkg-dir() {
	local pkg="$1"
	[[ -d "$groupdir/$pkg" ]] && pushd "$groupdir/$pkg" >/dev/null || pushd $pkgsdir/*/$pkg >/dev/null
	local pkgname=() arch=()
	local $(makepkg --printsrcinfo | grep -E 'pkgver|pkgrel|epoch|pkgname|arch' | perl -pe 's|\s*=\s*|=|g;s|^\s+||;s|\s+| |g;s!(pkgname|arch)=(\S+)!$1+=($2)!g')
	[[ " ${arch[@]} " = *any* ]] && arch="${arch[0]}" || arch="$(uname -m)"
	[[ ! -z "$epoch" ]] && epoch="$epoch:"
	popd >/dev/null
	local pkgtar="/var/lib/pacman/local/$pkg-$epoch$pkgver-$pkgrel"
	echo $pkgtar
	return 0
}
pkg-installed() {
	local pkg="$1"
	[[ -z "$pkg" ]] && return 1
	local dir="$(repo-pkg-dir "$pkg")"
	[[ ! -d "$dir" ]] && return 1
	return 0
}
pkg-remove() {
	local pkg="$1"
	sudo pacman -Rdd --noconfirm --noprogressbar "$pkg"
	#repo-remove "$repofile" "$pkg" || true
	return 0
}
pkg-build-internal() {
	local pkg="$1"
	[[ -d "$groupdir/$pkg" ]] && pushd "$groupdir/$pkg" >/dev/null || pushd $pkgsdir/*/$pkg >/dev/null
	info "Building '$pkg'..."
	makepkg -sCc --noconfirm --needed --nocheck
	popd >/dev/null
	return 0
}
pkg-bootstrap() {
	local pkg="$1"
	local bootstrapFor="$2"
	
	sect "Building '$pkg' bootstrap"

	[[ ! -z "$bootstrapFor" ]] && pkg-installed $bootstrapFor && info "Final package '$bootstrapFor' is installed... Skipping build" && return 0

	local pkgfile="$(repo-pkg-file $pkg ".pkg.tar.lzo")"
	if [[ ! -f "$pkgfile" ]]; then
		PKGEXT=".pkg.tar.lzo" pkg-build-internal $pkg
	else
		info "Package '$pkg' is already built... Skipping"
	fi
	
	if pkg-installed $pkg; then
		info "Package '$pkg' is already installed... Skipping"
	else
		info "Installing '$pkgfile'..."
		sudo pacman -U --noconfirm --needed --noprogressbar "$pkgfile"
	fi
}
pkg-build() {
	local pkg="$1"
	local bootstrap="$2" # remove bootstrap package before installing

	sect "Building '$pkg'"

	local pkgfile="$(repo-pkg-file $pkg)"
	if [[ ! -f "$pkgfile" ]]; then
		pkg-build-internal $pkg
		info "Adding '$pkg' to repo..."
		repo-add -R "$repofile" "$pkgfile"
	else
		info "Package '$pkg' is already built... Skipping"
	fi

	[[ ! -z "$bootstrap" ]] && pkg-installed $bootstrap && info "Removing bootstrap package '$bootstrap'..." && pkg-remove "$bootstrap"

	if pkg-installed $pkg; then
		info "Package '$pkg' is already installed... Skipping"
	else
		info "Installing '$pkgfile'..."
		sudo pacman -U --noconfirm --needed --noprogressbar "$pkgfile"
	fi
	sudo pacman -Dk --quiet # make sure we didn't break dependencies
}

cd "$(dirname "$0")"
groupdir="$PWD"
repodir="$(find-parent .repo)"
reponame="maxrd2"
repofile="$repodir/$reponame.db.tar.xz"
rootdir="$(dirname "$repodir")"
pkgsdir="$rootdir/packages"
downdir="$rootdir/.cache/makepkg-downloads"
builddir="$rootdir/build"
sed -E \
	-e "/^#?COMPRESSXZ/ c COMPRESSXZ=(xz -c -z -9e -T$(nproc) -)" \
	-e "/^#?PKGDEST/ c PKGDEST='$repodir'" \
	-e "/^#?SRCDEST/ c SRCDEST='$downdir'" \
	-e "/^#?BUILDDIR/ c BUILDDIR='$builddir'" \
	-e "/^#?PACKAGER/ c PACKAGER='Mladen Milinkovic <maxrd@smoothware.net>'" \
	-e "/^#?MAKEFLAGS/ c MAKEFLAGS='-j$(nproc)'" \
	/etc/makepkg.conf > $HOME/.makepkg.conf

mkdir -p "$downdir" "$builddir" "$repodir"
[[ ! -f "$repofile" ]] && tar -cJf "$repofile" -T /dev/null || true
