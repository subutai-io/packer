#!/bin/bash

if [ -z "$BRANCHTAG" ]; then
  echo 'ERROR: $BRANCHTAG parameter not specified'
  exit -1
fi

apt-get -y autoremove

# seems this is removing everything we install
#sudo dpkg -l 'linux-*' | sed '/^ii/!d;/'"$(uname -r | sed "s/\(.*\)-\([^0-9]\+\)/\1/")"'/d;s/^[^ ]* [^ ]* \([^ ]*\).*/\1/;/[0-9]/!d' | xargs sudo apt-get -y purge

echo "cleaning up dhcp leases"
rm /var/lib/dhcp/*

echo "cleaning up pgp keys"
rm -rf /var/snap/subutai$BRANCHTAG/current/.gnupg/

echo "Remove the proxy configuration for local apt-cacher-ng setup"
if [ -f /etc/apt/apt.conf.d/02proxy ]; then
  rm -f /etc/apt/apt.conf.d/02proxy;
fi

echo "Replacing /etc/apt/sources.list with standard sources"
cp /tmp/sources.list /etc/apt/sources.list
apt-get update

echo "auto ens5" >> /etc/network/interfaces
echo "iface ens5 inet dhcp" >> /etc/network/interfaces