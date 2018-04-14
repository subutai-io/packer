#!/bin/bash

# ln -s /dev/null /etc/systemd/network/99-default.link
echo 'GRUB_TIMEOUT=0' >> /etc/default/grub
#echo 'GRUB_CMDLINE_LINUX_DEFAULT=""' >> /etc/default/grub
# echo 'GRUB_CMDLINE_LINUX="net.ifnames=0"' >> /etc/default/grub

if [ -f "/etc/lsb-release" -a -n "$(grep xenial /etc/lsb-release)" ]; then
  echo 'GRUB_CMDLINE_LINUX_DEFAULT="apparmor=0 audit=0"' >> /etc/default/grub
fi

update-grub2
