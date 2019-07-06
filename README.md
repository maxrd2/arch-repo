# Docker MinGW build environment and Arch Linux repository

A script to build Arch Linux packages and to publish/update binary repository.

Project contains following PKGBUILDs and binary packages:

- Subtitle Composer, DivvyDroid, PocketSphinx, PacAUR, Dropbox (`x86_64`)
- GCC 9.1.0, BinUtils 2.32, MinGW 6.0.0, configure, CMake, Meson, Wine (`i686-w64-mingw32` `x86_64-w64-mingw32`)
- NSIS 3.04, FFMPEG 4.1.3 (`i686-w64-mingw32` `x86_64-w64-mingw32`)
- Qt 5.13 (`i686-w64-mingw32` `x86_64-w64-mingw32`)
- KF5 5.45.0 (`i686-w64-mingw32` `x86_64-w64-mingw32`)


## Docker build environment

Start the docker container
```
cd dir-with-your-sources
docker run --rm -v "$PWD":/home/devel -it maxrd2/arch-build /bin/bash
```

Here's [pacman HOWTO](https://wiki.archlinux.org/index.php/Pacman) and few examples on installing packages:
```
sudo pacman -Sy # Update package lists
sudo pacman -S mingw-w64-toolchain mingw-w64-configure mingw-w64-cmake # install packages
pacman -Sl maxrd2 # List all packages in a repo
pacman -Ss mingw ffmpeg # Search packages containing "mingw ffmpeg"
```

Build your project:
```
cd my-project
mkdir build && cd build
/usr/bin/i686-w64-mingw32-cmake ..
make -j4
```


## Arch Linux Repository

Add following to /etc/pacman.conf
```
[maxrd2]
SigLevel = Optional TrustAll
Server = https://github.com/maxrd2/arch-repo/releases/download/continuous
```
and then execute `pacman -Sy` to update package list


## Docker image with (MinGW) build environment

You can manually build `maxrd2/arch-build` docker image by executing:
```
git clone https://github.com/maxrd2/arch-repo.git
arch-repo/docker/build.sh
```
Or you can download prebuilt image:
```
docker image pull maxrd2/arch-build
```
