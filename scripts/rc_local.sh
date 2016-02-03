#!/bin/bash

# updates /etc/rc.local to do a check for the local proxy server I use
# which is installed by default. If the proxy server configuration is
# present this will check if the proxy is actually there. If it is no 
# problem, if it is not then the file is removed.
#
# this is a good approach since this will run one ping to check in user
# environments on the first start where the proxy is not found, once it
# is removed, this code will be disabled since the 02proxy file disappears.
#
# for my environment this a bit of a pita since the check and ping will
# always execute when the virtual machine box is used. this is ok for me
# to deal with.

cat <<EOT > /tmp/rc.local
#!/bin/bash
#
# rc.local
#
# This script is executed at the end of each multiuser runlevel.
# Make sure that the script will "exit 0" on success or any other
# value on error.
# 
# It checks if a ubuntu proxy server is present in the environment or not.
# If the proxy server is not present then the proxy server configuration
# file in /etc/apt/apt.conf.d/02proxy that was installed on installation
# is removed.

if [ -e /etc/apt/apt.conf.d/02proxy ]; then
  ping -c 1 $APT_PROXY_HOST
  if [ "\$?" -ne 0 ]; then
    rm /etc/apt/apt.conf.d/02proxy
  fi
fi
exit 0
EOT

chmod +x /tmp/rc.local
sudo rm /etc/rc.local
sudo cp /tmp/rc.local /etc/rc.local

