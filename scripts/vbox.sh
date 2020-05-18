#!/usr/bin/env bash
echo "==> Installing VirtualBox guest additions"

# Assuming the following packages are installed
DEBIAN_FRONTEND=noninteractive apt-get -q install -y linux-headers-$(uname -r) build-essential perl dkms

VBOX_VERSION=$(cat /home/${SSH_USERNAME}/.vbox_version)
mount -o loop /home/${SSH_USERNAME}/VBoxGuestAdditions_$VBOX_VERSION.iso /mnt
sh /mnt/VBoxLinuxAdditions.run
umount /mnt
rm /home/${SSH_USERNAME}/VBoxGuestAdditions_$VBOX_VERSION.iso
rm /home/${SSH_USERNAME}/.vbox_version

# TODO fix this version shit
if [[ $VBOX_VERSION = "4.3.10" ]]; then
    ln -s /opt/VBoxGuestAdditions-4.3.10/lib/VBoxGuestAdditions /usr/lib/VBoxGuestAdditions
fi
