# last LVM volume defined 'hack' gets all space we need to delete
sudo df -h
sudo umount /tmp/hack
sudo lvremove -f main/hack
cat /etc/fstab | grep -v main-hack > /tmp/fstab
sudo rm /etc/fstab
sudo cp /tmp/fstab /etc/fstab

# does not work and not needed
# sudo grub-installer grub-installer/bootdev string /dev/vda

sudo apt-get -y autoremove

sudo dpkg -l 'linux-*' | sed '/^ii/!d;/'"$(uname -r | sed "s/\(.*\)-\([^0-9]\+\)/\1/")"'/d;s/^[^ ]* [^ ]* \([^ ]*\).*/\1/;/[0-9]/!d' | xargs sudo apt-get -y purge

echo "cleaning up dhcp leases"
sudo rm /var/lib/dhcp/*

echo "cleaning up udev rules"
sudo rm -f /etc/udev/rules.d/70-persistent-net.rules
sudo mkdir /etc/udev/rules.d/70-persistent-net.rules
sudo rm -rf /dev/.udev/
sudo rm /lib/udev/rules.d/75-persistent-net-generator.rules

#sudo echo "pre-up sleep 2" >> /etc/network/interfaces
if [ -e ~/shutdown.sh ]; then
  rm ~/shutdown.sh
fi
exit
