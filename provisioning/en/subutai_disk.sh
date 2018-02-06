#!/usr/bin/env bash

result=`lsblk -o SIZE,NAME | grep "$((DISK_SIZE+2))"G | tail -1`
disk_name=`expr match "$result" '.*\([s][d][b-z]*\)'`

disk="/dev/${disk_name}"

sudo pvcreate "$disk"
sudo vgextend main "$disk"
sudo lvextend -L+$(($DISK_SIZE+1))'G' /dev/mapper/main-btrfs

which btrfs

if [ $? != 0 ]; then
  sudo apt -y install btrfs-tools
fi

sudo btrfs filesystem resize +$DISK_SIZE'g' /var/snap/subutai/common/lxc