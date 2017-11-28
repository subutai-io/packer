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

cmd_path="$(which $CMD)"

if [ -n "$cmd_path" ]; then
  echo "Snap $CMD is installed, refreshing ..."
  snap refresh $CMD
else
  echo "Installing $CMD Snap ..."
  snap install $CMD --devmode --beta
  cmd_path="$(which $CMD)"
fi

if [ -z "$cmd_path" ]; then
  echo "[WARNING] Snap $CMD installation failed aborting!"
  exit 1;
fi

if [ -z "$(grep main-btrfs /proc/mounts)" ]; then
  echo "Mounting container storage ..."
  /snap/$CMD/current/bin/btrfsinit /dev/mapper/main-btrfs -f #&> /dev/null
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
#rm *.sh    
