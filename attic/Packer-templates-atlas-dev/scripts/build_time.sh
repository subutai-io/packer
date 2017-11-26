#!/bin/bash

if [ -f /home/vagrant/vagrant_box_build_time ]; then
  sudo rm /home/vagrant/vagrant_box_build_time
fi

sudo date > /home/vagrant/vagrant_box_build_time
