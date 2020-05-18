#!/bin/bash

#DEBIAN_FRONTEND=noninteractive apt-get -q -y install zfsutils

#/sbin/modprobe zfs

#zpool create -f subutai /dev/mapper/main-zfs

#zfs create -o mountpoint="/var/lib/lxc" subutai/fs

#zpool set autoexpand=on subutai

#DEBIAN_FRONTEND=noninteractive apt-get -q -y install lxc dirmngr

#apt-key adv --recv-keys --keyserver keyserver.ubuntu.com C6B2AC7FBEB649F1

######################################################################################
apt -y install linux-headers-$(uname -r)

ln -s /bin/rm /usr/bin/rm

DEBIAN_FRONTEND=noninteractive apt-get -q -y install zfs-dkms zfsutils-linux

/sbin/modprobe zfs

systemctl restart zfs-import-cache
systemctl restart zfs-import-scan
systemctl restart zfs-mount
systemctl restart zfs-share

zpool create -f subutai /dev/mapper/main-zfs

zfs create -o mountpoint="/var/lib/lxc" -o acltype=posixacl subutai/fs

zpool set autoexpand=on subutai

DEBIAN_FRONTEND=noninteractive apt-get -q -y install lxc dirmngr

apt-key adv --recv-keys --keyserver keyserver.ubuntu.com C6B2AC7FBEB649F1