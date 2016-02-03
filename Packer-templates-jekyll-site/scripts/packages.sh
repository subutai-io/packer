#!/bin/bash

echo Updating and installing packages
sudo apt-get update > /dev/null
sudo apt-get install -y git-core curl zlib1g-dev build-essential libssl-dev \
  libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev \
  libcurl4-openssl-dev python-software-properties libffi-dev > /dev/null
sudo apt-get remove -y ruby > /dev/null
