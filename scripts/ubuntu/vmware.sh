#!/bin/sh -eux

DEBIAN_FRONTEND=noninteractive apt-get -q install -y open-vm-tools;
mkdir /mnt/hgfs;
echo "platform specific vmware.sh executed";
