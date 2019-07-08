#!/bin/bash

set -e

. "$HOME/bin/include-common.sh"

sect "Adding GPG keys"
gpg-add BB5869F064EA74AB 9766E084FB0F43D8 D605848ED7E69871 C1A60EACE707FDA5 \
	38EE757D69184620 9B432B27D1BA20D7 D5E9E43F7DF9EE8C 5CB4A9347B3B09DC \
	D81C4887F1679A65 7EE0FC4DCC014E3D 2071B08A33BD3F06

sect "Updating pacman databases"
[[ ! -L "$repodir/maxrd2.db" ]] && ln -fs "maxrd2.db.tar.gz" "$repodir/maxrd2.db"
sudo pacman -Sy --noconfirm --needed mingw-w64-toolchain autogen

pkg-build mingw-w64-zlib
pkg-build nsis
pkg-build mingw-w64-aom
pkg-build mingw-w64-bzip2
pkg-build mingw-w64-expat
pkg-build mingw-w64-libffi
pkg-build mingw-w64-pdcurses
pkg-build mingw-w64-readline
pkg-build mingw-w64-pcre
pkg-build mingw-w64-termcap
pkg-build mingw-w64-libiconv
pkg-build mingw-w64-libunistring
pkg-build mingw-w64-gettext
pkg-build mingw-w64-glib2
pkg-build mingw-w64-graphite
pkg-bootstrap mingw-w64-freetype2-bootstrap mingw-w64-freetype2
pkg-build mingw-w64-fontconfig
pkg-build mingw-w64-libpng
pkg-build mingw-w64-pixman
pkg-build mingw-w64-lzo
pkg-build mingw-w64-libjpeg-turbo
pkg-build mingw-w64-jasper
pkg-build mingw-w64-xz
pkg-build mingw-w64-libtiff
pkg-build mingw-w64-gdk-pixbuf2
pkg-build mingw-w64-fribidi
pkg-build mingw-w64-libdatrie
pkg-build mingw-w64-libthai
pkg-bootstrap mingw-w64-cairo-bootstrap mingw-w64-cairo
pkg-build mingw-w64-icu
pkg-build mingw-w64-harfbuzz
pkg-build mingw-w64-libxml2
pkg-build mingw-w64-libcroco
pkg-build mingw-w64-lcms2
pkg-build mingw-w64-openjpeg2
pkg-build mingw-w64-libidn2
pkg-build mingw-w64-libpsl
pkg-build mingw-w64-openssl
pkg-build mingw-w64-libssh2
pkg-build mingw-w64-curl
pkg-build mingw-w64-poppler
pkg-build mingw-w64-pango
pkg-bootstrap mingw-w64-rust-bin
pkg-build mingw-w64-librsvg
pkg-build mingw-w64-cairo mingw-w64-cairo-bootstrap
pkg-build mingw-w64-freetype2 mingw-w64-freetype2-bootstrap
pkg-build mingw-w64-gmp
pkg-build mingw-w64-libtasn1
pkg-build mingw-w64-nettle
pkg-build mingw-w64-p11-kit
pkg-build mingw-w64-gnutls
pkg-build mingw-w64-gsm
pkg-build mingw-w64-lame
pkg-build mingw-w64-libass
pkg-build mingw-w64-libbluray
pkg-build mingw-w64-libmodplug
pkg-build mingw-w64-libsoxr
pkg-build mingw-w64-libogg
pkg-build mingw-w64-libvorbis
pkg-build mingw-w64-libtheora
pkg-build mingw-w64-giflib
pkg-build mingw-w64-vid.stab
pkg-build mingw-w64-libwebp
pkg-build mingw-w64-speexdsp
pkg-build mingw-w64-speex
pkg-build mingw-w64-libvpx
pkg-build mingw-w64-opencore-amr
pkg-build mingw-w64-opus
pkg-build mingw-w64-cmocka
pkg-build mingw-w64-libssh
pkg-build mingw-w64-sdl2
pkg-build mingw-w64-xvidcore
pkg-build mingw-w64-l-smash
pkg-bootstrap mingw-w64-ffmpeg-bootstrap mingw-w64-ffmpeg
pkg-build mingw-w64-x264
pkg-build mingw-w64-x265
pkg-build mingw-w64-ffmpeg mingw-w64-ffmpeg-bootstrap
pkg-remove mingw-w64-rust-bin # it can't create exe... and we needed it for build only... so remove it

# Qt5 / KF5 dependencies
pkg-build mingw-w64-sqlite
pkg-build mingw-w64-dbus
pkg-build mingw-w64-pcre2
pkg-build mingw-w64-postgresql
pkg-build mingw-w64-mariadb-connector-c
pkg-build mingw-w64-vulkan-headers
pkg-build mingw-w64-aspell
pkg-build mingw-w64-hunspell
pkg-build mingw-w64-docbook-wrapper
pkg-build mingw-w64-libgpg-error
pkg-build mingw-w64-libgcrypt
pkg-build mingw-w64-libxslt
pkg-build mingw-w64-ilmbase
pkg-build mingw-w64-openexr

# GStreamer and dependencies
pkg-build mingw-w64-gstreamer
pkg-build mingw-w64-orc
pkg-build mingw-w64-libvisual
pkg-build mingw-w64-gst-plugins-base
pkg-build mingw-w64-gst-libav
pkg-build mingw-w64-glib-networking
pkg-build mingw-w64-libsoup
pkg-build mingw-w64-flac
pkg-build mingw-w64-wavpack
pkg-build mingw-w64-mpg123
pkg-build mingw-w64-gst-plugins-good

# mpv and libmpv
pkg-build mingw-w64-spirv-tools
pkg-build mingw-w64-glslang
pkg-build mingw-w64-shaderc
pkg-build mingw-w64-crossc
pkg-build mingw-w64-mpv
