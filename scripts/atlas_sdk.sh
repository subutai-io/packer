#!/bin/bash

# Install repository and accept its public keys
sudo sh -c 'echo "deb https://sdkrepo.atlassian.com/debian/ stable contrib" \
    >>/etc/apt/sources.list'
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 \
    --recv-keys B07804338C015B73

# Enable secure apt repositories, update and install atlas sdk
if [[ -f /etc/apt/apt.conf.d/02proxy ]]; then
  sudo mv /etc/apt/apt.conf.d/02proxy /tmp/02proxy
fi

sudo apt-get -y install apt-transport-https
sudo apt-get -y update
sudo apt-get -y install atlassian-plugin-sdk

if [[ -f /tmp/02proxy ]]; then
  sudo mv /tmp/02proxy /etc/apt/apt.conf.d/02proxy
fi

M2_HOME=`atlas-version | grep 'Maven home' | awk '{print $3}'`
echo 'export M2_HOME='"$M2_HOME" >> ~/.bashrc
echo 'export PATH=$PATH:'"$M2_HOME"/bin >> ~/.bashrc


