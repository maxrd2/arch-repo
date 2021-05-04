# Based on ArchLinux image - https://gitlab.archlinux.org/archlinux/archlinux-docker/
# sudo docker build -t maxrd2/arch-build -f Dockerfile .

FROM library/archlinux:base

COPY setup.sh /opt/maxrd2/
RUN /opt/maxrd2/setup.sh

USER devel
ENV HOME=/home/devel
WORKDIR /home/devel

ONBUILD USER root
ONBUILD WORKDIR /
