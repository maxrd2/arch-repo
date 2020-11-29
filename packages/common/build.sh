#!/bin/bash

set -e

. "$HOME/bin/include-common.sh"

sect "Adding GPG keys"
gpg-add FC918B335044912E 

sect "Updating pacman databases"
[[ ! -L "$repodir/maxrd2.db" ]] && ln -fs "maxrd2.db.tar.gz" "$repodir/maxrd2.db"
sudo pacman -Syu --noconfirm --needed

pkg-build pod2man
pkg-build auracle-git
pkg-build pacaur
pkg-build dropbox
#pkg-build megasync
