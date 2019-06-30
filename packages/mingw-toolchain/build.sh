#!/bin/bash

set -e

. "$HOME/bin/include-common.sh"

sect "Adding GPG keys"
gpg-add 93BDB53CD4EBC740 13FCEF89DD9E3C4F A328C3A2C3C45C06

sect "Updating pacman databases"
[[ ! -L "$repodir/maxrd2.db" ]] && ln -fs "maxrd2.db.tar.gz" "$repodir/maxrd2.db"
sudo pacman -Sy

pkg-build mingw-w64-headers
pkg-build mingw-w64-binutils
pkg-bootstrap mingw-w64-headers-bootstrap mingw-w64-winpthreads
pkg-bootstrap mingw-w64-gcc-base mingw-w64-gcc
pkg-build mingw-w64-crt
pkg-build mingw-w64-winpthreads mingw-w64-headers-bootstrap
pkg-build mingw-w64-gcc mingw-w64-gcc-base
pkg-build mingw-w64-pkg-config
pkg-build mingw-w64-cmake
pkg-build mingw-w64-configure
pkg-build mingw-w64-meson
pkg-build mingw-w64-wine
pkg-build mingw-w64-tools
