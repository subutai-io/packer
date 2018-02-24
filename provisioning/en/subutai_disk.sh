#!/usr/bin/env bash

disk_name=`lsblk -o NAME | tail -1`

disk="/dev/${disk_name}"

sudo pvcreate "$disk"
sudo vgextend main "$disk"
sudo lvextend -L+$(($DISK_SIZE+1))'G' /dev/mapper/main-btrfs

which btrfs

if [ $? != 0 ]; then
  sudo apt -y install btrfs-tools
fi

sudo btrfs filesystem resize +$DISK_SIZE'g' /var/snap/subutai*/common/lxc