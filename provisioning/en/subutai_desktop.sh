#!/usr/bin/env bash

# install mate-desktop
DEBIAN_FRONTEND=noninteractive apt-get -q install mate-desktop -y

# install mate-session-manager
DEBIAN_FRONTEND=noninteractive apt-get -q install mate-session-manager -y

# install mate-applets
DEBIAN_FRONTEND=noninteractive apt-get -q install mate-applets -y

# install mate-backgrounds
DEBIAN_FRONTEND=noninteractive apt-get -q install mate-backgrounds -y

# install mate-control-center
DEBIAN_FRONTEND=noninteractive apt-get -q install mate-control-center -y

# install mate-desktop-environment
DEBIAN_FRONTEND=noninteractive apt-get -q install mate-desktop-environment -y
DEBIAN_FRONTEND=noninteractive apt-get -q install lightdm -y

# install firefox-esr
DEBIAN_FRONTEND=noninteractive apt-get -q update
DEBIAN_FRONTEND=noninteractive apt-get -q -y install firefox-esr

# install CC
# dev https://cdn.subutai.io:8338/kurjun/rest/raw/get?name=subutai-control-center-dev.deb
# master https://cdn.subutai.io:8338/kurjun/rest/raw/get?name=subutai-control-center-master.deb
# prod https://cdn.subutai.io:8338/kurjun/rest/raw/get?name=subutai-control-center.deb

case $SUBUTAI_ENV in
  sysnet)
    CC_PACKAGE="subutai-control-center-dev.deb"
    ;;
  dev*)
    CC_PACKAGE="subutai-control-center-dev.deb"
    ;;
  master)
    CC_PACKAGE="subutai-control-center-master.deb"
    ;;
  prod*)
    CC_PACKAGE="subutai-control-center.deb"
    ;;
  *)
    CC_PACKAGE="subutai-control-center.deb"
esac

wget --no-cache -O /home/subutai/CC_PACKAGE https://cdn.subutai.io:8338/kurjun/rest/raw/get?name=CC_PACKAGE >/dev/null 2>&1
DEBIAN_FRONTEND=noninteractive apt-get install -q -y libssl1.0-dev
DEBIAN_FRONTEND=noninteractive apt install -q -y /home/subutai/CC_PACKAGE