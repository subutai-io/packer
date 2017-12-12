#!/bin/bash

# Special interfaces for VBox
sudo cp /tmp/virtualbox-interfaces /etc/network/virtualbox-interfaces
sudo cp /tmp/virtualbox-interfaces /etc/network/interfaces
sudo cp /tmp/fix-vagrant.service /etc/systemd/system/fix-vagrant.service
sudo cp /tmp/fix-vagrant /etc/network/fix-vagrant
sudo chmod +x /etc/network/fix-vagrant
sudo systemctl enable fix-vagrant.service
sudo systemctl start fix-vagrant.service