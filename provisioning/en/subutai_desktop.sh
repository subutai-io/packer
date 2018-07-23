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
DEBIAN_FRONTEND=noninteractive apt-get -q install firefox-esr

# install CC
wget --no-cache -O subutai_control_center.deb https://cdn.subutai.io:8338/kurjun/rest/raw/get?name=subutai-control-center.deb >/dev/null 2>&1
DEBIAN_FRONTEND=noninteractive apt install -q -y ~/subutai-control-center.deb