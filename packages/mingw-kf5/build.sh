#!/bin/bash

set -e

. "$HOME/bin/include-common.sh"

sect "Adding GPG keys"
gpg-add 58D0EE648A48B3BB

sect "Updating pacman databases"
[[ ! -L "$repodir/maxrd2.db" ]] && ln -fs "maxrd2.db.tar.gz" "$repodir/maxrd2.db"
sudo pacman -Sy --noconfirm --needed mingw-w64-toolchain

pkg-build mingw-w64-extra-cmake-modules
pkg-build mingw-w64-attica
pkg-build mingw-w64-kconfig
pkg-build mingw-w64-kwidgetsaddons
pkg-build mingw-w64-kcompletion
pkg-build mingw-w64-kcoreaddons
pkg-build mingw-w64-kauth
pkg-build mingw-w64-kcodecs
pkg-build mingw-w64-kguiaddons
pkg-build mingw-w64-ki18n
pkg-build mingw-w64-kconfigwidgets
pkg-build mingw-w64-kitemviews
pkg-build mingw-w64-karchive
pkg-build mingw-w64-kiconthemes
pkg-build mingw-w64-kwindowsystem
pkg-build mingw-w64-kcrash
pkg-build mingw-w64-kdbusaddons
pkg-build mingw-w64-kservice
pkg-build mingw-w64-sonnet
pkg-build mingw-w64-ktextwidgets
pkg-build mingw-w64-kglobalaccel
pkg-build mingw-w64-kxmlgui
pkg-build mingw-w64-kbookmarks
pkg-build mingw-w64-kdoctools
pkg-build mingw-w64-kimageformats
pkg-build mingw-w64-solid
pkg-build mingw-w64-kjobwidgets
pkg-build mingw-w64-kio
pkg-build mingw-w64-kparts
pkg-build mingw-w64-kross
pkg-build mingw-w64-kunitconversion
pkg-build mingw-w64-python-bin
pkg-build mingw-w64-threadweaver
pkg-build mingw-w64-kinit
