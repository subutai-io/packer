#!/bin/bash

base="https://raw.githubusercontent.com/subutai-io/packer/master/private_nat/provisioning_scripts/en/"

wget --no-cache -O peer_cmd.sh $base/peer_cmd.sh >/dev/null 2>&1
wget --no-cache -O final_message.sh $base/final_message.sh >/dev/null 2>&1
wget --no-cache -O rhost_message.sh $base/rhost_message.sh >/dev/null 2>&1
wget --no-cache -O system_checks.sh $base/system_checks.sh >/dev/null 2>&1
wget --no-cache -O insecure.sh $base/insecure.sh >/dev/null 2>&1

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
elif [ -f "/home/subutai/subutai.snap" ]; then
  echo "Provisioning custom snap ..."
  snap install --dangerous /home/subutai/subutai.snap --devmode --beta
  if [ $? -ne 0 ]; then
    >&2 echo "[ERROR] Exiting due to custom snap installation failure."
    exit 1
  elif [ -z "$(which $CMD)" ]; then
    installed_env="$(ls /snap | grep subutai | sed -e 's/subutai//g' -e 's/-//g')"
    specified_env="$(echo $CMD | sed 's/subutai//g' -e 's/-//g')"
    if [ "$installed_env" != "$specified_env" ]; then
      >&2 echo "[WARNING] The custom snap uses the $installed_env but the $specified_env was specified."
      >&2 echo "[WARNING] ADAPTING, BUT change your subutai.yaml settings or reprovisioning will fail."
      CMD="$(ls /snap | grep subutai)"
    fi
    >&2 echo "[ERROR] Cannot find $CMD executable after snap installation."
    >&2 echo "[ERROR] Exiting due to custom snap installation problems."
    exit 1
  fi
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
rm -f import.err *.sh    
