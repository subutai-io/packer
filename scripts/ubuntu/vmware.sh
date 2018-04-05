#!/bin/sh -eux

apt-get install -y open-vm-tools;
mkdir /mnt/hgfs;
echo "platform specific vmware.sh executed";
