#!/usr/bin/env bash

DEBIAN_FRONTEND=noninteractive apt-get -q -y install zfsutils-linux

/sbin/modprobe zfs

zpool create -f subutai /dev/mapper/main-zfs

zfs create -o mountpoint="/var/lib/lxc" subutai/fs

zpool set autoexpand=on subutai

DEBIAN_FRONTEND=noninteractive apt-get -q -y install lxc dirmngr

apt-key adv --recv-keys --keyserver keyserver.ubuntu.com C6B2AC7FBEB649F1

