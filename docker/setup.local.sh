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
cat >/etc/pacman.d/mirrorlist <<EOF
Server = http://192.168.1.5:15678/pacman/\$repo/\$arch
Server = http://archlinux.iskon.hr/\$repo/os/\$arch
EOF
cat >>/etc/pacman.conf <<EOF
[multilib]
Include = /etc/pacman.d/mirrorlist
EOF

info "Updating system packages"
pacman -Syy # force refresh package database
pacman -Su --noconfirm --noprogressbar --needed --quiet \
	git base-devel python2 wget curl expac yajl vim openssh rsync lzop unzip bash-completion \
	jq imagemagick icoutils

info "Setting up local repo"
cat >>/etc/pacman.conf <<EOF
[maxrd2]
SigLevel = Optional TrustAll
Server = file:///home/devel/.repo
EOF
mkdir /home/devel/.repo
tar -czf /home/devel/.repo/maxrd2.db -T /dev/null
chown devel.users -Rf /home/devel/.repo
pacman -Sy --noconfirm --noprogressbar --quiet

info "Cleaning up"
rm -rf \
	/usr/share/{doc,man}/* \
	/tmp/* \
	/var/{tmp,cache/pacman/pkg}/* \
	/home/devel/.cache
