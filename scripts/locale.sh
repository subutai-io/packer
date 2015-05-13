#!/bin/bash

# Fix Ubuntu 14.04 locales problem
echo Installing locales
sudo locale-gen en_US.UTF-8 > /dev/null
sudo dpkg-reconfigure locales > /dev/null
