#!/bin/bash

echo Updating from repositories ...
sudo apt-get -y update

echo Upgrading distribution ...
sudo apt-get -y dist-upgrade

echo Adding needed packages ...
sudo apt-get -y install net-tools snapd inotify-tools

echo Installing btrfs tool
sudo apt-get -y install btrfs-tools