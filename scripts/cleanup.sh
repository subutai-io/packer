#!/bin/bash

if [ -z "$BRANCHTAG" ]; then
  echo 'ERROR: $BRANCHTAG parameter not specified'
  exit -1
fi

sudo apt-get -y autoremove

# seems this is removing everything we install
#sudo dpkg -l 'linux-*' | sed '/^ii/!d;/'"$(uname -r | sed "s/\(.*\)-\([^0-9]\+\)/\1/")"'/d;s/^[^ ]* [^ ]* \([^ ]*\).*/\1/;/[0-9]/!d' | xargs sudo apt-get -y purge

echo "cleaning up dhcp leases"
sudo rm /var/lib/dhcp/*

echo "cleaning up pgp keys"
rm -rf /var/snap/subutai$BRANCHTAG/current/.gnupg/

# remove the proxy configuration for local apt-cacher-ng setup
if [ -f /etc/apt/apt.conf.d/02proxy ]; then
  sudo rm -f /etc/apt/apt.conf.d/02proxy;
fi
