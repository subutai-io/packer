#!/bin/bash

/bin/cat <<EOM
Provisioning management capabilities (converting RH into peer)
This might take a little time ...
EOM

/snap/bin/$CMD import management 2> import.err

if [ "$?" -ne "0" ]; then
  errcode=$?

  if [ -n "$(cat import.err | grep 'x509: certificate signed by unknown authority')" ]; then
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
      /snap/bin/$CMD import management
      if [ "$?" -ne "0" ]; then
        exit $?
      fi
    else
      echo "You must enable the allowInsecure property in the subutai.yaml file allow insecure CDN use."
      (>&2 cat import.err)
      exit $errcode
    fi
  fi

  (>&2 cat import.err)
  exit $errcode
fi

/bin/cat <<EOM
SUCCESS: Your peer is up. Welcome to the Horde!
-----------------------------------------------

Next steps ...
EOM