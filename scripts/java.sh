#!/bin/bash

sudo rm -rf /var/cache/oracle-jdk8-installer
sudo rm -rf /var/lib/dpkg/info/oracle-java8-installer*
sudo apt-get -y purge oracle-java8-installer*
sudo rm /etc/apt/sources.list.d/*java*

sudo apt-get -y install software-properties-common python-software-properties
sudo apt-get update
sudo add-apt-repository -y ppa:webupd8team/java
sudo apt-get update

if [[ -f /etc/apt/apt.conf.d/02proxy ]]; then
  sudo mv /etc/apt/apt.conf.d/02proxy /tmp/02proxy
fi

echo oracle-java8-installer shared/accepted-oracle-license-v1-1 \
   select true | sudo /usr/bin/debconf-set-selections
sudo apt-get -y install oracle-java8-installer

if [[ -f /tmp/02proxy ]]; then
  sudo mv /tmp/02proxy /etc/apt/apt.conf.d/02proxy
fi

echo 'export JAVA_HOME=/usr/lib/jvm/java-8-oracle' >> ~/.bashrc
echo 'export JRE_HOME=/usr/lib/jvm/java-8-oracle/jre' >> ~/.bashrc
export JAVA_HOME=/usr/lib/jvm/java-8-oracle
java -version

