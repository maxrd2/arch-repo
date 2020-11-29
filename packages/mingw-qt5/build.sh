#!/bin/bash

set -e

. "$HOME/bin/include-common.sh"

sect "Adding GPG keys"
# gpg-add 

sect "Updating pacman databases"
[[ ! -L "$repodir/maxrd2.db" ]] && ln -fs "maxrd2.db.tar.gz" "$repodir/maxrd2.db"
sudo pacman -Sy --noconfirm --needed mingw-w64-toolchain

pkg-build mingw-w64-qt5-base
pkg-build mingw-w64-qt5-imageformats
pkg-build mingw-w64-qt5-declarative
pkg-build mingw-w64-qt5-tools
pkg-build mingw-w64-qt5-svg
pkg-build mingw-w64-qt5-script
pkg-build mingw-w64-qt5-winextras
pkg-build mingw-w64-qt5-multimedia
pkg-build mingw-w64-qt5-speech
pkg-build mingw-w64-qt5-quickcontrols
pkg-build mingw-w64-qt5-quickcontrols2

# pkg-build mingw-w64-qt5-base-angle
# pkg-build mingw-w64-qt5-base-dynamic

pkg-build mingw-w64-qt5-base-static
pkg-build mingw-w64-qt5-imageformats-static
pkg-build mingw-w64-qt5-declarative-static
pkg-build mingw-w64-qt5-tools-static
pkg-build mingw-w64-qt5-svg-static
pkg-build mingw-w64-qt5-script-static
pkg-build mingw-w64-qt5-winextras-static
pkg-build mingw-w64-qt5-multimedia-static
pkg-build mingw-w64-qt5-speech-static
pkg-build mingw-w64-qt5-quickcontrols-static
pkg-build mingw-w64-qt5-quickcontrols2-static

pkg-build mingw-w64-qt5-gamepad
pkg-build mingw-w64-qt5-3d
pkg-build mingw-w64-qt5-activeqt
pkg-build mingw-w64-qt5-canvas3d
pkg-build mingw-w64-qt5-charts
pkg-build mingw-w64-qt5-connectivity
pkg-build mingw-w64-qt5-datavis3d
pkg-build mingw-w64-qt5-feedback
pkg-build mingw-w64-qt5-graphicaleffects
pkg-build mingw-w64-qt5-location
pkg-build mingw-w64-qt5-networkauth
pkg-build mingw-w64-qt5-remoteobjects
pkg-build mingw-w64-qt5-scxml
pkg-build mingw-w64-qt5-sensors
pkg-build mingw-w64-qt5-serialport
pkg-build mingw-w64-qt5-translations
pkg-build mingw-w64-qt5-webchannel
pkg-build mingw-w64-qt5-websockets
pkg-build mingw-w64-qt5-webglplugin
pkg-build mingw-w64-qt5-xmlpatterns
# pkg-build mingw-w64-qt5-virtualkeyboard
# pkg-build mingw-w64-qt5-webkit

pkg-build mingw-w64-qt5-gamepad-static
pkg-build mingw-w64-qt5-3d-static
pkg-build mingw-w64-qt5-charts-static
pkg-build mingw-w64-qt5-connectivity-static
pkg-build mingw-w64-qt5-datavis3d-static
pkg-build mingw-w64-qt5-graphicaleffects-static
pkg-build mingw-w64-qt5-serialport-static
pkg-build mingw-w64-qt5-location-static
pkg-build mingw-w64-qt5-networkauth-static
pkg-build mingw-w64-qt5-remoteobjects-static
pkg-build mingw-w64-qt5-scxml-static
pkg-build mingw-w64-qt5-sensors-static
pkg-build mingw-w64-qt5-webchannel-static
pkg-build mingw-w64-qt5-websockets-static
pkg-build mingw-w64-qt5-webglplugin-static
pkg-build mingw-w64-qt5-xmlpatterns-static
# pkg-build mingw-w64-qt5-virtualkeyboard-static
