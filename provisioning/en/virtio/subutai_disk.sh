#!/usr/bin/env bash

# Get size and name of disk (vdb, vdc, etc)
result=`lsblk -o SIZE,NAME --bytes | grep "$((1073741824*(DISK_SIZE+2)))" | tail -1`

disk_name=`expr match "$result" '.*\([v][d][b-z]*\)'`

if [ -z "$disk_name" ]; then
  echo ' ==> [ERROR] Not found disk'
  exit 1
else
  disk="/dev/${disk_name}"
  echo ' ==> [OK] Added new virtual disk '$disk
  sudo zpool set autoexpand=on subutai
  sudo zpool add -f subutai "$disk"
fi
