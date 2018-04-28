#!/bin/bash

apt -y install zfsutils

/sbin/modprobe zfs

#zpool create -f subutai /dev/mapper/main-zfs

#zfs create -o mountpoint="/var/lib/subutai/lxc" subutai/fs

#apt -y install lxc

#echo "lxc.lxcpath=/var/lib/subutai/lxc" >> /etc/lxc/lxc.conf

# apt-get -y install dirmngr

#apt-key adv --recv-keys --keyserver keyserver.ubuntu.com C6B2AC7FBEB649F1

#apt update && apt -y install subutai