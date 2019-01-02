#!/bin/bash

if [ "$PROVISION" = "false" ]; then
    exit 0;
fi

# install mate-desktop
echo "Installing mate-desktop"
DEBIAN_FRONTEND=noninteractive apt-get -q install mate-desktop -y

echo "Installing mate-session-manager"
# install mate-session-manager
DEBIAN_FRONTEND=noninteractive apt-get -q install mate-session-manager -y

echo "Installing mate-applets"
# install mate-applets
DEBIAN_FRONTEND=noninteractive apt-get -q install mate-applets -y

echo "Installing mate-backgrounds"
# install mate-backgrounds
DEBIAN_FRONTEND=noninteractive apt-get -q install mate-backgrounds -y

echo "Installing mate-control-center"
# install mate-control-center
DEBIAN_FRONTEND=noninteractive apt-get -q install mate-control-center -y

echo "Installing mate-desktop-environment"
# install mate-desktop-environment
DEBIAN_FRONTEND=noninteractive apt-get -q install mate-desktop-environment -y
DEBIAN_FRONTEND=noninteractive apt-get -q install lightdm -y

# TODO - add more
echo "Installing hypervisor desktop tools"
if [ -z "`which virt-what`" ]; then
  DEBIAN_FRONTEND=noninteractive apt-get -q install virt-what -y
fi

HYPERVISOR=`virt-what`
case $HYPERVISOR in
  vmware)
    echo "Installing open-vm-tools for vmware hypervisor"
    DEBIAN_FRONTEND=noninteractive apt-get -q install open-vm-tools open-vm-tools-desktop open-vm-tools-dkms -y
    ;;
  *)
    echo "Unknown hypervisor: $HYPERVISOR"
    ;;
esac

echo "Installing GoogleChrome"
# install chrome
CHROME_PACKAGE=google-chrome-stable_current_amd64.deb
wget -nv -O $HOME/$CHROME_PACKAGE "https://masterbazaar.subutai.io/rest/v1/cdn/raw?name=$CHROME_PACKAGE&latest&download"

if [ -f $HOME/$CHROME_PACKAGE ]; then
  DEBIAN_FRONTEND=noninteractive apt install -q -y $HOME/$CHROME_PACKAGE

  # clean package
  rm $HOME/$CHROME_PACKAGE
fi

echo "Installing E2E plugin"
touch /home/subutai/ffddnlbamkjlbngpekmdpnoccckapcnh.json
echo "{\"external_update_url\": \"https://clients2.google.com/service/update2/crx\"}" >> /home/subutai/ffddnlbamkjlbngpekmdpnoccckapcnh.json


if [ -f /home/subutai/ffddnlbamkjlbngpekmdpnoccckapcnh.json ]; then
  mkdir -p /opt/google/chrome/extensions;
  cp -p /home/subutai/ffddnlbamkjlbngpekmdpnoccckapcnh.json /opt/google/chrome/extensions/
fi

echo "Installing SubutaiControlCenter"
# install CC
DEBIAN_FRONTEND=noninteractive apt-get install -q -y subutai-control-center
DEBIAN_FRONTEND=noninteractive apt-get install -q -y libssl1.0-dev

# add subutai wallpaper
DTBASE='https://raw.githubusercontent.com/subutai-io/packer/master/provisioning/en/desktop'
wget --no-cache -O /usr/local/bin/check_wallpaper.sh "$DTBASE/check_wallpaper.sh" >/dev/null 2>&1
chmod 755 /usr/local/bin/check_wallpaper.sh
mkdir -p /home/subutai/.config/autostart
chown -R subutai:subutai /home/subutai/.config
wget --no-cache -O /home/subutai/.config/autostart/check_wallpaper.desktop "$DTBASE/check_wallpaper.desktop" >/dev/null 2>&1
wget --no-cache -O /home/subutai/wallpaper.jpg "$DTBASE/wallpaper.jpg" >/dev/null 2>&1

# after installing MATE desktop, system should reboot
echo ""
echo "Successfully installed Debian Mate Desktop and SubutaiControlCenter."
echo ""
echo "WARNING: OS reboot required. Please issue the vagrant reload command:"
echo ""
echo "vagrant reload"
echo ""
echo ""