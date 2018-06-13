#!/bin/bash

echo Updating from repositories ...
sudo DEBIAN_FRONTEND=noninteractive apt-get -q -y update

echo Upgrading distribution ...
sudo DEBIAN_FRONTEND=noninteractive apt-get -q -y dist-upgrade

echo Adding needed packages ...
sudo DEBIAN_FRONTEND=noninteractive apt-get -q -y install net-tools inotify-tools



