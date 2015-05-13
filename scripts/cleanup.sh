#!/bin/bash

sudo apt-get -y autoremove

sudo dpkg -l 'linux-*' | sed '/^ii/!d;/'"$(uname -r | sed "s/\(.*\)-\([^0-9]\+\)/\1/")"'/d;s/^[^ ]* [^ ]* \([^ ]*\).*/\1/;/[0-9]/!d' | xargs sudo apt-get -y purge

echo "cleaning up dhcp leases"
sudo rm /var/lib/dhcp/*
rm ~/*.init

if [ -f /home/vagrant/shutdown.sh ]; then
  sudo rm /home/vagrant/shutdown.sh
fi

if [ -f /home/vagrant/download.sh ]; then
  sudo rm /home/vagrant/download.sh
fi

if [ -f /home/vagrant/VBoxGuestAdditions.iso ]; then
  sudo rm /home/vagrant/VBoxGuestAdditions.iso
fi

if [ -f /home/vagrant/node-v0.12.2-linux-x86.tar.gz ]; then
  sudo rm /home/vagrant/node-v0.12.2-linux-x86.tar.gz
fi

if [ -f /home/vagrant/prl-tools-lin.iso ]; then
  sudo rm /home/vagrant/prl-tools-lin.iso
fi


exit
