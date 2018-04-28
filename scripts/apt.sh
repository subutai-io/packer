#!/bin/bash

echo Updating from repositories ...
sudo apt-get -y update

echo Upgrading distribution ...
sudo apt-get -y dist-upgrade

echo Adding needed packages ...
sudo apt-get -y install net-tools inotify-tools



