#!/bin/bash

wget -O peer_cmd.sh https://raw.githubusercontent.com/subutai-io/packer/master/nobridge/provisioning_scripts/en/peer_cmd.sh
wget -O final_message.sh https://raw.githubusercontent.com/subutai-io/packer/master/nobridge/provisioning_scripts/en/final_message.sh
wget -O rhost_message.sh https://raw.githubusercontent.com/subutai-io/packer/master/nobridge/provisioning_scripts/en/rhost_message.sh
wget -O system_checks.sh https://raw.githubusercontent.com/subutai-io/packer/master/nobridge/provisioning_scripts/en/en/system_checks.sh

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
snap install $CMD --devmode --beta

echo "Mounting container storage ..."
/snap/$CMD/current/bin/btrfsinit /dev/mapper/main-btrfs &> /dev/null

if [ "$SUBUTAI_PEER" = "$SUBUTAI_PEER" ]; then
  CMD=$CMD ./peer_cmd.sh
else
  ./rhost_message.sh
fi

CONSOLE_PORT=$CONSOLE_PORT ./final_message.sh
rm *.sh    
