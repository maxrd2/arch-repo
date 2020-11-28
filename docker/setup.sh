#!/bin/bash

set -e
info() { echo -e "\e[1;39m$@\e[m"; }

info "Creating user: devel"
_ps='PS1='\''\[\033[1;34m\]\u@arch-docker\[\033[m\]:\[\033[1;39m\]\w\[\033[m\]\$ '\'''
echo "$_ps" >>/etc/skel/.bashrc
echo -e "$_ps\nexport VISUAL=/usr/bin/vim\nexport PATH="\$HOME/bin:\$PATH"" >>/etc/bash.bashrc
groupmod -g 100 users
useradd -m -d /home/devel -u 1000 -g users -G tty -s /bin/bash devel
#echo 'devel ALL=(ALL) NOPASSWD: /usr/bin/pacman, /usr/bin/makepkg' >>/etc/sudoers
echo 'devel ALL=(ALL) NOPASSWD: ALL' >>/etc/sudoers

info "Setting up pacman"
rm -rf /etc/pacman.d/gnupg
pacman-key --init
echo 'keyserver hkp://pool.sks-keyservers.net' >> /etc/pacman.d/gnupg/gpg.conf
pacman-key --populate archlinux
pacman -Sy archlinux-keyring pacman --noconfirm --noprogressbar --needed --quiet
pacman-db-upgrade

pacman -Sy --noconfirm --noprogressbar pacman-contrib
# select pacman mirrors
curl -s 'https://www.archlinux.org/mirrorlist/?country=DE&country=CH&country=GB&country=US&protocol=https&ip_version=4&use_mirror_status=on' \
	| sed 's|^#||;/^#/ d' | rankmirrors -n 6 - >>/etc/pacman.d/mirrorlist
cat >>/etc/pacman.conf <<EOF
[multilib]
Include = /etc/pacman.d/mirrorlist
[maxrd2]
SigLevel = Optional TrustAll
Server = https://github.com/maxrd2/arch-repo/releases/download/continuous
EOF

info "Updating system packages"
pacman -Syu --noconfirm --noprogressbar --needed --quiet \
	git base-devel python2 wget curl expac yajl vim openssh rsync lzop unzip bash-completion \
	jq imagemagick icoutils

info "Cleaning up"
rm -rf \
	/usr/share/{doc,man}/* \
	/tmp/* \
	/var/{tmp,cache/pacman/pkg,lib/pacman/sync}/* \
	/home/devel/.cache
