echo "==> Installing VirtualBox guest additions"

# Assuming the following packages are installed
apt-get install -y linux-headers-$(uname -r) build-essential perl
apt-get install -y dkms

VBOX_VERSION=$(cat /home/${SSH_USERNAME}/.vbox_version)
mount -o loop /home/${SSH_USERNAME}/VBoxGuestAdditions_$VBOX_VERSION.iso /mnt
sh /mnt/VBoxLinuxAdditions.run
umount /mnt
rm /home/${SSH_USERNAME}/VBoxGuestAdditions_$VBOX_VERSION.iso
rm /home/${SSH_USERNAME}/.vbox_version

if [[ $VBOX_VERSION = "4.3.10" ]]; then
    ln -s /opt/VBoxGuestAdditions-4.3.10/lib/VBoxGuestAdditions /usr/lib/VBoxGuestAdditions
fi