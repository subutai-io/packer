#!/bin/bash

ln -s /dev/null /etc/systemd/network/99-default.link
echo 'GRUB_TIMEOUT=0' >> /etc/default/grub
#echo 'GRUB_CMDLINE_LINUX_DEFAULT=""' >> /etc/default/grub
#echo 'GRUB_CMDLINE_LINUX="net.ifnames=0"' >> /etc/default/grub
update-grub2
