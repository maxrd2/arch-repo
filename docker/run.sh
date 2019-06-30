#!/bin/bash

set -e

[[ $EUID -ne 0 ]] && echo 'ERROR: script requires root privileges.' 1>&2 && exit 1

cd "$(dirname "$0")/.."

modprobe zram
dev=$(sudo zramctl -f -s 12G)
mkfs.ext4 -L build $dev >/dev/null
mount -t ext4 $dev build
chown max.users build
docker run --rm -v "$PWD":/home/devel -it maxrd2/arch-build /bin/bash || true
umount $dev
zramctl -r $dev
