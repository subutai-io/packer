#!/bin/bash

echo --------------------------------------------------------------------------
echo Before resizing:
sudo df -h /home
echo --------------------------------------------------------------------------
sudo lvextend -L+2G /dev/mapper/main-home
sudo resize2fs /dev/mapper/main-home
echo --------------------------------------------------------------------------
echo After resizing:
sudo df -h /home
echo --------------------------------------------------------------------------
