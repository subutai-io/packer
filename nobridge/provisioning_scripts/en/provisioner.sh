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
snap install $CMD --devmode --beta 2> snap.err

if [ $? > 0 ]; then
  snap_errcode=$?

  # TODO use another internationalized script for this
  if [ -n "$(cat snap.stderr | grep 'x509: certificate signed by unknown authority')" ]; then
    echo "It seems you're using a local CDN cache node with a self signed certiifcate."

    if [ "$CMD" == "subutai-dev" || "$CMD" == "subutai-master" ]; then
      echo "You're not using production so I'll enable insecure CDN downloads for you now."
      config="/var/snap/$CMD/current/agent.gcfg"
      /bin/cat $config \
        | sed -e 's/Allowinsecure.*/Allowinsecure = true/g' \
        > $config.new
      mv $config $config.bak
      mv $config.new $config
      echo "Trying management import again ..."
      snap install $CMD --devmode --beta 2> snap.err
      if [ $? > 0 ]; then
        (>&2 cat snap.err)
        exit $?
      fi
    else
      echo "You must enable the allowInsecure property in the subutai.yaml file allow insecure CDN use."
      (>&2 cat snap.err)
      exit $snap_errcode
    fi
  fi

  (>&2 cat snap.err)
  exit $snap_errcode
fi

echo "Mounting container storage ..."
/snap/$CMD/current/bin/btrfsinit /dev/mapper/main-btrfs &> /dev/null

if [ "$SUBUTAI_PEER" == "$SUBUTAI_PEER" ]; then
  CMD=$CMD ./peer_cmd.sh
else
  ./rhost_message.sh
fi

CONSOLE_PORT=$CONSOLE_PORT ./final_message.sh
rm *.sh    
