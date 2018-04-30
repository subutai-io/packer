#!/bin/bash

apt -y install zfsutils

/sbin/modprobe zfs

zpool create -f subutai /dev/mapper/main-zfs

zfs create -o mountpoint="/var/lib/lxc" subutai/fs

apt -y install lxc

apt-get -y install dirmngr

apt-key adv --recv-keys --keyserver keyserver.ubuntu.com C6B2AC7FBEB649F1

