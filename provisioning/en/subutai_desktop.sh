#!/usr/bin/env bash

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

echo "Installing GoogleChrome"
# install chrome
CHROME_PACKAGE=google-chrome-stable_current_amd64.deb
wget --no-cache -O /home/subutai/$CHROME_PACKAGE https://cdn.subutai.io:8338/kurjun/rest/raw/get?name=$CHROME_PACKAGE >/dev/null 2>&1

if [ -f /home/subutai/$CHROME_PACKAGE ]; then
  DEBIAN_FRONTEND=noninteractive apt install -q -y /home/subutai/$CHROME_PACKAGE

  # clean package
  rm /home/subutai/$CHROME_PACKAGE
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
case $SUBUTAI_ENV in
  sysnet)
    CC_PACKAGE=subutai-control-center-dev.deb
    ;;
  dev*)
    CC_PACKAGE=subutai-control-center-dev.deb
    ;;
  master)
    CC_PACKAGE=subutai-control-center-master.deb
    ;;
  prod*)
    CC_PACKAGE=subutai-control-center.deb
    ;;
  *)
    CC_PACKAGE=subutai-control-center.deb
esac

wget --no-cache -O /home/subutai/$CC_PACKAGE https://cdn.subutai.io:8338/kurjun/rest/raw/get?name=$CC_PACKAGE >/dev/null 2>&1
DEBIAN_FRONTEND=noninteractive apt-get install -q -y libssl1.0-dev

if [ -f /home/subutai/$CC_PACKAGE ]; then
  DEBIAN_FRONTEND=noninteractive apt install -q -y /home/subutai/$CC_PACKAGE

  # clean package
  rm /home/subutai/$CC_PACKAGE
fi

# after installing MATE desktop, system should reboot
echo "\nSuccessfully installed Debian Mate Desktop and SubutaiControlCenter."

echo "\e[33m\n\nReboot OS required. Please reboot OS by following command:\n\nvagrant reload\n\e[0m"