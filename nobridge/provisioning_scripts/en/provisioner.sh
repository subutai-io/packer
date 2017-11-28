#!/bin/bash

base="https://raw.githubusercontent.com/subutai-io/packer/master/nobridge/provisioning_scripts/en/"

wget -O peer_cmd.sh $base/peer_cmd.sh >/dev/null 2>&1
wget -O final_message.sh $base/final_message.sh >/dev/null 2>&1
wget -O rhost_message.sh $base/rhost_message.sh >/dev/null 2>&1
wget -O system_checks.sh $base/system_checks.sh >/dev/null 2>&1
wget -O insecure.sh $base/insecure.sh >/dev/null 2>&1

chmod +x *.sh

case $SUBUTAI_ENV in
  dev*)
    CMD="subutai-dev"
    ;;
  stage)
    CMD="subutai-master"
    ;;
  master)
    CMD="subutai-master"
    ;;
  prod*)
    CMD="subutai"
    ;;
  *)
    CMD="subutai"
esac

echo "Installing $CMD Snap ..."

if [ -n "$(snap list | grep subutai)" ]; then
  snap install $CMD --devmode --beta 2> snap.err
  if [ $? -ne 0 ]; then exit 1; fi
else
  echo "Snap Installed: refreshing ..."
  snap refresh $CMD
fi

df -h /dev/mapper/main-btrfs
if [ $? -ne 0 ]; then
  echo "Mounting container storage ..."
  /snap/$CMD/current/bin/btrfsinit /dev/mapper/main-btrfs &> /dev/null
  if [ $? -ne 0 ]; then exit 1; fi
  sleep 2
else
  echo "Container storage already mounted."
fi

if [ "$ALLOW_INSECURE" = true ]; then
  CMD=$CMD ./insecure.sh
  if [ $? -ne 0 ]; then exit 1; fi
fi

if [ "$SUBUTAI_PEER" = true ]; then
  CMD=$CMD ./peer_cmd.sh
  if [ $? -ne 0 ]; then exit 1; fi
else
  ./rhost_message.sh
fi

CONSOLE_PORT=$CONSOLE_PORT ./final_message.sh
rm *.sh    
