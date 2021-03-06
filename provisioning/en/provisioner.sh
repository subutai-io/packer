#!/bin/bash

# Write provisioning steps to file for ControlCenter
if [ -d "/vagrant/.vagrant/" ]; then
  echo 1 > /vagrant/.vagrant/provision_step
fi

echo '------------------------------------------------------------------'
echo 'User Specified Parameters:'
echo '------------------------------------------------------------------'
echo 'PROVISION                = '$PROVISION
echo 'SUBUTAI_PEER             = '$SUBUTAI_PEER
echo 'DESIRED_CONSOLE_PORT     = '$DESIRED_CONSOLE_PORT
echo 'DESIRED_SSH_PORT         = '$DESIRED_SSH_PORT
echo 'SUBUTAI_ENV              = '$SUBUTAI_ENV
echo 'SUBUTAI_RAM              = '$SUBUTAI_RAM
echo 'SUBUTAI_CPU              = '$SUBUTAI_CPU
echo 'SUBUTAI_DESKTOP          = '$SUBUTAI_DESKTOP
echo 'SUBUTAI_MAN_TMPL         = '$SUBUTAI_MAN_TMPL
echo 'BRIDGE                   = '$BRIDGE
echo 'AUTHORIZED_KEYS          = '$AUTHORIZED_KEYS
echo
echo '------------------------------------------------------------------'
echo 'Run Generated Parameters:'
echo '------------------------------------------------------------------'
echo '_CONSOLE_PORT            = '$_CONSOLE_PORT
echo '_BRIDGED                 = '$_BRIDGED
echo '_BASE_MAC                = '$_BASE_MAC
echo '_ALT_MANAGEMENT_MD5      = '$_ALT_MANAGEMENT_MD5
echo '_ALT_MANAGEMENT_MD5_LAST = '$_ALT_MANAGEMENT_MD5_LAST
echo '_ALT_MANAGEMENT          = '$_ALT_MANAGEMENT
echo

if [ "$PROVISION" = "false" ]; then
    echo Provisioning has been disabled, existing with SUCCESS
    exit 0;
fi

base="https://raw.githubusercontent.com/subutai-io/packer/stage/provisioning/en/"

wget --no-cache -O peer_cmd.sh $base/peer_cmd.sh >/dev/null 2>&1
wget --no-cache -O final_message.sh $base/final_message.sh >/dev/null 2>&1
wget --no-cache -O rhost_message.sh $base/rhost_message.sh >/dev/null 2>&1
wget --no-cache -O system_checks.sh $base/system_checks.sh >/dev/null 2>&1
wget --no-cache -O insecure.sh $base/insecure.sh >/dev/null 2>&1

chmod +x *.sh

case $SUBUTAI_ENV in
  sysnet)
    ENV="sysnet"
    ;;
  dev*)
    ENV="dev"
    ;;
  master)
    ENV="master"
    ;;
  prod*)
    ENV="prod"
    ;;
  *)
    ENV="prod"
esac

CMD="subutai"

cmd_path="$(which $CMD)"

if [ -n "$cmd_path" ]; then
  echo "$CMD is installed"
else
  echo "----------------------------------------------------------------------------------------------"
  echo " Requirements for \"rng-tools.service\" are handled automatically during Subutai installation."
  echo "                   You may ignore failure notices regarding this tool."
  echo "----------------------------------------------------------------------------------------------"

  echo "Installing $CMD ..."

  # Add subutai source list
  echo "deb http://deb.subutai.io/subutai $ENV main" > /etc/apt/sources.list.d/subutai.list

  # Load zfs kernel module
  /sbin/modprobe zfs

  DEBIAN_FRONTEND=noninteractive apt-get -q -y update && DEBIAN_FRONTEND=noninteractive apt-get -q -y upgrade
  DEBIAN_FRONTEND=noninteractive apt-get -q -y install subutai
  cmd_path="$(which $CMD)"
fi

if [ -z "$cmd_path" ]; then
  echo "[WARNING] $CMD installation failed aborting!"
  exit 1;
fi

# IPFS CACHE
if [ -f /etc/subutai/agent.conf ]; then
  sed 's/TemplateDownloadUrl = https*/TemplateDownloadUrl = http/gI' -i /etc/subutai/agent.conf
  systemctl restart subutai
fi

# Write provisioning steps to file for ControlCenter
if [ -d "/vagrant/.vagrant" ]; then
  echo 2 > /vagrant/.vagrant/provision_step
fi

if [ -z "$(sudo zpool list | grep subutai)" ]; then
  echo "Mounting container storage ..."
  zpool create -f subutai /dev/mapper/main-zfs
  zfs create -o mountpoint="/var/lib/lxc" subutai/fs
  zpool set autoexpand=on subutai
  
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

# Write provisioning steps to file for ControlCenter
if [ -d "/vagrant/.vagrant" ]; then
  echo 3 > /vagrant/.vagrant/provision_step
fi

_CONSOLE_PORT=$_CONSOLE_PORT \
   _BRIDGED=$_BRIDGED ./final_message.sh

rm -f import.err *.sh